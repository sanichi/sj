module Update exposing (decode)

import Json.Decode as D exposing (Decoder, Value)
import Types exposing (Update)


decode : Value -> Update
decode value =
    D.decodeValue updateDecoder value |> Result.withDefault default


updateDecoder : Decoder Update
updateDecoder =
    D.map2 Update
        (D.maybe (D.field "disc" D.int))
        (D.maybe (D.field "hand" (D.list D.int)))


default : Update
default =
    Update Nothing Nothing



--
--
--
-- -- from elm-community/json-extra
--
--
-- withDefault : a -> Decoder a -> Decoder a
-- withDefault fallback decoder =
--     D.maybe decoder
--         |> D.map (Maybe.withDefault fallback)
