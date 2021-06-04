module Views.Nav exposing (..)

import Data.User as User
import Data.WaterDetails as WaterDetails
import Html exposing (Html, a, button, div, li, nav, span, text, ul)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onClick)
import Route


view : String -> User.User -> WaterDetails.WaterDetails -> msg -> (Int -> msg) -> (Int -> msg) -> Html msg
view transitionClassName _ waterDetails _ addtoTodayWater subtractFromTodayWater =
    div [ class <| "navigation-menu " ++ transitionClassName ]
        [ div [ class "nav-bubbles-container" ]
            [ div [ class "-bubble-pink" ] []
            , div [ class "-bubble-pink" ] []
            , div [ class "-bubble-blue" ] []
            ]
        , nav []
            [ ul [ class <| "nav-menu-list " ++ transitionClassName ]
                [ li [ class "list-item" ]
                    [ a [ Route.href <| Route.DailyBubbles Route.Show, class "list-link" ] [ text "Today's Bubbles" ] ]
                , li [ class "list-item" ]
                    [ a [ Route.href <| Route.Profile Route.Show, class "list-link" ]
                        [ text "Adjust Settings" ]
                    ]
                , li [ class "list-item" ]
                    [ button [ onClick <| addtoTodayWater 2, class "list-link outline -white" ] [ text "+ 2 oz to today's bubbles" ] ]
                , li [ class "list-item -non-link" ]
                    [ span [ class "ounces-today-today-water" ]
                        [ text <| String.fromInt waterDetails.todayWater ]
                    , text
                        " oz so far today"
                    ]
                , li [ class "list-item" ]
                    [ button [ onClick <| subtractFromTodayWater 2, class "list-link outline -white" ] [ text "- 2 oz to today's bubbles" ] ]
                , li [ class "list-item" ]
                    [ a [ class "list-link", href "http://www.pilatesboutiquefl.com/product/support-bubbles/", target "_blank" ] [ text "Support Bubbles" ] ]
                , li [ class "list-item" ]
                    [ a [ class "list-link", href "https://www.waterbubbles.me/about/about.html" ] [ text "About" ] ]
                ]
            ]
        ]
