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
    40



-- Playing cards


cardImageWidth : Int
cardImageWidth =
    654


cardImageHeight : Int
cardImageHeight =
    1000


cardMargin : Int
cardMargin =
    4


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


cardX : Int -> Int
cardX cid =
    remainderBy 4 cid * (cardWidth + cardMargin)


cardY : Int -> Int
cardY cid =
    (cid // 4) * (cardHeight + cardMargin)


cardsYOffset : Position -> Int
cardsYOffset position =
    case position of
        S ->
            0

        _ ->
            badgeHeight + badgeMargin


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


handHeight : Int
handHeight =
    cardHeight * 3 + cardMargin * 2 + badgeMargin + badgeHeight


handWidth : Int
handWidth =
    cardWidth * 4 + cardMargin * 3



-- Pack and discard pile


extraSeparation : Int
extraSeparation =
    10


discardX : Int
discardX =
    viewWidth // 2 + (cardMargin // 2) + extraSeparation


discardY : Int
discardY =
    viewHeight // 2 - (cardHeight // 2)


packX : Int
packX =
    viewWidth // 2 - cardWidth - (cardMargin // 2) - extraSeparation


packY : Int
packY =
    viewHeight // 2 - (cardHeight // 2)



-- Name badges


badgeMargin : Int
badgeMargin =
    20


badgeWidth : Int
badgeWidth =
    handWidth + 44


badgeHeight : Int
badgeHeight =
    50


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


badgeTextSize : Int
badgeTextSize =
    -- match this with what's in card_table.sass
    24


badgeTextX : Int
badgeTextX =
    badgeWidth // 2


badgeTextY : Int
badgeTextY =
    badgeHeight // 2 + badgeTextSize // 3



-- Button


buttonHeight : Int
buttonHeight =
    60


buttonWidth : Int
buttonWidth =
    260


buttonTextX : Int
buttonTextX =
    buttonWidth // 2


buttonTextY : Int
buttonTextY =
    buttonHeight // 2 + scoreTextSize // 4


scoreTextSize : Int
scoreTextSize =
    -- match this with what's in card_table.sass
    30


buttonX : Int
buttonX =
    viewWidth // 2 - buttonWidth // 2


buttonY : Int
buttonY =
    viewHeight // 2 - buttonHeight // 2



-- Debug


debugTextX : Int
debugTextX =
    viewWidth // 2


debugTextY : Int
debugTextY =
    20
