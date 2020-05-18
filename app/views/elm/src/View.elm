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
    [ bg, pack model, discard model ]
        ++ hands model
        ++ [ debug model, score model ]
        |> Svg.svg [ Atr.id "card-table", Atr.version "1.1", box ]


box : Attribute Msg
box =
    [ 0, 0, Nums.viewWidth, Nums.viewHeight ]
        |> List.map String.fromInt
        |> String.join " "
        |> Atr.viewBox


bg : Svg Msg
bg =
    Svg.rect [ cc "background", ww Nums.viewWidth, hh Nums.viewHeight ] []


debug : Model -> Svg Msg
debug model =
    let
        t =
            Svg.text <| Model.debug model
    in
    Svg.text_ [ xx 10, yy 20, cc "debug" ] [ t ]



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
    Svg.rect [ x0, y0, ww Nums.badgeWidth, hh Nums.badgeHeight, c, Atr.rx "10", Atr.ry "10" ] []


badgeText : Player -> Svg Msg
badgeText player =
    let
        x =
            xx <| Nums.badgeWidth // 2

        y =
            yy <| Nums.badgeHeight // 2 + Nums.badgeTextSize // 4

        t =
            Svg.text <| Player.badge player
    in
    Svg.text_ [ x, y ] [ t ]



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
    xx Nums.discardX


discardY : Attribute Msg
discardY =
    yy Nums.discardY


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
    xx Nums.packX


packY : Attribute Msg
packY =
    yy Nums.packY



-- Score


score : Model -> Svg Msg
score model =
    let
        num =
            Players.size model.players

        players =
            scorePlayers model
    in
    Svg.g [ cc "score", scoreOffset num ]
        (scoreBackground num :: players)


scoreBackground : Int -> Svg Msg
scoreBackground players =
    Svg.rect [ x0, y0, scoreWidth, scoreHeight players, cc "score-bg" ] []


scoreOffset : Int -> Attribute Msg
scoreOffset players =
    tt Nums.scoreX <| Nums.scoreY players


scorePlayers : Model -> List (Svg Msg)
scorePlayers model =
    Players.all model.players
        |> List.indexedMap scorePlayer


scorePlayer : Int -> Player -> Svg Msg
scorePlayer position player =
    Svg.g [ cc "player-score", scorePlayerOffset position ]
        [ scorePlayerBackground ]


scorePlayerBackground : Svg Msg
scorePlayerBackground =
    Svg.rect [ x0, y0, scorePlayerWidth, scorePlayerHeight, cc "player-score-bg" ] []


scorePlayerOffset : Int -> Attribute Msg
scorePlayerOffset position =
    tt Nums.scorePlayerX <| Nums.scorePlayerY position


scoreX : Attribute Msg
scoreX =
    xx Nums.scoreInsideMargin


scoreY : Int -> Attribute Msg
scoreY position =
    yy Nums.scoreInsideMargin


scorePlayerX : Attribute Msg
scorePlayerX =
    xx Nums.scorePlayerX


scorePlayerY : Int -> Attribute Msg
scorePlayerY num =
    yy <| Nums.scorePlayerY num


scorePlayerWidth : Attribute Msg
scorePlayerWidth =
    ww Nums.scorePlayerWidth


scorePlayerHeight : Attribute Msg
scorePlayerHeight =
    hh Nums.scorePlayerHeight


scoreWidth : Attribute Msg
scoreWidth =
    ww Nums.scoreWidth


scoreHeight : Int -> Attribute Msg
scoreHeight num =
    hh <| Nums.scoreHeight num



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


tt : Int -> Int -> Attribute Msg
tt x y =
    Atr.transform <| "translate(" ++ String.fromInt x ++ " " ++ String.fromInt y ++ ")"


x0 : Attribute Msg
x0 =
    Atr.x "0"


y0 : Attribute Msg
y0 =
    Atr.y "0"


xx : Int -> Attribute Msg
xx x =
    Atr.x <| String.fromInt x


yy : Int -> Attribute Msg
yy y =
    Atr.y <| String.fromInt y
