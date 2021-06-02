module Views.NotFound exposing (..)

import Html exposing (Html, a, div, h1, text)
import Html.Attributes exposing (class)
import Route


view : Html msg
view =
    div [ class "not-found" ]
        [ h1 [] [ text "Woops! Looks like this page is missing. Click the link below to return to the water tracking page." ]
        , a [ class "button", Route.href <| Route.DailyBubbles Route.Show ] [ text "Home" ]
        ]
