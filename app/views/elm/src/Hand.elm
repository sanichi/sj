module Hand exposing
    ( Hand
    , exposed
    , get
    , highest
    , init
    , map
    , score
    , set
    )

import Array exposing (Array)
import Card exposing (Card)


type alias Hand =
    Array Card


exposed : Hand -> Int
exposed hand =
    Array.length <| Array.filter .vis hand


init : List Int -> Hand
init nums =
    Array.fromList <| List.map Card.hidden nums


map : (Int -> Card -> a) -> Hand -> List a
map f hand =
    Array.indexedMap f hand |> Array.toList


get : Int -> Hand -> Maybe Card
get cid hand =
    Array.get cid hand


highest : Hand -> Int
highest hand =
    case List.maximum <| Array.toList <| Array.map Card.score hand of
        Just max ->
            max

        Nothing ->
            0


score : Hand -> Int
score hand =
    Array.foldr (+) 0 <| Array.map Card.score hand


set : Int -> Card -> Hand -> Hand
set cid card hand =
    Array.set cid card hand
