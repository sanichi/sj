module Update exposing (Update, decode)

import Json.Decode as D exposing (Decoder, Value)


type alias Update =
    { pack : Maybe Int
    , discard : Maybe Int
    , hand : Maybe (List Int)
    , player_id : Maybe Int
    }


decode : Value -> Update
decode value =
    D.decodeValue updateDecoder value |> Result.withDefault default


updateDecoder : Decoder Update
updateDecoder =
    D.map4 Update
        (D.maybe (D.field "pack" D.int))
        (D.maybe (D.field "discard" D.int))
        (D.maybe (D.field "hand" (D.list D.int)))
        (D.maybe (D.field "player_id" D.int))


default : Update
default =
    Update Nothing Nothing Nothing Nothing
