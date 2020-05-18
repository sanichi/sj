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

        extras =
            if model.state == HandOver then
                score model :: extras_

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
    Svg.text_ [ xx 10, yy 20, cc "debug" ] [ tx <| Model.debug model ]



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
            Reveal ->
                if not card.exposed then
                    RevealCard player.pid cid

                else
                    Noop

            ChosenDiscard ->
                ChooseDiscardCard player.pid cid

            ChosenPack ->
                ChoosePackCard player.pid cid

            ChosenPackDiscard ->
                if not card.exposed then
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
                        ChooseDiscard player.pid

                    ChosenPack ->
                        ChoosePackDiscard player.pid

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
                        ChoosePack player.pid

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop



-- Score


score : Model -> Svg Msg
score model =
    let
        num =
            Players.size model.players

        pid =
            model.player_id

        players =
            scorePlayers model

        total =
            Model.myTotalScore model

        button =
            scoreButton pid total
    in
    Svg.g [ cc "score", scoreOffset num ]
        ([ scoreBackground num, button ] ++ players)


scoreBackground : Int -> Svg Msg
scoreBackground players =
    Svg.rect [ ww Nums.scoreWidth, hh <| Nums.scoreHeight players, rx, ry, cc "score-bg" ] []


scoreButton : Int -> Int -> Svg Msg
scoreButton pid total =
    let
        msg =
            ChooseDiscardCard pid total

        -- XXX need to change
    in
    Svg.g [ scoreButtonOffset, onClick msg ]
        [ scoreButtonBackground
        , scoreButtonText
        ]


scoreButtonBackground : Svg Msg
scoreButtonBackground =
    Svg.rect [ ww Nums.scoreButtonWidth, hh Nums.scoreButtonHeight, rx, ry, cc "score-button" ] []


scoreButtonOffset : Attribute Msg
scoreButtonOffset =
    tt Nums.scoreButtonX Nums.scoreButtonY


scoreButtonText : Svg Msg
scoreButtonText =
    Svg.text_ [ xx Nums.scoreButtonTextX, yy Nums.scoreButtonTextY ] [ tx "next hand" ]


scoreOffset : Int -> Attribute Msg
scoreOffset players =
    tt Nums.scoreX <| Nums.scoreY players


scorePlayers : Model -> List (Svg Msg)
scorePlayers model =
    Players.all model.players
        |> List.indexedMap (scorePlayer model.upto)


scorePlayer : Int -> Int -> Player -> Svg Msg
scorePlayer upto position player =
    let
        total =
            Player.totalScore player

        percent =
            if total >= upto then
                100

            else
                total * 100 // upto
    in
    Svg.g [ cc "player-score", scorePlayerOffset position ]
        [ scorePlayerBackground
        , scorePlayerProgress percent
        , scorePlayerText player
        ]


scorePlayerBackground : Svg Msg
scorePlayerBackground =
    Svg.rect [ ww Nums.scorePlayerWidth, hh Nums.scorePlayerHeight, cc "player-score-bg" ] []


scorePlayerOffset : Int -> Attribute Msg
scorePlayerOffset position =
    tt Nums.scorePlayerX <| Nums.scorePlayerY position


scorePlayerText : Player -> Svg Msg
scorePlayerText player =
    Svg.text_ [ xx Nums.scorePlayerTextX, yy Nums.scorePlayerTextY ] [ tx <| Player.scoreText player ]


scorePlayerProgress : Int -> Svg Msg
scorePlayerProgress percent =
    let
        width =
            Nums.scorePlayerWidth * percent // 100
    in
    Svg.rect [ ww width, hh Nums.scorePlayerHeight, cc "player-progress" ] []



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
    Atr.rx "16"


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
