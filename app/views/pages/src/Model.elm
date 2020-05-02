module Model exposing (..)


type alias Model =
    { currentDiscard : Int
    }


init : Model
init =
    { currentDiscard = 0
    }
