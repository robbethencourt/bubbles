port module Ports exposing (..)

import Data.WaterDetails as WaterDetails
import Json.Decode as Decode
import Json.Encode as Encode


type ElmMsg
    = UpdateWaterBottleSize Int
    | UpdateWaterDetails Int WaterDetails.GoalReached
    | UpdateGoal Int WaterDetails.GoalReached
    | GetUserAndWaterDetails


{-| encodeDataForOutside gets called from update in Main.elm
and then the port gets called once the data has been encoded
-}
encodeDataForOutside : ElmMsg -> Cmd msg
encodeDataForOutside data =
    case data of
        UpdateWaterBottleSize waterBottleSize ->
            dataForOutside { action = "UpdateWaterBottleSize", data = Encode.int waterBottleSize }

        UpdateWaterDetails todayWater goalReached ->
            let
                updateWaterDetailsData =
                    Encode.object
                        [ ( "todayWater", Encode.int todayWater )
                        , ( "goalReached", Encode.string <| WaterDetails.toString goalReached )
                        ]
            in
            dataForOutside { action = "UpdateWaterDetails", data = updateWaterDetailsData }

        UpdateGoal goal goalReached ->
            let
                udpatedGoalAndGoalReached =
                    Encode.object
                        [ ( "goal", Encode.int goal )
                        , ( "goalReached", Encode.string <| WaterDetails.toString goalReached )
                        ]
            in
            dataForOutside { action = "UpdateGoal", data = udpatedGoalAndGoalReached }

        GetUserAndWaterDetails ->
            dataForOutside { action = "GetUserAndWaterDetails", data = Encode.string "" }



-- decode data from js


decodeError : Encode.Value -> String
decodeError jsonStr =
    case Decode.decodeValue Decode.string jsonStr of
        Err _ ->
            "Woops! Looks like an error saving to the databse. Try again."

        Ok errorData ->
            errorData


decodeJsSuccessData : Encode.Value -> Result Decode.Error WaterDetails.WaterDetails
decodeJsSuccessData jsWaterDetails =
    Decode.decodeValue decodeWaterDetails jsWaterDetails


decodeWaterDetails : Decode.Decoder WaterDetails.WaterDetails
decodeWaterDetails =
    Decode.map5 WaterDetails.WaterDetails
        (Decode.field "date" Decode.string)
        (Decode.field "waterBottleSize" Decode.int)
        (Decode.field "goal" Decode.int)
        (Decode.field "goalReached" decodeGoalReached)
        (Decode.field "todayWater" Decode.int)


decodeGoalReached : Decode.Decoder WaterDetails.GoalReached
decodeGoalReached =
    Decode.string
        |> Decode.andThen
            (\str ->
                case String.toLower str of
                    "notreached" ->
                        Decode.succeed WaterDetails.NotReached

                    "reached" ->
                        Decode.succeed WaterDetails.Reached

                    noMatchingGoalReachedValue ->
                        Decode.fail <| "Not a value for GoalReached " ++ noMatchingGoalReachedValue
            )


type JsMsg
    = ErrorMessage
    | GetInitialUserAndWaterDetailsSuccess
    | GetUserAndWaterDetailsSuccess
    | StoreCleared
    | NoMatchingJsMsg


toJsMsg : String -> JsMsg
toJsMsg str =
    case str of
        "ErrorMessage" ->
            ErrorMessage

        "GetInitialUserAndWaterDetailsSuccess" ->
            GetInitialUserAndWaterDetailsSuccess

        "GetUserAndWaterDetailsSuccess" ->
            GetUserAndWaterDetailsSuccess

        "StoreCleared" ->
            StoreCleared

        _ ->
            NoMatchingJsMsg


type alias PortDataStructure =
    { action : String
    , data : Encode.Value
    }


port dataForOutside : PortDataStructure -> Cmd msg


port dataForElm : (PortDataStructure -> msg) -> Sub msg
