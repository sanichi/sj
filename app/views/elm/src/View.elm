module View exposing
    ( bg
    , box
    , debug
    , discard
    , hands
    , pack
    )

import Card exposing (Card)
import Hand exposing (Hand)
import Model exposing (Model, State(..))
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
            packMsg model
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
            discardMsg model
    in
    cardGroup frame url msg



-- Players cards


hands : Model -> List (Svg Msg)
hands model =
    List.map (cardsAndName model.state) <| Players.all model.players



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


cardsAndName : State -> Player -> Svg Msg
cardsAndName state player =
    let
        cards =
            groupedCards state player

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


cardElement : State -> Player -> Int -> Card -> Svg Msg
cardElement state player cid card =
    let
        frame =
            [ cardX cid, cardY cid, cardWidth, cardHeight ]

        url =
            cardUrl card

        msg =
            cardMsg state player cid card
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


cardMsg : State -> Player -> Int -> Card -> Msg
cardMsg state player cid card =
    if player.active && player.turn then
        case state of
            Reveal ->
                if not card.vis then
                    RevealCard player.pid cid

                else
                    Noop

            ChosenDiscard ->
                ChooseDiscardCard player.pid cid

            ChosenPack ->
                ChoosePackCard player.pid cid

            ChosenPackDiscard ->
                if not card.vis then
                    ChoosePackDiscardCard player.pid cid

                else
                    Noop

            _ ->
                Noop

    else
        Noop


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


discardMsg : Model -> Msg
discardMsg model =
    case Model.mainPlayer model of
        Just player ->
            if player.turn then
                case model.state of
                    Choose ->
                        ChooseDiscard player.pid

                    ChosenPack ->
                        ChoosePackDiscard player.pid

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop


discardX : Attribute Msg
discardX =
    Atr.x <| String.fromInt Nums.discardX


discardY : Attribute Msg
discardY =
    Atr.y <| String.fromInt Nums.discardY


groupedCards : State -> Player -> Svg Msg
groupedCards state player =
    Svg.g [ cardsOffset player.position ] (Hand.map (cardElement state player) player.hand)


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


packMsg : Model -> Msg
packMsg model =
    case Model.mainPlayer model of
        Just player ->
            if player.turn then
                case model.state of
                    Choose ->
                        ChoosePack player.pid

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop


packX : Attribute Msg
packX =
    Atr.x <| String.fromInt Nums.packX


packY : Attribute Msg
packY =
    Atr.y <| String.fromInt Nums.packY



-- Debug


debug : Model -> Svg Msg
debug model =
    let
        x =
            Atr.x "10"

        y =
            Atr.y "20"

        c =
            Atr.class "debug"

        t =
            Svg.text <| Model.debug model
    in
    Svg.text_ [ x, y, c ] [ t ]
