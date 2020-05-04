module Model exposing (..)

import Update exposing (Update)


type alias Model =
    { disc : Int
    , game : Int
    }


init : Model
init =
    { disc = 0
    , game = 0
    }


update : Model -> Update -> Model
update m u =
    if m.game /= init.game && m.game /= u.game then
        m

    else
        { m | disc = u.disc, game = u.game }
