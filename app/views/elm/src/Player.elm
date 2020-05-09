module Player exposing (Player, Players, init)

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
