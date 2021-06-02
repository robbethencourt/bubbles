module Route exposing (ErrorModal(..), Page(..), Transition(..), authedRedirect, href, toString, toggleTransition, transitionFromPage, urlToPage)

import Data.User as User
import Html exposing (Attribute)
import Html.Attributes as Attr
import Process
import Task
import Url
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


type Page
    = NotFound
    | Loading Transition
    | DailyBubbles Transition
    | Profile Transition
    | Nav Transition


type Transition
    = Show
    | Remove


type ErrorModal
    = HasError String
    | NoError



-- urls


pageParser : Parser (Page -> a) a
pageParser =
    oneOf
        [ map (DailyBubbles Show) top
        , map (DailyBubbles Show) (s "dailyBubbles")
        , map (Profile Show) (s "profile")
        , map (Nav Show) (s "nav")
        ]


pageToHash : Page -> String
pageToHash page =
    case page of
        NotFound ->
            "404"

        Loading _ ->
            "loading"

        DailyBubbles _ ->
            "dailyBubbles"

        Profile _ ->
            "profile"

        Nav _ ->
            "nav"


pageTransitionTime : Page -> Float
pageTransitionTime page =
    case page of
        NotFound ->
            0

        Loading _ ->
            650

        DailyBubbles _ ->
            350

        Profile _ ->
            350

        Nav _ ->
            450



-- public


urlToPage : String -> Page
urlToPage string =
    case Url.fromString string of
        Nothing ->
            NotFound

        Just url ->
            Maybe.withDefault NotFound (parse pageParser url)


href : Page -> Attribute msg
href page =
    Attr.href (pageToHash page)


authedRedirect : Page -> User.User -> ( Page, Cmd msg )
authedRedirect page user =
    case user of
        User.NotAuthed ->
            ( DailyBubbles Remove, Cmd.none )

        User.Authed _ ->
            ( page, Cmd.none )


transitionFromPage : Page -> msg -> Cmd msg
transitionFromPage page msg =
    let
        time =
            page |> pageTransitionTime
    in
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


toggleTransition : Transition -> Transition
toggleTransition transition =
    case transition of
        Show ->
            Remove

        Remove ->
            Show


toString : Transition -> String
toString transition =
    case transition of
        Show ->
            "show"

        Remove ->
            "remove"
