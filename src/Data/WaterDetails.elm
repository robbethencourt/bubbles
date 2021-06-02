module Data.WaterDetails exposing (..)


type GoalReached
    = NotReached
    | Reached


type alias WaterDetails =
    { date : String
    , waterBottleSize : Int
    , goal : Int
    , goalReached : GoalReached
    , todayWater : Int
    }



-- should be changned o initWaterDetails to match the initial view of the app


tempWaterDetails : WaterDetails
tempWaterDetails =
    WaterDetails "December 30, 2017" 28 120 NotReached 0


calculateNewOunces : (Int -> Int -> Int) -> Int -> Int -> Int
calculateNewOunces f currentTodayWater ounces =
    let
        newTodayWater =
            f currentTodayWater ounces
    in
    if newTodayWater < 0 then
        0

    else
        newTodayWater


checkGoalReached : Int -> Int -> GoalReached
checkGoalReached currentTodayWater newTodayWater =
    if currentTodayWater <= newTodayWater then
        Reached

    else
        NotReached


toString : GoalReached -> String
toString goalReached =
    case goalReached of
        Reached ->
            "reached"

        NotReached ->
            "notreached"
