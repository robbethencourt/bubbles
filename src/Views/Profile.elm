module Views.Profile exposing (..)

import Data.User as User
import Html exposing (Html, div, h3, p, span, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Svg
import Svg.Attributes


view : String -> User.User -> Int -> Int -> Int -> (Int -> msg) -> (Int -> msg) -> (Int -> msg) -> (Int -> msg) -> Html msg
view transitionClassName user todayWater goal waterBottleSize addtoGoal subtractFromGoal addtoWaterBottleSize subtractFromWaterBottleSize =
    case user of
        User.NotAuthed ->
            div [] [ text "woops! doesn't look like you're logged in!" ]

        -- want to put a small wave at top of goal adjustments and then mimic the bubbles in the logo
        User.Authed _ ->
            div [ class "profile" ]
                [ div [ class <| "profile-header " ++ transitionClassName ]
                    [ Svg.svg [ Svg.Attributes.width "100", Svg.Attributes.height "100" ]
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
                            , Svg.Attributes.strokeWidth "15"
                            , Svg.Attributes.cx "50"
                            , Svg.Attributes.cy "50"
                            , Svg.Attributes.r "25"
                            ]
                            []
                        , Svg.circle
                            [ Svg.Attributes.fill "none"
                            , Svg.Attributes.stroke "url(#blueCircle)"
                            , Svg.Attributes.strokeWidth "15"
                            , Svg.Attributes.cx "50"
                            , Svg.Attributes.cy "50"
                            , Svg.Attributes.r "25"
                            , Svg.Attributes.strokeLinecap "round"
                            , Svg.Attributes.strokeDasharray (String.fromFloat ((*) 150 <| toFloat todayWater / toFloat goal) ++ " 155")
                            , Html.Attributes.style "stroke-dashoffset" "0"
                            , if todayWater == 0 then
                                Html.Attributes.style "opacity" "0"

                              else
                                Html.Attributes.style "opacity" "1"
                            , Svg.Attributes.class "progress-circle -blue-circle"
                            ]
                            []
                        ]
                    , h3 [ class "user-name" ] [ text "Settings" ]
                    , h3 [ class "today-water" ] [ text <| String.fromInt todayWater ++ "oz so far today" ]
                    ]
                , div [ class <| "profile-content -goal-adjustments " ++ transitionClassName ]
                    [ p [ class <| "section-heading " ++ transitionClassName ]
                        [ span [ class "current-amount" ] [ text <| String.fromInt goal ]
                        , span [ class "amount-description" ] [ text "Goal" ]
                        ]
                    , div [ class <| "adjustment-buttons " ++ transitionClassName ]
                        [ p [ class "profile-button", onClick <| subtractFromGoal 2 ] [ text "-2oz" ]
                        , p [ class "profile-button", onClick <| subtractFromGoal 10 ] [ text "-10oz" ]
                        , p [ class "profile-button", onClick <| addtoGoal 10 ] [ text "+10oz" ]
                        , p [ class "profile-button", onClick <| addtoGoal 2 ] [ text "+2oz" ]
                        ]
                    ]
                , div [ class <| "profile-content -water-bottle-adjustments " ++ transitionClassName ]
                    [ p [ class <| "section-heading " ++ transitionClassName ]
                        [ span [ class "current-amount" ] [ text <| String.fromInt waterBottleSize ]
                        , span [ class "amount-description" ] [ text "Water Bottle Size" ]
                        ]
                    , div [ class <| "adjustment-buttons " ++ transitionClassName ]
                        [ p [ class "profile-button", onClick <| subtractFromWaterBottleSize 2 ] [ text "-2oz" ]
                        , p [ class "profile-button", onClick <| subtractFromWaterBottleSize 10 ] [ text "-10oz" ]
                        , p [ class "profile-button", onClick <| addtoWaterBottleSize 10 ] [ text "+10oz" ]
                        , p [ class "profile-button", onClick <| addtoWaterBottleSize 2 ] [ text "+2oz" ]
                        ]
                    ]
                ]
