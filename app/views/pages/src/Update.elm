module Update exposing (Update, decode)

import Json.Decode as D exposing (Decoder, Value)


type alias Update =
    { disc : Maybe Int
    }


decode : Value -> Update
decode value =
    D.decodeValue updateDecoder value |> Result.withDefault default


updateDecoder : Decoder Update
updateDecoder =
    D.map Update
        (D.maybe (D.field "disc" D.int))


default : Update
default =
    Update Nothing



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
