module Model exposing (Model, init, update)

import Card exposing (Card)
import Dict
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Player exposing (Players)
import Setup
import Update exposing (Update)


type alias Model =
    { player_id : Int
    , pack : Card
    , disc : Card
    , hand : Hand
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
    , hand = Hand.init
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

        hand =
            case u.hand of
                Just nums ->
                    List.map Card.hidden nums

                Nothing ->
                    m.hand
    in
    { m | pack = pack, disc = disc, hand = hand }
