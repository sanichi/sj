module Model exposing (init, update)

import Types exposing (Card, Model, Update)


init : Model
init =
    { disc = 0
    , hand = List.repeat 12 (default 0)
    }


default : Int -> Card
default card =
    ( card, False )


update : Model -> Update -> Model
update m u =
    let
        disc =
            case u.disc of
                Just card ->
                    card

                Nothing ->
                    m.disc

        hand =
            case u.hand of
                Just cards ->
                    List.map default cards

                Nothing ->
                    m.hand
    in
    { m | disc = disc, hand = hand }
