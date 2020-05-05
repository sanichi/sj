module Util exposing (bg, box, disc, pack)

import Nums
import Svg exposing (Attribute, Svg)
import Svg.Attributes as Atr



-- Visible box


box : Attribute msg
box =
    [ 0, 0, Nums.viewWidth, Nums.viewHeight ]
        |> List.map String.fromInt
        |> String.join " "
        |> Atr.viewBox



-- Background


bg : Svg msg
bg =
    let
        w =
            String.fromInt Nums.viewWidth |> Atr.width

        h =
            String.fromInt Nums.viewHeight |> Atr.height
    in
    Svg.rect [ Atr.class "background", w, h ] []



-- All playing cards


cardWidth : Attribute msg
cardWidth =
    String.fromInt Nums.cardWidth |> Atr.width


cardHeight : Attribute msg
cardHeight =
    String.fromInt Nums.cardHeight |> Atr.height



-- Pack


pack : Svg msg
pack =
    let
        x =
            String.fromInt Nums.packX |> Atr.x

        y =
            String.fromInt Nums.packY |> Atr.y
    in
    Svg.image [ x, y, cardWidth, cardHeight, back ] []



-- Discard pile


disc : Int -> Svg msg
disc card =
    let
        x =
            String.fromInt Nums.discX |> Atr.x

        y =
            String.fromInt Nums.discY |> Atr.y

        u =
            url card
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Urls


url : Int -> Attribute msg
url card =
    let
        name =
            if card >= 0 && card <= 12 then
                "p" ++ String.fromInt card

            else if card == -1 then
                "m1"

            else if card == -2 then
                "m2"

            else
                "back"
    in
    "/images/" ++ name ++ ".png" |> Atr.xlinkHref


back : Attribute msg
back =
    "/images/back.png" |> Atr.xlinkHref
