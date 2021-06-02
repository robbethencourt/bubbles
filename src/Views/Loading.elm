module Views.Loading exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


view : String -> Html msg
view transitionClassName =
    div [ class <| "loading " ++ transitionClassName ]
        [ div [ class "-bubble-blue" ] []
        , div [ class "-bubble-pink" ] []
        , div [ class "-bubble-blue" ] []
        ]
