module Hand exposing (Hand, get, init, map, set)

import Array exposing (Array)
import Card exposing (Card)


type alias Hand =
    Array Card


init : List Int -> Hand
init nums =
    Array.fromList <| List.map Card.hidden nums


map : (Int -> Card -> a) -> Hand -> List a
map f hand =
    Array.indexedMap f hand |> Array.toList


get : Int -> Hand -> Maybe Card
get index hand =
    Array.get index hand


set : Int -> Card -> Hand -> Hand
set index card hand =
    Array.set index card hand
