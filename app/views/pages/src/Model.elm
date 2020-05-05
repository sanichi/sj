module Model exposing (init, update)

import Types exposing (Card, Model, Update)


init : Model
init =
    { disc = 0
    , cards = List.repeat 12 default
    }


default : Card
default =
    ( 0, False )


update : Model -> Update -> Model
update m u =
    let
        disc =
            case u.disc of
                Just val ->
                    val

                Nothing ->
                    m.disc
    in
    { m | disc = disc }
