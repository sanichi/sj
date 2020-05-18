module Msg exposing (..)

import Json.Encode as E exposing (Value)
import Update exposing (Update)


type Msg
    = NewUpdate Update
    | RevealCard Int
    | ChooseDiscard
    | ChooseDiscardCard Int
    | ChoosePack
    | ChoosePackCard Int
    | ChoosePackDiscard
    | ChoosePackDiscardCard Int
    | NextHand Int
    | Noop


value : Msg -> Value
value msg =
    case msg of
        RevealCard cid ->
            E.object [ ( "card_index", E.int cid ) ]

        ChooseDiscard ->
            E.object [ ( "discard_chosen", E.int 1 ) ]

        ChooseDiscardCard cid ->
            E.object [ ( "discard_card_index", E.int cid ) ]

        ChoosePack ->
            E.object [ ( "pack_chosen", E.int 1 ) ]

        ChoosePackCard cid ->
            E.object [ ( "pack_card_index", E.int cid ) ]

        ChoosePackDiscard ->
            E.object [ ( "pack_discard_chosen", E.int 1 ) ]

        ChoosePackDiscardCard cid ->
            E.object [ ( "pack_discard_card_index", E.int cid ) ]

        NextHand score ->
            E.object [ ( "next_hand", E.int score ) ]

        _ ->
            E.null
