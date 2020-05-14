module Msg exposing (..)

import Json.Encode as E exposing (Value)
import Update exposing (Update)


type Msg
    = NewUpdate Update
    | RevealCard Int Int
    | PackVis Bool
    | Noop


value : Msg -> Value
value msg =
    case msg of
        RevealCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "card_index", E.int cid )
                ]

        PackVis vis ->
            E.object
                [ ( "pack_vis", E.bool vis )
                ]

        _ ->
            E.null
