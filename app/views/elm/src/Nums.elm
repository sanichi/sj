module Nums exposing (..)

import Player exposing (Position(..))



-- Table


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


cardImageHeight : Int
cardImageHeight =
    1000


cardImageWidth : Int
cardImageWidth =
    654


cardMargin : Int
cardMargin =
    4



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
    40


badgeMargin : Int
badgeMargin =
    20



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



-- Useful quuantities


handHeight : Int
handHeight =
    cardHeight * 3 + cardMargin * 2 + badgeMargin + badgeHeight


handWidth : Int
handWidth =
    cardWidth * 4 + cardMargin * 3
