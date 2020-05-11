module Hand exposing (Hand, get, init, map, score, set)

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
get cid hand =
    Array.get cid hand


score : Hand -> Int
score hand =
    Array.foldr (+) 0 <| Array.map Card.score hand


set : Int -> Card -> Hand -> Hand
set cid card hand =
    Array.set cid card hand
