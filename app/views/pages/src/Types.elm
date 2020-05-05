module Types exposing (..)


type alias Model =
    { disc : Int
    , cards : List Card
    }


type alias Card =
    ( Int, Bool )


type alias Update =
    { disc : Maybe Int
    }


type Msg
    = NewUpdate Update
