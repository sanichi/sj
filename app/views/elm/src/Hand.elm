module Hand exposing
    ( Hand
    , checkPoof
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


checkPoof : Int -> Hand -> ( Hand, Maybe Int )
checkPoof cid hand =
    let
        cids =
            matched cid hand
    in
    case cids of
        [] ->
            ( hand, Nothing )

        _ ->
            let
                uHand =
                    poof cids hand

                discard =
                    case get cid hand of
                        Just card ->
                            Just card.num

                        _ ->
                            Nothing
            in
            ( uHand, discard )


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
columnIndexes cid =
    let
        first =
            remainderBy 4 cid
    in
    [ first, first + 4, first + 8 ]


matched : Int -> Hand -> List Int
matched cid hand =
    let
        cids =
            columnIndexes cid

        cards =
            List.map (\f -> f hand) <| List.map get cids
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
                cids

            else
                []

        _ ->
            []


poof : List Int -> Hand -> Hand
poof cids hand =
    case cids of
        cid :: rest ->
            set cid Card.blank hand
                |> poof rest

        [] ->
            hand
