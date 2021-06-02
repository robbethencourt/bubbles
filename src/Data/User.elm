module Data.User exposing (..)


type User
    = NotAuthed
    | Authed UserProfile


type alias UserProfile =
    { userId : String
    , name : String
    , avatar : String
    }



-- should be changned o initUserProfile to match the initial view of the app


tempUser : User
tempUser =
    Authed <| UserProfile "12345" "Happy Bubbles User" "bubbles-profile-default.png"
