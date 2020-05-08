module Setup exposing (decode)

import Json.Decode as D exposing (Decoder, Value)
import Types exposing (Setup)


decode : Value -> Setup
decode value =
    D.decodeValue flagsDecoder value |> Result.withDefault default


flagsDecoder : Decoder Setup
flagsDecoder =
    D.map Setup
        (D.maybe (D.field "player" D.int))


default : Setup
default =
    Setup Nothing
