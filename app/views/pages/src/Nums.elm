module Nums exposing (..)

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


discX : Int
discX =
    viewWidth // 2 + (cardMargin // 2)


discY : Int
discY =
    viewHeight // 2 - (cardHeight // 2)
