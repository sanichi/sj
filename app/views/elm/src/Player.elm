module Player exposing (Player, Players, Position(..), all, badge, get, init, put)

import Dict exposing (Dict)
import Hand exposing (Hand)
import Setup exposing (ProtoPlayer)


type alias Player =
    { id : Int
    , handle : String
    , position : Position
    , hand : Hand
    , score : Int
    }


type alias Players =
    Dict Int Player


type Position
    = S
    | N
    | NW
    | NE
    | E
    | W


all : Players -> List Player
all players =
    Dict.values players


badge : Player -> String
badge player =
    let
        handle =
            player.handle

        total =
            String.fromInt player.score

        current =
            String.fromInt (Hand.score player.hand)
    in
    player.handle ++ " " ++ total ++ "/" ++ current


get : Int -> Players -> Maybe Player
get id players =
    Dict.get id players


init : List ProtoPlayer -> Players
init list =
    build list Dict.empty


put : Int -> Player -> Players -> Players
put id player players =
    Dict.insert id player players



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
                    put proto.id nPlayer players
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
    Player proto.id proto.handle position hand 0


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
