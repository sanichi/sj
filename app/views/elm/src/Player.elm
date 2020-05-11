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


get : Players -> Int -> Maybe Player
get players id =
    Dict.get id players


init : List ProtoPlayer -> Players
init list =
    build list Dict.empty


put : Players -> Int -> Player -> Players
put players id player =
    Dict.insert id player players



-- Private


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
