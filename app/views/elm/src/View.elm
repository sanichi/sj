module View exposing (bg, box, discard, hands, pack)

import Card exposing (Card)
import Hand exposing (Hand)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Nums
import Player exposing (Player, Position(..))
import Players exposing (Players)
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
        frame =
            [ packX, packY, cardWidth, cardHeight ]

        url =
            cardUrl model.pack

        msg =
            Model.packMsg model
    in
    cardGroup frame url msg



-- Discard pile


discard : Model -> Svg Msg
discard model =
    let
        frame =
            [ discardX, discardY, cardWidth, cardHeight ]

        url =
            cardUrl model.discard

        msg =
            Noop
    in
    cardGroup frame url msg



-- Players cards


hands : Model -> List (Svg Msg)
hands model =
    List.map cardsAndName <| Players.all model.players



-- Private


badge : Player -> Svg Msg
badge player =
    Svg.g [ Atr.class "badge", badgeOffset player.position ]
        [ badgeRect player
        , badgeText player
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


badgeRect : Player -> Svg Msg
badgeRect player =
    let
        x =
            Atr.x "0"

        y =
            Atr.y "0"

        w =
            Atr.width <| String.fromInt Nums.badgeWidth

        h =
            Atr.height <| String.fromInt Nums.badgeHeight

        c =
            Atr.class <|
                if player.turn then
                    "turn"

                else
                    "wait"

        rx =
            Atr.rx "10"

        ry =
            Atr.ry "10"
    in
    Svg.rect [ x, y, w, h, c, rx, ry ] []


badgeText : Player -> Svg Msg
badgeText player =
    let
        x =
            Atr.x <| String.fromInt <| Nums.badgeWidth // 2

        y =
            Atr.y <| String.fromInt <| Nums.badgeHeight // 2 + Nums.badgeTextSize // 4

        t =
            Svg.text <| Player.badge player
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


cardElement : Player -> Int -> Card -> Svg Msg
cardElement player cid card =
    let
        frame =
            [ cardX cid, cardY cid, cardWidth, cardHeight ]

        url =
            cardUrl card

        msg =
            Player.cardMsg player cid card
    in
    cardGroup frame url msg


cardGroup : List (Attribute Msg) -> Attribute Msg -> Msg -> Svg Msg
cardGroup frame url msg =
    let
        picture =
            if msg == Noop then
                url :: frame

            else
                onClick msg :: url :: frame

        border =
            if msg == Noop then
                frame

            else
                Atr.class "clickable" :: frame
    in
    Svg.g [ Atr.class "card" ]
        [ Svg.image picture []
        , Svg.rect border []
        ]


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


cardX : Int -> Attribute Msg
cardX cid =
    Atr.x <| String.fromInt <| Nums.cardX cid


cardY : Int -> Attribute Msg
cardY cid =
    Atr.y <| String.fromInt <| Nums.cardY cid


discardX : Attribute Msg
discardX =
    Atr.x <| String.fromInt Nums.discardX


discardY : Attribute Msg
discardY =
    Atr.y <| String.fromInt Nums.discardY


groupedCards : Player -> Svg Msg
groupedCards player =
    Svg.g [ cardsOffset player.position ] (Hand.map (cardElement player) player.hand)


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


packX : Attribute Msg
packX =
    Atr.x <| String.fromInt Nums.packX


packY : Attribute Msg
packY =
    Atr.y <| String.fromInt Nums.packY
