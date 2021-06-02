module Views.AppView exposing (..)

import Data.User as User
import Data.WaterDetails as WaterDetails
import Html exposing (Html, a, div, header)
import Html.Attributes exposing (class)
import Ports
import Route
import Views.DailyBubbles as DailyBubbles
import Views.Logo as Logo
import Views.Nav as Nav
import Views.Profile as Profile


type alias Model =
    { user : User.User
    , waterDetails : WaterDetails.WaterDetails
    }


init : User.User -> WaterDetails.WaterDetails -> ( Model, Cmd Msg )
init user waterDetails =
    ( { user = user
      , waterDetails = waterDetails
      }
    , Cmd.none
    )



-- update


type Msg
    = PreviousPage
    | AddToTodayWater Int
    | SubtractFromTodayWater Int
    | AddToGoal Int
    | SubtractFromGoal Int
    | AddToWaterBottle Int
    | SubtractFromWaterBottle Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PreviousPage ->
            ( model, Cmd.none )

        AddToTodayWater ounces ->
            let
                newModel =
                    ounces
                        |> setTodayWater model.waterDetails (+)
                        |> setGoalReached
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateWaterDetails newModelWaterDetails.todayWater newModelWaterDetails.goalReached )

        SubtractFromTodayWater ounces ->
            let
                newModel =
                    ounces
                        |> setTodayWater model.waterDetails (-)
                        |> setGoalReached
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateWaterDetails newModelWaterDetails.todayWater newModelWaterDetails.goalReached )

        AddToGoal ounces ->
            let
                newModel =
                    ounces
                        |> setGoal model.waterDetails (+)
                        |> setGoalReached
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateGoal newModelWaterDetails.goal newModelWaterDetails.goalReached )

        SubtractFromGoal ounces ->
            let
                newModel =
                    ounces
                        |> setGoal model.waterDetails (-)
                        |> setGoalReached
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateGoal newModelWaterDetails.goal newModelWaterDetails.goalReached )

        AddToWaterBottle ounces ->
            let
                newModel =
                    ounces
                        |> setWaterBottleSize model.waterDetails (+)
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateWaterBottleSize newModelWaterDetails.waterBottleSize )

        SubtractFromWaterBottle ounces ->
            let
                newModel =
                    ounces
                        |> setWaterBottleSize model.waterDetails (-)
                        |> setWaterDetails model

                newModelWaterDetails =
                    newModel.waterDetails
            in
            ( newModel, Ports.encodeDataForOutside <| Ports.UpdateWaterBottleSize newModelWaterDetails.waterBottleSize )



-- Update Helpers and Nested Record updates


setTodayWater : WaterDetails.WaterDetails -> (Int -> Int -> Int) -> Int -> WaterDetails.WaterDetails
setTodayWater waterDetails f ounces =
    { waterDetails | todayWater = WaterDetails.calculateNewOunces f waterDetails.todayWater ounces }


setGoal : WaterDetails.WaterDetails -> (Int -> Int -> Int) -> Int -> WaterDetails.WaterDetails
setGoal waterDetails f ounces =
    { waterDetails | goal = WaterDetails.calculateNewOunces f waterDetails.goal ounces }


setWaterBottleSize : WaterDetails.WaterDetails -> (Int -> Int -> Int) -> Int -> WaterDetails.WaterDetails
setWaterBottleSize waterDetails f ounces =
    { waterDetails | waterBottleSize = WaterDetails.calculateNewOunces f waterDetails.waterBottleSize ounces }


setGoalReached : WaterDetails.WaterDetails -> WaterDetails.WaterDetails
setGoalReached newWaterDetails =
    { newWaterDetails | goalReached = WaterDetails.checkGoalReached newWaterDetails.goal newWaterDetails.todayWater }


setWaterDetails : Model -> WaterDetails.WaterDetails -> Model
setWaterDetails model newWaterDetails =
    { model | waterDetails = newWaterDetails }



-- View


view : Model -> Route.Page -> Html Msg
view model page =
    div []
        [ header_
        , case page of
            Route.DailyBubbles transition ->
                DailyBubbles.view
                    (transition |> Route.toString |> String.toLower)
                    model.waterDetails
                    AddToTodayWater
                    SubtractFromTodayWater

            Route.Profile transition ->
                let
                    waterDetails =
                        model.waterDetails
                in
                Profile.view
                    (transition |> Route.toString |> String.toLower)
                    model.user
                    waterDetails.todayWater
                    waterDetails.goal
                    waterDetails.waterBottleSize
                    AddToGoal
                    SubtractFromGoal
                    AddToWaterBottle
                    SubtractFromWaterBottle

            Route.Nav transition ->
                Nav.view
                    (transition |> Route.toString |> String.toLower)
                    model.user
                    model.waterDetails
                    PreviousPage
                    AddToTodayWater
                    SubtractFromTodayWater

            _ ->
                div [] []
        ]


header_ : Html Msg
header_ =
    header [ class "app-header" ]
        [ div [ class "logo-container" ]
            [ Logo.logo ]
        , a [ class "nav-icon", Route.href <| Route.Nav Route.Show ]
            [ div [ class "nav-bar" ] []
            , div [ class "nav-bar" ] []
            , div [ class "nav-bar" ] []
            ]
        ]
