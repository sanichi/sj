module Util exposing (bg, box, discard, hands, pack)

import Card exposing (Card)
import Hand exposing (Hand)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Nums
import Player exposing (Player, Position(..))
import Svg exposing (Attribute, Svg)
import Svg.Attributes as Atr
import Svg.Events exposing (onClick)



-- Visible box


box : Attribute Msg
box =
    [ 0, 0, Nums.viewWidth, Nums.viewHeight ]
        |> List.map String.fromInt
        |> String.join " "
        |> Atr.viewBox



-- Background


bg : Svg Msg
bg =
    let
        w =
            String.fromInt Nums.viewWidth |> Atr.width

        h =
            String.fromInt Nums.viewHeight |> Atr.height
    in
    Svg.rect [ Atr.class "background", w, h ] []



-- Pack


pack : Model -> Svg Msg
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


discard : Model -> Svg Msg
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


hands : Model -> List (Svg Msg)
hands model =
    List.map cardsAndName <| Player.all model.players



-- Private


badge : Player -> Svg Msg
badge player =
    Svg.g [ Atr.class "badge", badgeOffset player.position ]
        [ badgeRect
        , badgeText player.handle
        ]


badgeOffset : Position -> Attribute Msg
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


badgeRect : Svg Msg
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


badgeText : String -> Svg Msg
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


cardsAndName : Player -> Svg Msg
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


cardsOffset : Position -> Attribute Msg
cardsOffset position =
    let
        y =
            Nums.cardsYOffset position |> String.fromInt
    in
    Atr.transform <| "translate(0 " ++ y ++ ")"


cardElement : Int -> Int -> Card -> Svg Msg
cardElement id index card =
    let
        x =
            Atr.x <| String.fromInt <| Nums.cardX index

        y =
            Atr.y <| String.fromInt <| Nums.cardY index

        u =
            cardUrl card

        c =
            onClick (Reveal id index)
    in
    Svg.image [ x, y, cardWidth, cardHeight, u, c ] []


cardHeight : Attribute Msg
cardHeight =
    String.fromInt Nums.cardHeight |> Atr.height


cardUrl : Card -> Attribute Msg
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


cardWidth : Attribute Msg
cardWidth =
    String.fromInt Nums.cardWidth |> Atr.width


groupedCards : Player -> Svg Msg
groupedCards player =
    Svg.g [ cardsOffset player.position ] (Hand.map (cardElement player.id) player.hand)


handOffset : Position -> Attribute Msg
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
