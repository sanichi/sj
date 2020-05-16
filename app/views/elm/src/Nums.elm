module Nums exposing
    ( badgeHeight
    , badgeOffset
    , badgeTextSize
    , badgeWidth
    , cardHeight
    , cardWidth
    , cardX
    , cardY
    , cardsYOffset
    , discardX
    , discardY
    , handOffset
    , packX
    , packY
    , viewHeight
    , viewWidth
    )

import Player exposing (Position(..))



-- Table


viewWidth : Int
viewWidth =
    1000


viewHeight : Int
viewHeight =
    1000



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



-- Relative positions


handOffset : Position -> ( Int, Int )
handOffset position =
    let
        x =
            case position of
                E ->
                    viewMargin

                W ->
                    viewWidth - handWidth - viewMargin

                NE ->
                    viewMargin

                NW ->
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


viewMargin : Int
viewMargin =
    30
