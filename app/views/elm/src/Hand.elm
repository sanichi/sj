module Hand exposing
    ( Hand
    , check
    , exposed
    , get
    , highest
    , init
    , map
    , out
    , score
    , set
    )

import Array exposing (Array)
import Card exposing (Card)


type alias Hand =
    Array Card


check : Hand -> ( Hand, Maybe Int )
check hand =
    case matched 1 hand of
        Just discard ->
            ( poof 1 hand, Just discard )

        _ ->
            case matched 2 hand of
                Just discard ->
                    ( poof 2 hand, Just discard )

                _ ->
                    case matched 3 hand of
                        Just discard ->
                            ( poof 3 hand, Just discard )

                        _ ->
                            case matched 4 hand of
                                Just discard ->
                                    ( poof 4 hand, Just discard )

                                _ ->
                                    ( hand, Nothing )


exposed : Hand -> Int
exposed hand =
    Array.length <| Array.filter .exposed hand


init : List Int -> Hand
init nums =
    Array.fromList <| List.map Card.hidden nums


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


map : (Int -> Card -> a) -> Hand -> List a
map f hand =
    Array.indexedMap f hand |> Array.toList


out : Hand -> Bool
out hand =
    hand
        |> Array.toList
        |> List.filter (\c -> c.exists && not c.exposed)
        |> List.isEmpty


score : Hand -> Int
score hand =
    Array.foldr (+) 0 <| Array.map Card.score hand


set : Int -> Card -> Hand -> Hand
set cid card hand =
    Array.set cid card hand



-- Private


columnIndexes : Int -> List Int
columnIndexes col =
    List.map (\d -> d + col) [ -1, 3, 7 ]


matched : Int -> Hand -> Maybe Int
matched col hand =
    let
        cards =
            columnIndexes col
                |> List.map get
                |> List.map (\f -> f hand)
    in
    case cards of
        [ Just c1, Just c2, Just c3 ] ->
            let
                allExist =
                    [ c1, c2, c3 ]
                        |> List.map .exists
                        |> List.foldl (&&) True

                allExposed =
                    [ c1, c2, c3 ]
                        |> List.map .exposed
                        |> List.foldl (&&) True
            in
            if allExist && allExposed && c1.num == c2.num && c1.num == c3.num then
                Just c1.num

            else
                Nothing

        _ ->
            Nothing


poof : Int -> Hand -> Hand
poof col hand =
    remove (columnIndexes col) hand


remove : List Int -> Hand -> Hand
remove cids hand =
    case cids of
        cid :: rest ->
            set cid Card.blank hand
                |> remove rest

        [] ->
            hand
