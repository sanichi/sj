module Update exposing (Update, decode)

import Json.Decode as D exposing (Decoder, Value)


type alias Update =
    ( String, List Int )


decode : Value -> Update
decode value =
    D.decodeValue updateDecoder value |> Result.withDefault default


updateDecoder : Decoder Update
updateDecoder =
    D.map2 Tuple.pair
        (D.field "key" D.string)
        (D.field "val" (D.list D.int))


default : Update
default =
    ( "error", [] )
