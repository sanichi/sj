module Types exposing (..)


type alias Setup =
    { player : Maybe Int
    }


type alias Update =
    { pack : Maybe Int
    , disc : Maybe Int
    , hand : Maybe (List Int)
    }


type alias Card =
    ( Int, Bool )


type alias Model =
    { player : Int
    , pack : Card
    , disc : Card
    , hand : List Card
    }


type Msg
    = NewUpdate Update
