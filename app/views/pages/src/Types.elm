module Types exposing (..)


type alias Model =
    { disc : Int
    , hand : List Card
    }


type alias Card =
    ( Int, Bool )


type alias Update =
    { disc : Maybe Int
    , hand : Maybe (List Int)
    }


type Msg
    = NewUpdate Update
