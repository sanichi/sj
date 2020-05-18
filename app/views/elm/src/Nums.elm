module Nums exposing (..)

import Player exposing (Position(..))



-- Overall view


viewWidth : Int
viewWidth =
    1000


viewHeight : Int
viewHeight =
    1000


viewMargin : Int
viewMargin =
    30



-- Playing cards


cardWidth : Int
cardWidth =
    let
        fraction =
            toFloat cardImageWidth / toFloat cardImageHeight
    in
    cardHeight
        |> toFloat
        |> (*) fraction
        |> ceiling


cardHeight : Int
cardHeight =
    100



-- Pack


packX : Int
packX =
    viewWidth // 2 - cardWidth - (cardMargin // 2)


packY : Int
packY =
    viewHeight // 2 - (cardHeight // 2)



-- Discard pile


discardX : Int
discardX =
    viewWidth // 2 + (cardMargin // 2)


discardY : Int
discardY =
    viewHeight // 2 - (cardHeight // 2)



-- Name badges


badgeWidth : Int
badgeWidth =
    handWidth


badgeHeight : Int
badgeHeight =
    50


badgeTextSize : Int
badgeTextSize =
    -- match this with what's in card_table.sass
    25


badgeTextX : Int
badgeTextX =
    badgeWidth // 2


badgeTextY : Int
badgeTextY =
    badgeHeight // 2 + badgeTextSize // 4



-- Relative positions


handOffset : Position -> ( Int, Int )
handOffset position =
    let
        x =
            case position of
                W ->
                    viewMargin

                E ->
                    viewWidth - handWidth - viewMargin

                NW ->
                    viewMargin

                NE ->
                    viewWidth - handWidth - viewMargin

                _ ->
                    (viewWidth - handWidth) // 2

        y =
            case position of
                E ->
                    (viewHeight - handHeight) // 2

                W ->
                    (viewHeight - handHeight) // 2

                S ->
                    viewHeight - handHeight - viewMargin

                _ ->
                    viewMargin
    in
    ( x, y )


cardsYOffset : Position -> Int
cardsYOffset position =
    case position of
        S ->
            0

        _ ->
            badgeHeight + badgeMargin


cardX : Int -> Int
cardX cid =
    remainderBy 4 cid * (cardWidth + cardMargin)


cardY : Int -> Int
cardY cid =
    (cid // 4) * (cardHeight + cardMargin)


badgeOffset : Position -> ( Int, Int )
badgeOffset position =
    let
        x =
            (handWidth - badgeWidth) // 2

        y =
            case position of
                S ->
                    handHeight - badgeHeight

                _ ->
                    0
    in
    ( x, y )



-- Private


badgeMargin : Int
badgeMargin =
    20


cardImageWidth : Int
cardImageWidth =
    654


cardImageHeight : Int
cardImageHeight =
    1000


cardMargin : Int
cardMargin =
    4


handHeight : Int
handHeight =
    cardHeight * 3 + cardMargin * 2 + badgeMargin + badgeHeight


handWidth : Int
handWidth =
    cardWidth * 4 + cardMargin * 3



-- Score


scoreButtonHeight : Int
scoreButtonHeight =
    scorePlayerHeight


scoreButtonWidth : Int
scoreButtonWidth =
    200


scoreButtonTextX : Int
scoreButtonTextX =
    scoreButtonWidth // 2


scoreButtonTextY : Int
scoreButtonTextY =
    scorePlayerHeight // 2 + scoreTextSize // 4


scoreButtonX : Int
scoreButtonX =
    (scoreWidth - scoreButtonWidth) // 2


scoreButtonY : Int
scoreButtonY =
    scorePlayerY -1


scoreHeight : Int -> Int
scoreHeight num =
    scorePlayerHeight * (num + 1) + scoreInsideMargin * (num + 2)


scoreWidth : Int
scoreWidth =
    viewWidth - 2 * scoreOutsideMargin


scoreInsideMargin : Int
scoreInsideMargin =
    50


scoreOutsideMargin : Int
scoreOutsideMargin =
    100


scorePlayerWidth : Int
scorePlayerWidth =
    scoreWidth - 2 * scoreInsideMargin


scorePlayerHeight : Int
scorePlayerHeight =
    60


scorePlayerX : Int
scorePlayerX =
    scoreInsideMargin


scorePlayerY : Int -> Int
scorePlayerY position =
    scorePlayerHeight * (position + 1) + scoreInsideMargin * (position + 2)


scorePlayerTextX : Int
scorePlayerTextX =
    scorePlayerWidth // 2


scorePlayerTextY : Int
scorePlayerTextY =
    scorePlayerHeight // 2 + scoreTextSize // 4


scoreTextSize : Int
scoreTextSize =
    -- match this with what's in card_table.sass
    30


scoreX : Int
scoreX =
    scoreOutsideMargin


scoreY : Int -> Int
scoreY num =
    (viewHeight - scoreHeight num) // 2



-- Debug


debugTextX : Int
debugTextX =
    viewWidth // 2


debugTextY : Int
debugTextY =
    20
