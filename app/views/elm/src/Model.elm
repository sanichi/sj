module Model exposing (Model, init, reveal, update)

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
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
reveal m id index =
    let
        p =
            getPlayer m id

        c =
            case p of
                Just player ->
                    Hand.get index player.hand

                Nothing ->
                    Nothing
    in
    case ( p, c ) of
        ( Just player, Just card ) ->
            let
                uCard =
                    Card.exposed card.num

                uHand =
                    Hand.set index uCard player.hand

                uPlayer =
                    { player | hand = uHand }

                uPlayers =
                    Player.put id uPlayer m.players
            in
            { m | players = uPlayers }

        _ ->
            m


update : Model -> Update -> Model
update m u =
    let
        pack =
            case u.pack of
                Just num ->
                    Card.hidden num

                Nothing ->
                    m.pack

        discard =
            case u.discard of
                Just num ->
                    Card.exposed num

                Nothing ->
                    m.discard

        player =
            case u.player_id of
                Just id ->
                    Player.get id m.players

                Nothing ->
                    Nothing

        hand =
            case u.hand of
                Just nums ->
                    Just (Hand.init nums)

                Nothing ->
                    Nothing

        players =
            case ( player, hand ) of
                ( Just p, Just h ) ->
                    Player.put p.id { p | hand = h } m.players

                _ ->
                    m.players
    in
    { m | pack = pack, discard = discard, players = players }



-- Private


getPlayer : Model -> Int -> Maybe Player
getPlayer model id =
    Player.get id model.players
