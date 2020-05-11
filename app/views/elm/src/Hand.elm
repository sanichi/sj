module Hand exposing (Hand, init, map)

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
