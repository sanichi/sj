module Model exposing (init, update)

import Json.Decode exposing (Value)
import Setup
import Types exposing (Card, Model, Setup, Update)


init : Value -> Model
init flags =
    let
        setup =
            Setup.decode flags

        player =
            case setup.player of
                Nothing ->
                    0

                Just id ->
                    id
    in
    { player = player
    , pack = ( 0, False )
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
