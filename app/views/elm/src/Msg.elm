module Msg exposing (..)

import Json.Encode as E exposing (Value)
import Update exposing (Update)


type Msg
    = NewUpdate Update
    | Reveal Int Int
    | Noop


value : Msg -> Value
value msg =
    case msg of
        Reveal pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "card_index", E.int cid )
                ]

        _ ->
            E.null
