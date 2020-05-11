module Player exposing (Player, Players, Position(..), all, get, init, put)

import Dict exposing (Dict)
import Hand exposing (Hand)
import Setup exposing (ProtoPlayer)


type alias Player =
    { id : Int
    , handle : String
    , position : Position
    , hand : Hand
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
build list dict =
    case list of
        [] ->
            dict

        p :: rest ->
            build rest <| put p.id (convert p.id p.handle p.position) dict


convert : Int -> String -> String -> Player
convert id handle pos =
    let
        position =
            decode pos

        hand =
            Hand.init <| List.repeat 12 0
    in
    Player id handle position hand


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
