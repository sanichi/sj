module Players exposing
    ( Players
    , all
    , get
    , init
    , put
    , updateReveal
    )

import Dict exposing (Dict)
import Hand exposing (Hand)
import Player exposing (Player, Position(..))
import Setup exposing (ProtoPlayer)


type alias Players =
    Dict Int Player


all : Players -> List Player
all players =
    Dict.values players


get : Int -> Players -> Maybe Player
get pid players =
    Dict.get pid players


init : List ProtoPlayer -> Players
init list =
    build list Dict.empty


put : Int -> Player -> Players -> Players
put pid player players =
    Dict.insert pid player players


updateReveal : Players -> Players
updateReveal players =
    players



-- Private


build : List ProtoPlayer -> Players -> Players
build list players =
    case list of
        [] ->
            players

        proto :: rest ->
            let
                nPlayer =
                    convert proto

                uPlayers =
                    put proto.pid nPlayer players
            in
            build rest uPlayers


convert : ProtoPlayer -> Player
convert proto =
    let
        position =
            decode proto.position

        hand =
            Hand.init <| List.repeat 12 0
    in
    Player proto.pid proto.handle position hand True 0


decode : String -> Position
decode position =
    case position of
        "S" ->
            S

        "N" ->
            N

        "E" ->
            E

        "W" ->
            W

        "NE" ->
            NE

        "NW" ->
            NW

        _ ->
            S
