module Update exposing (decode)

import Json.Decode as D exposing (Decoder, Value)
import Types exposing (Update)


decode : Value -> Update
decode value =
    D.decodeValue updateDecoder value |> Result.withDefault default


updateDecoder : Decoder Update
updateDecoder =
    D.map3 Update
        (D.maybe (D.field "pack" D.int))
        (D.maybe (D.field "disc" D.int))
        (D.maybe (D.field "hand" (D.list D.int)))


default : Update
default =
    Update Nothing Nothing Nothing
