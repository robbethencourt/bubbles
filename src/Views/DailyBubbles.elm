module Views.DailyBubbles exposing (..)

import Data.WaterDetails as WaterDetails
import Html exposing (Html, button, div, p, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Svg
import Svg.Attributes exposing (height, width)


view : String -> WaterDetails.WaterDetails -> (Int -> msg) -> (Int -> msg) -> Html msg
view transitionClassName wd addToTodayWater subtractFromTodayWater =
    div [ class <| "daily-bubbles" ]
        [ div [ class <| "-bubble-pink " ++ transitionClassName ] []
        , div [ class <| "-bubble-blue " ++ transitionClassName ] []
        , div [ class <| "daily-bubbles-display center " ++ transitionClassName ]
            [ Svg.svg [ width "300", height "300" ]
                [ Svg.defs []
                    [ Svg.linearGradient [ Svg.Attributes.id "pinkCircle" ]
                        [ Svg.stop [ Svg.Attributes.offset "0%", Svg.Attributes.stopColor "#5cd0f7" ] []
                        , Svg.stop [ Svg.Attributes.offset "100%", Svg.Attributes.stopColor "#5cd0f7" ] []
                        ]
                    , Svg.linearGradient [ Svg.Attributes.id "blueCircle" ]
                        [ Svg.stop [ Svg.Attributes.offset "0%", Svg.Attributes.stopColor "#00a8e8" ] []
                        , Svg.stop [ Svg.Attributes.offset "100%", Svg.Attributes.stopColor "#5cd0f7" ] []
                        ]
                    ]
                , Svg.circle
                    [ Svg.Attributes.fill "none"
                    , Svg.Attributes.stroke "url(#pinkCircle)"
                    , Svg.Attributes.strokeWidth "25"
                    , Svg.Attributes.cx "150"
                    , Svg.Attributes.cy "150"
                    , Svg.Attributes.r "100"
                    ]
                    []
                , Svg.circle
                    [ Svg.Attributes.fill "none"
                    , Svg.Attributes.stroke "url(#blueCircle)"
                    , Svg.Attributes.strokeWidth "25"
                    , Svg.Attributes.cx "150"
                    , Svg.Attributes.cy "150"
                    , Svg.Attributes.r "100"
                    , Svg.Attributes.strokeLinecap "round"
                    , Svg.Attributes.strokeDasharray (String.fromFloat ((*) 620 <| toFloat wd.todayWater / toFloat wd.goal) ++ " 630")
                    , Html.Attributes.style "stroke-dashoffset" "0"
                    , if wd.todayWater == 0 then
                        Html.Attributes.style "opacity" "0"

                      else
                        Html.Attributes.style "opacity" "1"
                    , Svg.Attributes.class "progress-circle -blue-circle"
                    ]
                    []
                , Svg.text_
                    [ Svg.Attributes.stroke "#455155"
                    , Svg.Attributes.strokeWidth "3"
                    , Svg.Attributes.fill "#455155"
                    , Svg.Attributes.fontSize "80"
                    , Svg.Attributes.textAnchor "middle"
                    , Svg.Attributes.x "150"
                    , Svg.Attributes.y "177"
                    , Svg.Attributes.class <| "progress-circle-text " ++ (wd.goalReached |> WaterDetails.toString)
                    ]
                    [ text <| String.fromInt wd.todayWater ]
                ]
            ]
        , div [ class <| "today-goal-display " ++ transitionClassName ]
            [ p [ class "today-goal-display-p" ]
                [ span [ class <| "-goal-text " ++ (wd.goalReached |> WaterDetails.toString) ] [ text "Today's Goal " ]
                , span [ class "-goal-amount" ] [ text (String.fromInt wd.goal) ]
                ]
            ]
        , div [ class <| "action-buttons " ++ transitionClassName ]
            [ button [ class "-decrease outline", onClick <| subtractFromTodayWater wd.waterBottleSize ] [ text "decrease" ]
            , button [ class "-increase", onClick <| addToTodayWater wd.waterBottleSize ] [ text "increase" ]
            ]
        , case wd.goalReached of
            WaterDetails.NotReached ->
                text ""

            WaterDetails.Reached ->
                div [ class "goal-reached-bubbles-animation" ]
                    [ div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    , div [ class <| "-bubble-blue reached" ] []
                    ]
        ]
