port module Ports exposing (..)

import Json.Decode exposing (Value)


port pullUpdate : (Value -> msg) -> Sub msg


port pushUpdates : Value -> Cmd msg
