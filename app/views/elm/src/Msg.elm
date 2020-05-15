module Msg exposing (..)

import Json.Encode as E exposing (Value)
import Update exposing (Update)


type Msg
    = NewUpdate Update
    | RevealCard Int Int
    | ChoosePack
    | ChooseDiscard
    | ChoosePackCard Int Int
    | Noop


value : Msg -> Value
value msg =
    case msg of
        RevealCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "card_index", E.int cid )
                ]

        ChoosePack ->
            E.object
                [ ( "elm_state", E.int 1 )
                ]

        ChoosePackCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "pack_card_index", E.int cid )
                ]

        ChooseDiscard ->
            E.object
                [ ( "elm_state", E.int 2 )
                ]

        _ ->
            E.null
