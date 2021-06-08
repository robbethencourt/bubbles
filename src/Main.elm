module Main exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav
import Data.User as User
import Data.WaterDetails as WaterDetails
import Html exposing (button, div, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Ports
import Route
import Url
import Views.AppView as AppView
import Views.Loading as Loading
import Views.NotFound as NotFound



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Route.Page
    , appViewModel : AppView.Model
    , errorModal : Route.ErrorModal
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( appViewInitModel, appViewCmd ) =
            AppView.init User.tempUser WaterDetails.tempWaterDetails

        cmds =
            Cmd.batch
                [ Cmd.map AppViewMsg appViewCmd ]
    in
    ( { key = key
      , url = url
      , page = Route.Loading Route.Show
      , appViewModel = appViewInitModel
      , errorModal = Route.NoError
      }
    , cmds
    )



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | TransitionPage Route.Page
    | SetPage Route.Page
    | AppViewMsg AppView.Msg
    | DataFromOutside Ports.PortDataStructure
    | RefetchUserAndWaterDetails


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    -- not pretty, but it works. Would be better to figure out internal links
                    -- that have .html pages and have elm know when to load those instead
                    if url.path == "/about.html" then
                        ( model, Nav.load url.path )

                    else
                        ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model
                | url = url
                , page = updatePageTransition model.page
              }
            , Route.transitionFromPage model.page <| SetPage (Route.urlToPage (Url.toString url))
            )

        TransitionPage page ->
            ( { model | page = updatePageTransition model.page }, Route.transitionFromPage model.page <| SetPage page )

        SetPage page ->
            let
                appViewModel =
                    model.appViewModel

                ( updatedPage, cmd ) =
                    Route.authedRedirect page appViewModel.user
            in
            ( { model | page = updatedPage }, cmd )

        AppViewMsg subMsg ->
            let
                ( appViewModel, cmd ) =
                    AppView.update subMsg model.appViewModel
            in
            ( { model | appViewModel = appViewModel }, Cmd.map AppViewMsg cmd )

        DataFromOutside data ->
            case Ports.toJsMsg data.action of
                Ports.ErrorMessage ->
                    ( { model | errorModal = Route.HasError <| Ports.decodeError data.data }, Cmd.none )

                Ports.GetInitialUserAndWaterDetailsSuccess ->
                    case Ports.decodeJsSuccessData data.data of
                        Err _ ->
                            ( { model | errorModal = Route.HasError "error" }, Cmd.none )

                        Ok decodedWaterDetails ->
                            let
                                appViewModel =
                                    model.appViewModel
                            in
                            ( { model
                                | appViewModel = { appViewModel | waterDetails = decodedWaterDetails }
                              }
                              {- using the location stored in the model as I need the initial url to display once the page loads. Not sure what page the user is on, so need to store this so upon a refresh we show the page the user was just on and not a default page -}
                              -- , Route.transitionFromPage model.page <| TransitionPage <| Route.locationToPage model.refreshLocation
                            , Route.transitionFromPage model.page <| TransitionPage <| Route.urlToPage (Url.toString model.url)
                            )

                Ports.GetUserAndWaterDetailsSuccess ->
                    case Ports.decodeJsSuccessData data.data of
                        Err _ ->
                            ( { model | errorModal = Route.HasError "error" }, Cmd.none )

                        Ok decodedWaterDetails ->
                            let
                                appViewModel =
                                    model.appViewModel
                            in
                            ( { model
                                | appViewModel = { appViewModel | waterDetails = decodedWaterDetails }
                                , errorModal = Route.NoError
                              }
                            , Cmd.none
                            )

                Ports.StoreCleared ->
                    ( { model
                        | appViewModel = { user = User.tempUser, waterDetails = WaterDetails.tempWaterDetails }
                        , errorModal = Route.NoError
                      }
                    , Cmd.none
                    )

                Ports.NoMatchingJsMsg ->
                    ( { model | errorModal = Route.HasError "Woops! Looks like something went wrong." }, Cmd.none )

        RefetchUserAndWaterDetails ->
            ( model, Ports.encodeDataForOutside Ports.GetUserAndWaterDetails )



-- update helper functions


updatePageTransition : Route.Page -> Route.Page
updatePageTransition page =
    case page of
        Route.Nav transition ->
            Route.Nav <| Route.toggleTransition transition

        Route.Loading transition ->
            Route.Loading <| Route.toggleTransition transition

        Route.DailyBubbles transition ->
            Route.DailyBubbles <| Route.toggleTransition transition

        Route.Profile transition ->
            Route.Profile <| Route.toggleTransition transition

        _ ->
            page



---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Water Bubbles App"
    , body =
        [ div []
            [ case model.errorModal of
                Route.HasError _ ->
                    div [ class "error-modal -has-error" ]
                        [ div [ class "error-modal-content" ]
                            [ p [] [ text <| "Woops! data wasn't saved. Dismiss this error and try again." ]
                            , button [ onClick RefetchUserAndWaterDetails ] [ text "Dismiss" ]
                            ]
                        ]

                Route.NoError ->
                    div [ class "error-modal -no-error" ] []
            , case model.page of
                Route.NotFound ->
                    NotFound.view

                Route.Loading transition ->
                    Loading.view (transition |> Route.toString)

                Route.DailyBubbles _ ->
                    Html.map AppViewMsg (AppView.view model.appViewModel model.page)

                Route.Profile _ ->
                    Html.map AppViewMsg (AppView.view model.appViewModel model.page)

                Route.Nav _ ->
                    Html.map AppViewMsg (AppView.view model.appViewModel model.page)
            ]
        ]
    }



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ Ports.dataForElm DataFromOutside ]
