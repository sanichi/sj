port module Ports exposing (..)

import Json.Decode exposing (Value)


port updates : (Value -> msg) -> Sub msg
