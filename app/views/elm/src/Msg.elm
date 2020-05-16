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
    | Noop


value : Msg -> Value
value msg =
    case msg of
        RevealCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "card_index", E.int cid )
                ]

        ChooseDiscard pid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "elm_state", E.int 2 )
                ]

        ChooseDiscardCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "discard_card_index", E.int cid )
                ]

        ChoosePack pid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "pack_chosen", E.int 1 )
                ]

        ChoosePackCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "pack_card_index", E.int cid )
                ]

        ChoosePackDiscard pid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "elm_state", E.int 3 )
                ]

        ChoosePackDiscardCard pid cid ->
            E.object
                [ ( "player_id", E.int pid )
                , ( "pack_discard_card_index", E.int cid )
                ]

        _ ->
            E.null
