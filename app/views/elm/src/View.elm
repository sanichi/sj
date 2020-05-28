module View exposing (view)

import Card exposing (Card)
import Hand exposing (Hand)
import Html exposing (Html)
import Model exposing (Model, State(..))
import Msg exposing (Msg(..))
import Nums
import Player exposing (Player, Position(..))
import Players exposing (Players)
import Svg exposing (Attribute, Svg)
import Svg.Attributes as Atr
import Svg.Events exposing (onClick)


view : Model -> Html Msg
view model =
    let
        extras_ =
            if model.debug then
                [ debug model ]

            else
                []

        state =
            model.state

        extras =
            if state == HandOver || state == Waiting || state == GameOver then
                button model :: extras_

            else
                extras_
    in
    [ bg, pack model, discard model ]
        ++ hands model
        ++ extras
        |> Svg.svg [ Atr.id "card-table", Atr.version "1.1", box ]


box : Attribute Msg
box =
    [ 0, 0, Nums.viewWidth, Nums.viewHeight ]
        |> List.map String.fromInt
        |> String.join " "
        |> Atr.viewBox


bg : Svg Msg
bg =
    Svg.rect [ ww Nums.viewWidth, hh Nums.viewHeight, cc "background" ] []


debug : Model -> Svg Msg
debug model =
    Svg.text_ [ xx Nums.debugTextX, yy Nums.debugTextY, cc "debug" ] [ tx <| Model.debug model ]



-- Player badges


badge : Player -> Svg Msg
badge player =
    Svg.g [ cc "badge", badgeOffset player.position ]
        [ badgeRect player
        , badgeText player
        ]


badgeOffset : Position -> Attribute Msg
badgeOffset position =
    let
        ( x, y ) =
            Nums.badgeOffset position
    in
    tt x y


badgeRect : Player -> Svg Msg
badgeRect player =
    let
        c =
            cc <|
                if player.turn then
                    "turn"

                else
                    "wait"
    in
    Svg.rect [ ww Nums.badgeWidth, hh Nums.badgeHeight, c, rx, ry ] []


badgeText : Player -> Svg Msg
badgeText player =
    Svg.text_ [ xx Nums.badgeTextX, yy Nums.badgeTextY ] [ tx <| Player.badge player ]



-- Player cards


hands : Model -> List (Svg Msg)
hands model =
    List.map (cardsAndName model.state) <| Players.all model.players


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
    tt 0 <| Nums.cardsYOffset position


cardElement : State -> Player -> Int -> Card -> Maybe (Svg Msg)
cardElement state player cid card =
    if card.exists then
        let
            frame =
                [ cardX cid, cardY cid, cardWidth, cardHeight ]

            url =
                cardUrl card

            msg =
                cardMsg state player cid card

            grp =
                cardGroup frame url msg
        in
        Just grp

    else
        Nothing


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
                cc "clickable" :: frame
    in
    Svg.g [ cc "card" ]
        [ Svg.image picture []
        , Svg.rect border []
        ]


cardHeight : Attribute Msg
cardHeight =
    hh Nums.cardHeight


cardMsg : State -> Player -> Int -> Card -> Msg
cardMsg state player cid card =
    if player.active && player.turn then
        case state of
            Reveal2 ->
                if not card.exposed then
                    RevealCard cid

                else
                    Noop

            ChosenDiscard ->
                ChooseDiscardCard cid

            ChosenPack ->
                ChoosePackCard cid

            ChosenPackDiscard ->
                if not card.exposed then
                    ChoosePackDiscardCard cid

                else
                    Noop

            RevealRest outPid ->
                if not card.exposed then
                    RevealCard cid

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
            if not card.exposed then
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
    ww Nums.cardWidth


cardX : Int -> Attribute Msg
cardX cid =
    xx <| Nums.cardX cid


cardY : Int -> Attribute Msg
cardY cid =
    yy <| Nums.cardY cid


groupedCards : State -> Player -> Svg Msg
groupedCards state player =
    let
        mapper =
            cardElement state player

        elements =
            Hand.map mapper player.hand
                |> List.filterMap identity
    in
    Svg.g [ cardsOffset player.position ] elements


handOffset : Position -> Attribute Msg
handOffset position =
    let
        ( x, y ) =
            Nums.handOffset position
    in
    tt x y



-- Discard pile


discard : Model -> Svg Msg
discard model =
    let
        frame =
            [ xx Nums.discardX, yy Nums.discardY, cardWidth, cardHeight ]

        url =
            cardUrl model.discard

        msg =
            discardMsg model
    in
    cardGroup frame url msg


discardMsg : Model -> Msg
discardMsg model =
    case Model.mainPlayer model of
        Just player ->
            if player.turn then
                case model.state of
                    Choose ->
                        ChooseDiscard

                    ChosenPack ->
                        ChoosePackDiscard

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop



-- Pack


pack : Model -> Svg Msg
pack model =
    let
        frame =
            [ xx Nums.packX, yy Nums.packY, cardWidth, cardHeight ]

        url =
            cardUrl model.pack

        msg =
            packMsg model
    in
    cardGroup frame url msg


packMsg : Model -> Msg
packMsg model =
    case Model.mainPlayer model of
        Just player ->
            if player.turn then
                case model.state of
                    Choose ->
                        ChoosePack

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop



-- Button


button : Model -> Svg Msg
button model =
    Svg.g [ cc "score", buttonOffset ]
        [ buttonGroup model ]


buttonGroup : Model -> Svg Msg
buttonGroup model =
    let
        attrs =
            case model.state of
                HandOver ->
                    let
                        total =
                            Model.totalForMain model
                    in
                    [ onClick (NextHand total) ]

                GameOver ->
                    let
                        totals =
                            Model.totalsForAll model
                    in
                    [ onClick (EndGame totals) ]

                _ ->
                    []
    in
    Svg.g attrs
        [ buttonBackground model.state
        , buttonText model.state
        ]


buttonBackground : State -> Svg Msg
buttonBackground state =
    let
        class =
            case state of
                Waiting ->
                    "score-button-disabled"

                _ ->
                    "score-button"
    in
    Svg.rect [ ww Nums.buttonWidth, hh Nums.buttonHeight, rx, ry, cc class ] []


buttonText : State -> Svg Msg
buttonText state =
    let
        t =
            case state of
                HandOver ->
                    "next hand"

                GameOver ->
                    "save results"

                _ ->
                    "please wait"
    in
    Svg.text_ [ xx Nums.buttonTextX, yy Nums.buttonTextY ] [ tx t ]


buttonOffset : Attribute Msg
buttonOffset =
    tt Nums.buttonX Nums.buttonY



-- Utilities


cc : String -> Attribute Msg
cc c =
    Atr.class c


ww : Int -> Attribute Msg
ww w =
    Atr.width <| String.fromInt w


hh : Int -> Attribute Msg
hh h =
    Atr.height <| String.fromInt h


rx : Attribute Msg
rx =
    Atr.rx "14"


ry : Attribute Msg
ry =
    Atr.ry "10"


tt : Int -> Int -> Attribute Msg
tt x y =
    Atr.transform <| "translate(" ++ String.fromInt x ++ " " ++ String.fromInt y ++ ")"


tx : String -> Svg Msg
tx t =
    Svg.text t


xx : Int -> Attribute Msg
xx x =
    Atr.x <| String.fromInt x


yy : Int -> Attribute Msg
yy y =
    Atr.y <| String.fromInt y
