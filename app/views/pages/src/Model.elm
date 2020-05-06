module Model exposing (init, update)

import Types exposing (Card, Model, Update)


init : Model
init =
    { pack = ( 0, False )
    , disc = ( 0, True )
    , hand = List.repeat 12 ( 0, False )
    }


update : Model -> Update -> Model
update m u =
    let
        pack =
            case u.pack of
                Just num ->
                    ( num, False )

                Nothing ->
                    m.pack

        disc =
            case u.disc of
                Just num ->
                    ( num, True )

                Nothing ->
                    m.disc

        hand =
            case u.hand of
                Just nums ->
                    List.map (\n -> ( n, False )) nums

                Nothing ->
                    m.hand
    in
    { m | pack = pack, disc = disc, hand = hand }
