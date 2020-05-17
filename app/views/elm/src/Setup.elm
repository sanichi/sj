module Setup exposing
    ( ProtoPlayer
    , decode
    )

import Json.Decode as D exposing (Decoder, Value)


type alias ProtoPlayer =
    { pid : Int
    , handle : String
    , position : String
    }


decode : Value -> Setup
decode value =
    D.decodeValue flags value |> Result.withDefault default



-- Private


type alias Setup =
    { player_id : Int
    , players : List ProtoPlayer
    , debug : Bool
    }


flags : Decoder Setup
flags =
    D.map3 Setup
        (D.field "player_id" D.int |> withDefault default.player_id)
        (D.field "players" (D.list pair) |> withDefault default.players)
        (D.field "debug" D.bool |> withDefault default.debug)


pair : Decoder ProtoPlayer
pair =
    D.map3 ProtoPlayer
        (D.field "id" D.int |> withDefault 0)
        (D.field "handle" D.string |> withDefault "Nobody")
        (D.field "position" D.string |> withDefault "S")


default : Setup
default =
    Setup 0 [] False



-- from elm-community/json-extra


withDefault : a -> Decoder a -> Decoder a
withDefault fallback decoder =
    D.maybe decoder
        |> D.map (Maybe.withDefault fallback)
