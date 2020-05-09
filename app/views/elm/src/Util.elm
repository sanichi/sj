module Util exposing (bg, box, disc, hands, pack)

import Card exposing (Card)
import Hand exposing (Hand)
import Model exposing (Model)
import Nums
import Player exposing (Player)
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



-- Pack


pack : Model -> Svg msg
pack model =
    let
        x =
            String.fromInt Nums.packX |> Atr.x

        y =
            String.fromInt Nums.packY |> Atr.y

        u =
            cardUrl model.pack
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Discard pile


disc : Model -> Svg msg
disc model =
    let
        x =
            String.fromInt Nums.discX |> Atr.x

        y =
            String.fromInt Nums.discY |> Atr.y

        u =
            cardUrl model.disc
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Players cards


hands : Model -> List (Svg msg)
hands model =
    let
        player =
            Player.get model.players model.player_id
    in
    case player of
        Just p ->
            [ hand p ]

        Nothing ->
            []



-- Private


hand : Player -> Svg msg
hand player =
    let
        elements =
            hand_ [] player.hand

        name =
            badge player.handle

        translate =
            handOffset
    in
    Svg.g [ translate ] (name :: elements)


hand_ : List (Svg msg) -> Hand -> List (Svg msg)
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


badge : String -> Svg msg
badge handle =
    Svg.g [ Atr.class "badge", badgeOffset ]
        [ badgeRect
        , badgeText handle
        ]


badgeRect : Svg msg
badgeRect =
    let
        x =
            Atr.x "0"

        y =
            Atr.y "0"

        w =
            Atr.width <| String.fromInt Nums.badgeWidth

        h =
            Atr.height <| String.fromInt Nums.badgeHeight

        rx =
            Atr.rx "10"

        ry =
            Atr.ry "10"
    in
    Svg.rect [ x, y, w, h, rx, ry ] []


badgeText : String -> Svg msg
badgeText handle =
    let
        x =
            Atr.x <| String.fromInt <| Nums.badgeWidth // 2

        y =
            Atr.y <| String.fromInt <| Nums.badgeHeight // 2 + Nums.badgeTextSize // 4

        t =
            Svg.text handle
    in
    Svg.text_ [ x, y ] [ t ]


badgeOffset : Attribute msg
badgeOffset =
    let
        ( i, j ) =
            Nums.badgeOffset

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
