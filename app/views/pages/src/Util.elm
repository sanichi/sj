module Util exposing (..)

import Nums
import Svg exposing (Attribute)
import Svg.Attributes as Atr



-- Table


viewWidth : Attribute msg
viewWidth =
    String.fromInt Nums.viewWidth |> Atr.width


viewHeight : Attribute msg
viewHeight =
    String.fromInt Nums.viewHeight |> Atr.height


viewBox : Attribute msg
viewBox =
    [ 0, 0, Nums.viewWidth, Nums.viewHeight ]
        |> List.map String.fromInt
        |> String.join " "
        |> Atr.viewBox



-- Playing cards


cardWidth : Attribute msg
cardWidth =
    String.fromInt Nums.cardWidth |> Atr.width


cardHeight : Attribute msg
cardHeight =
    String.fromInt Nums.cardHeight |> Atr.height



-- Pack


packX : Attribute msg
packX =
    String.fromInt Nums.packX |> Atr.x


packY : Attribute msg
packY =
    String.fromInt Nums.packY |> Atr.y



-- Discard pile


discX : Attribute msg
discX =
    String.fromInt Nums.discX |> Atr.x


discY : Attribute msg
discY =
    String.fromInt Nums.discY |> Atr.y



-- Images


image : Int -> Attribute msg
image val =
    let
        name =
            if val >= 0 && val <= 12 then
                "p" ++ String.fromInt val

            else if val == -1 then
                "m1"

            else if val == -2 then
                "m2"

            else
                "back"
    in
    "/images/" ++ name ++ ".png" |> Atr.xlinkHref


back : Attribute msg
back =
    "/images/back.png" |> Atr.xlinkHref
