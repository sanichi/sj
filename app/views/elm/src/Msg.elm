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
                [ ( "pid", E.int pid )
                , ( "cid", E.int cid )
                ]

        _ ->
            E.null
