module Views.Logo exposing (..)

import Svg exposing (Svg, circle, linearGradient, path, stop, svg)
import Svg.Attributes exposing (class, cx, cy, d, fill, gradientUnits, id, offset, r, stopColor, stroke, strokeLinecap, strokeLinejoin, strokeMiterlimit, strokeWidth, viewBox, x1, x2, y1, y2)


logo : Svg msg
logo =
    svg [ viewBox "0 0 200 100", class "logo" ]
        [ Svg.path [ fill "#26C8FF", d "M59.309 42.481s.074-1.804 2.227-1.804 2.26 1.804 2.26 1.804v18.27c1.431-1.105 4.422-3.706 9.232-3.706 8.192 0 12.809 7.022 12.809 14.499 0 9.558-6.047 15.864-15.734 15.864-3.706 0-7.412-.78-10.793-2.21V42.481zm4.486 39.791c3.316 1.17 6.112 1.17 6.697 1.17 6.111 0 10.728-4.876 10.728-11.508 0-6.242-4.031-10.924-9.103-10.924-2.146 0-5.396 1.105-8.322 4.292v16.97zM124.783 42.481s.073-1.804 2.227-1.804c2.152 0 2.26 1.804 2.26 1.804v18.27c1.43-1.105 4.422-3.706 9.232-3.706 8.191 0 12.809 7.022 12.809 14.499 0 9.558-6.047 15.864-15.734 15.864-3.707 0-7.412-.78-10.793-2.21V42.481zm4.487 39.791c3.316 1.17 6.111 1.17 6.697 1.17 6.111 0 10.727-4.876 10.727-11.508 0-6.242-4.031-10.924-9.102-10.924-2.146 0-5.396 1.105-8.322 4.292v16.97zM158.506 42.481s.073-1.804 2.227-1.804c2.152 0 2.26 1.804 2.26 1.804v18.27c1.43-1.105 4.422-3.706 9.232-3.706 8.191 0 12.809 7.022 12.809 14.499 0 9.558-6.047 15.864-15.734 15.864-3.707 0-7.412-.78-10.793-2.21V42.481zm4.486 39.791c3.316 1.17 6.111 1.17 6.697 1.17 6.111 0 10.727-4.876 10.727-11.508 0-6.242-4.031-10.924-9.102-10.924-2.146 0-5.396 1.105-8.322 4.292v16.97zM191.752 42.481s.073-1.804 2.227-1.804c2.152 0 2.26 1.804 2.26 1.804v18.27M111.844 86.823v-4.421c-2.146 2.86-5.007 5.006-9.168 5.006-6.566 0-10.468-4.812-10.468-12.354V57.63s-.063-1.88 2.265-1.88c2.406 0 2.222 1.88 2.222 1.88v17.035c0 4.941 1.886 8.777 7.021 8.777 1.69 0 5.396-.521 8.128-5.137V57.63s-.11-1.88 2.28-1.88 2.207 1.88 2.207 1.88v29.193s.003 1.291-2.295 1.291c-2.173 0-2.192-1.291-2.192-1.291z" ] []
        , path [ fill "#26C8FF", d "M196.237 86.823s0 1.213-2.265 1.213c-2.094 0-2.221-1.213-2.221-1.213V42.481h4.485v44.342zM229.461 72.52H207.81c0 7.021 4.877 10.923 10.468 10.923 5.722 0 9.298-2.926 10.729-4.096 0 0 1.092.002 1.326 1.596.263 1.784-1.326 2.955-1.326 2.955-1.82 1.235-5.071 3.511-11.248 3.511-9.753 0-14.564-7.412-14.564-15.279 0-10.143 6.762-15.084 13.394-15.084 7.218 0 12.874 5.917 12.874 14.435v1.039zm-4.616-3.251c-.65-6.307-4.941-8.258-8.127-8.258-3.642 0-7.543 2.341-8.647 8.258h16.774zM252.477 64.002c-2.86-1.756-5.396-2.991-8.257-2.991-2.991 0-4.941 1.756-4.941 3.771 0 2.341 2.016 3.316 8.973 6.957 1.561.845 5.331 2.926 5.331 7.477 0 2.926-2.341 8.192-9.622 8.192-3.446 0-6.307-1.04-9.363-2.665 0 0-1.78-.816-1.421-2.832s1.421-1.785 1.421-1.785c4.812 2.926 7.867 3.316 9.428 3.316 2.275 0 4.941-1.431 4.941-3.901 0-2.796-2.666-4.161-6.502-5.981-3.575-1.69-7.672-3.771-7.672-8.647 0-3.576 2.926-7.867 9.362-7.867 4.031 0 6.827 1.626 8.322 2.471 0 0 .793.63.699 2.302s-.699 2.183-.699 2.183z" ] []
        , circle [ fill "none", stroke "#C0F6FF", strokeWidth "10.5", strokeMiterlimit "10", cx "25.007", cy "63.883", r "18.412" ] []
        , linearGradient [ id "a", gradientUnits "userSpaceOnUse", x1 "6.737", y1 "63.883", x2 "48.669", y2 "63.883" ] [ stop [ offset "0", stopColor "#4ADDFF" ] [], stop [ offset "1", stopColor "#26C8FF" ] [] ]
        , Svg.path [ fill "none", stroke "url(#a)", strokeWidth "10.5", strokeLinecap "round", strokeLinejoin "round", strokeMiterlimit "10", d "M25.007 45.47c5.084 0 9.688 2.061 13.02 5.393a18.355 18.355 0 0 1 5.393 13.02c0 5.084-2.061 9.688-5.393 13.02s-7.936 5.393-13.02 5.393a18.357 18.357 0 0 1-13.02-5.393" ] []
        , circle [ fill "#88E9FF", cx "32.928", cy "32.768", r "4.175" ] []
        , circle [ fill "#4ADDFF", cx "47.02", cy "25.513", r "5.721" ] []
        , circle [ fill "#26C8FF", cx "38.683", cy "8.821", r "7.577" ] []
        ]
