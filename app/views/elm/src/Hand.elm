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
import Set


type alias Hand =
    Array Card


checkPoof : Int -> Bool -> Hand -> ( Hand, Maybe Int )
checkPoof cid four hand =
    let
        colCids =
            matchedCol cid hand

        rowCids =
            if four then
                matchedRow cid hand

            else
                []

        cids =
            colCids
                ++ rowCids
                |> Set.fromList
                |> Set.toList
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


colIndexes : Int -> List Int
colIndexes cid =
    let
        first =
            remainderBy 4 cid
    in
    [ first, first + 4, first + 8 ]


rowIndexes : Int -> List Int
rowIndexes cid =
    let
        first =
            4 * (cid // 4)
    in
    [ first, first + 1, first + 2, first + 3 ]


matchedCol : Int -> Hand -> List Int
matchedCol cid hand =
    let
        cids =
            colIndexes cid

        ( number, unique ) =
            matchStats cids hand
    in
    if number == 3 && unique == 1 then
        cids

    else
        []


matchedRow : Int -> Hand -> List Int
matchedRow cid hand =
    let
        cids =
            rowIndexes cid

        ( number, unique ) =
            matchStats cids hand
    in
    if number == 4 && unique == 1 then
        cids

    else
        []


matchStats : List Int -> Hand -> ( Int, Int )
matchStats cids hand =
    let
        cards =
            cids
                |> List.map get
                |> List.map (\f -> f hand)
                |> List.filterMap identity

        number =
            cards
                |> List.filter .exists
                |> List.filter .exposed
                |> List.length

        unique =
            cards
                |> List.map .num
                |> Set.fromList
                |> Set.size
    in
    ( number, unique )


poof : List Int -> Hand -> Hand
poof cids hand =
    case cids of
        cid :: rest ->
            set cid Card.blank hand
                |> poof rest

        [] ->
            hand
