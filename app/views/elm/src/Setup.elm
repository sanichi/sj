module Setup exposing
    ( Options
    , ProtoPlayer
    , decode
    )

import Json.Decode as D exposing (Decoder, Value)


type alias ProtoPlayer =
    { pid : Int
    , handle : String
    , position : String
    }


type alias Options =
    { debug : Bool
    , peek : Bool
    , four : Bool
    }


decode : Value -> Setup
decode value =
    D.decodeValue flags value |> Result.withDefault default



-- Private


type alias Setup =
    { player_id : Int
    , players : List ProtoPlayer
    , upto : Int
    , options : Options
    }


flags : Decoder Setup
flags =
    D.map4 Setup
        (D.field "player_id" D.int |> withDefault default.player_id)
        (D.field "players" (D.list proto) |> withDefault default.players)
        (D.field "upto" D.int |> withDefault default.upto)
        (D.field "options" options |> withDefault default.options)


proto : Decoder ProtoPlayer
proto =
    D.map3 ProtoPlayer
        (D.field "id" D.int |> withDefault 0)
        (D.field "handle" D.string |> withDefault "Nobody")
        (D.field "position" D.string |> withDefault "S")


options : Decoder Options
options =
    D.map3 Options
        (D.field "debug" D.bool |> withDefault default.options.debug)
        (D.field "peek" D.bool |> withDefault default.options.peek)
        (D.field "four" D.bool |> withDefault default.options.four)


default : Setup
default =
    Setup 0 [] 100 (Options False False False)



-- from elm-community/json-extra


withDefault : a -> Decoder a -> Decoder a
withDefault fallback decoder =
    D.maybe decoder
        |> D.map (Maybe.withDefault fallback)
