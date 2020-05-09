module Player exposing (Player, Players, get, init, put)

import Dict exposing (Dict)
import Hand exposing (Hand)


type alias Player =
    { id : Int
    , handle : String
    , hand : Hand
    }


type alias Players =
    Dict Int Player


init : List ( Int, String ) -> Players
init list =
    build list Dict.empty


build : List ( Int, String ) -> Players -> Players
build list dict =
    case list of
        [] ->
            dict

        ( id, handle ) :: rest ->
            build rest (Dict.insert id (start id handle) dict)


start : Int -> String -> Player
start id handle =
    Player id handle (List.repeat 12 ( 0, False ))


get : Players -> Int -> Maybe Player
get players id =
    Dict.get id players


put : Players -> Int -> Player -> Players
put players id player =
    Dict.insert id player players
