module Model exposing (Model, init, update)

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Player exposing (Players)
import Setup
import Update exposing (Update)


type alias Model =
    { player_id : Int
    , pack : Card
    , disc : Card
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
    , disc = Card.exposed 0
    , players = Player.init setup.players
    }


update : Model -> Update -> Model
update m u =
    let
        pack =
            case u.pack of
                Just num ->
                    Card.hidden num

                Nothing ->
                    m.pack

        disc =
            case u.disc of
                Just num ->
                    Card.exposed num

                Nothing ->
                    m.disc

        player =
            case u.player of
                Just id ->
                    Player.get m.players id

                Nothing ->
                    Nothing

        hand =
            case u.hand of
                Just nums ->
                    -- XXX for debugging use exposed istead of hidden
                    Just (List.map Card.exposed nums)

                Nothing ->
                    Nothing

        players =
            case ( player, hand ) of
                ( Just p, Just h ) ->
                    Player.put m.players p.id { p | hand = h }

                _ ->
                    m.players
    in
    { m | pack = pack, disc = disc, players = players }
