module Util exposing (bg, box, disc, hands, pack)

import Nums
import Svg exposing (Attribute, Svg)
import Svg.Attributes as Atr
import Types exposing (Card)



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



-- Pack


pack : Card -> Svg msg
pack card =
    let
        x =
            String.fromInt Nums.packX |> Atr.x

        y =
            String.fromInt Nums.packY |> Atr.y

        u =
            cardUrl card
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Discard pile


disc : Card -> Svg msg
disc card =
    let
        x =
            String.fromInt Nums.discX |> Atr.x

        y =
            String.fromInt Nums.discY |> Atr.y

        u =
            cardUrl card
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Players cards


hands : List Card -> List (Svg msg)
hands cards =
    let
        own =
            hand cards
    in
    [ own ]



-- Private


hand : List Card -> Svg msg
hand cards =
    let
        elements =
            hand_ [] cards

        translate =
            handOffset
    in
    Svg.g [ translate ] elements


hand_ : List (Svg msg) -> List Card -> List (Svg msg)
hand_ elements cards =
    case cards of
        [] ->
            elements

        card :: rest ->
            let
                element =
                    cardElement card (List.length elements)
            in
            hand_ (element :: elements) rest


handOffset : Attribute msg
handOffset =
    let
        ( i, j ) =
            Nums.handOffset

        x =
            String.fromInt i

        y =
            String.fromInt j
    in
    Atr.transform <| "translate(" ++ x ++ " " ++ y ++ ")"


cardUrl : Card -> Attribute msg
cardUrl card =
    let
        nam =
            if not (Tuple.second card) then
                "back"

            else
                let
                    num =
                        Tuple.first card
                in
                if num >= 0 && num <= 12 then
                    "p" ++ String.fromInt num

                else if num == -1 then
                    "m1"

                else if num == -2 then
                    "m2"

                else
                    "back"

        url =
            "/images/" ++ nam ++ ".png"
    in
    Atr.xlinkHref url


cardWidth : Attribute msg
cardWidth =
    String.fromInt Nums.cardWidth |> Atr.width


cardHeight : Attribute msg
cardHeight =
    String.fromInt Nums.cardHeight |> Atr.height


cardElement : Card -> Int -> Svg msg
cardElement card i =
    let
        col =
            remainderBy 4 i

        row =
            i // 4

        x =
            col
                * (Nums.cardWidth + Nums.cardMargin)
                |> String.fromInt
                |> Atr.x

        y =
            row
                * (Nums.cardHeight + Nums.cardMargin)
                |> String.fromInt
                |> Atr.y

        u =
            cardUrl card
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []
