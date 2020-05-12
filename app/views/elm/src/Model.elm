module Model exposing (Model, init, reveal, update)

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Msg
import Player exposing (Player, Players)
import Setup
import Update exposing (Update)


type alias Model =
    { player_id : Int
    , pack : Card
    , discard : Card
    , players : Players
    }


init : Value -> Model
init flags =
    let
        setup =
            Setup.decode flags
    in
    { player_id = setup.player_id
    , pack = Card.hidden 0
    , discard = Card.exposed 0
    , players = Player.init setup.players
    }


reveal : Model -> Int -> Int -> Model
reveal m pid cid =
    let
        p =
            getPlayer m pid

        c =
            case p of
                Just player ->
                    Hand.get cid player.hand

                Nothing ->
                    Nothing
    in
    case ( p, c ) of
        ( Just player, Just card ) ->
            let
                uCard =
                    Card.exposed card.num

                uHand =
                    Hand.set cid uCard player.hand

                uPlayer =
                    { player | hand = uHand }

                uPlayers =
                    Player.put pid uPlayer m.players

                uTurns =
                    Player.updateReveal uPlayers
            in
            { m | players = uTurns }

        _ ->
            m


update : Model -> Update -> Model
update m u =
    let
        m1 =
            case u.pack of
                Just num ->
                    { m | pack = Card.hidden num }

                Nothing ->
                    m

        m2 =
            case u.discard of
                Just num ->
                    { m1 | discard = Card.exposed num }

                Nothing ->
                    m1

        p =
            case u.player_id of
                Just pid ->
                    Player.get pid m.players

                Nothing ->
                    Nothing

        h =
            case u.hand of
                Just nums ->
                    Just (Hand.init nums)

                Nothing ->
                    Nothing

        m3 =
            case ( p, h ) of
                ( Just player, Just hand ) ->
                    { m2 | players = Player.put player.pid { player | hand = hand } m.players }

                _ ->
                    m2

        m4 =
            case ( p, u.reveal ) of
                ( Just player, Just cid ) ->
                    reveal m3 player.pid cid

                _ ->
                    m3
    in
    m4



-- Private


getPlayer : Model -> Int -> Maybe Player
getPlayer model pid =
    Player.get pid model.players
