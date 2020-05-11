module Msg exposing (..)

import Update exposing (Update)


type Msg
    = NewUpdate Update
    | Reveal Int Int
    | Noop
