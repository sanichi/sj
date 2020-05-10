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


init : List ProtoPlayer -> Players
init list =
    build list Dict.empty


build : List ProtoPlayer -> Players -> Players
build list dict =
    case list of
        [] ->
            dict

        p :: rest ->
            convert p.id p.handle p.position
                |> put dict p.id
                |> build rest


convert : Int -> String -> String -> Player
convert id handle position =
    Player id handle (decode position) Hand.init


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


get : Players -> Int -> Maybe Player
get players id =
    Dict.get id players


put : Players -> Int -> Player -> Players
put players id player =
    Dict.insert id player players


all : Players -> List Player
all players =
    Dict.values players
