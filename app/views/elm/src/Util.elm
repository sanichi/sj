module Util exposing (bg, box, discard, hands, pack)

import Card exposing (Card)
import Hand exposing (Hand)
import Model exposing (Model)
import Nums
import Player exposing (Player, Position(..))
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


discard : Model -> Svg msg
discard model =
    let
        x =
            String.fromInt Nums.discardX |> Atr.x

        y =
            String.fromInt Nums.discardY |> Atr.y

        u =
            cardUrl model.discard
    in
    Svg.image [ x, y, cardWidth, cardHeight, u ] []



-- Players cards


hands : Model -> List (Svg msg)
hands model =
    Player.all model.players
        |> List.map cardsAndName



-- Private


cardsAndName : Player -> Svg msg
cardsAndName player =
    let
        cards =
            groupedCards player

        name =
            badge player

        translate =
            handOffset player.position
    in
    Svg.g [ translate ] [ name, cards ]


groupedCards : Player -> Svg msg
groupedCards player =
    Svg.g [ cardsOffset player.position ] (individualCards [] player.hand)


individualCards : List (Svg msg) -> Hand -> List (Svg msg)
individualCards elements cards =
    case cards of
        [] ->
            elements

        card :: rest ->
            let
                element =
                    cardElement card (List.length elements)
            in
            individualCards (element :: elements) rest


cardsOffset : Position -> Attribute msg
cardsOffset position =
    let
        y =
            Nums.cardsYOffset position |> String.fromInt
    in
    Atr.transform <| "translate(0 " ++ y ++ ")"


handOffset : Position -> Attribute msg
handOffset position =
    let
        ( i, j ) =
            Nums.handOffset position

        x =
            String.fromInt i

        y =
            String.fromInt j
    in
    Atr.transform <| "translate(" ++ x ++ " " ++ y ++ ")"


badge : Player -> Svg msg
badge player =
    Svg.g [ Atr.class "badge", badgeOffset player.position ]
        [ badgeRect
        , badgeText player.handle
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


badgeOffset : Position -> Attribute msg
badgeOffset position =
    let
        ( i, j ) =
            Nums.badgeOffset position

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
            if not card.vis then
                "back"

            else if card.num >= 0 && card.num <= 12 then
                "p" ++ String.fromInt card.num

            else if card.num == -1 then
                "m1"

            else if card.num == -2 then
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
