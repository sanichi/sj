module Msg exposing (..)

import Json.Encode as E exposing (Value)
import Update exposing (Update)


type Msg
    = NewUpdate Update
    | RevealCard Int Int
    | ChoosePack Int
    | ChoosePackCard Int Int
    | ChoosePackDiscard Int
    | ChoosePackDiscardCard Int Int
    | ChooseDiscard Int
    | ChooseDiscardCard Int Int
    | NextHand Int
    | Noop


value : Msg -> Value
value msg =
    case msg of
        RevealCard pid cid ->
            E.object [ ( "card_index", E.int cid ) ]

        ChooseDiscard pid ->
            E.object [ ( "discard_chosen", E.int 1 ) ]

        ChooseDiscardCard pid cid ->
            E.object [ ( "discard_card_index", E.int cid ) ]

        ChoosePack pid ->
            E.object [ ( "pack_chosen", E.int 1 ) ]

        ChoosePackCard pid cid ->
            E.object [ ( "pack_card_index", E.int cid ) ]

        ChoosePackDiscard pid ->
            E.object [ ( "pack_discard_chosen", E.int 1 ) ]

        ChoosePackDiscardCard pid cid ->
            E.object [ ( "pack_discard_card_index", E.int cid ) ]

        NextHand score ->
            E.object [ ( "next_hand", E.int score ) ]

        _ ->
            E.null
