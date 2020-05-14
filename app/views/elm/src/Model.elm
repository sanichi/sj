module Model exposing (Model, init, newUpdate, packMsg, packVis, revealCard)

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Msg exposing (Msg(..))
import Player exposing (Player, State(..))
import Players exposing (Players)
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
    , players = Players.init setup.player_id setup.players
    }


packMsg : Model -> Msg
packMsg model =
    case getActivePlayer model of
        Just player ->
            if player.turn then
                case player.state of
                    ReadyForTurn ->
                        if model.pack.vis then
                            Noop

                        else
                            PackVis True

                    _ ->
                        Noop

            else
                Noop

        Nothing ->
            Noop


packVis : Model -> Bool -> Model
packVis m vis =
    let
        pack =
            Card m.pack.num vis
    in
    { m | pack = pack }


newUpdate : Model -> Update -> Model
newUpdate model update =
    let
        ( key, val ) =
            update
    in
    case key of
        "pack" ->
            case val of
                [ num ] ->
                    { model | pack = Card.hidden num }

                _ ->
                    model

        "pack_vis" ->
            case val of
                [ num ] ->
                    packVis model (num /= 0)

                _ ->
                    model

        "discard" ->
            case val of
                [ num ] ->
                    { model | discard = Card.exposed num }

                _ ->
                    model

        "hand" ->
            case val of
                pid :: nums ->
                    let
                        player_ =
                            Players.get pid model.players

                        hand =
                            Hand.init nums
                    in
                    case player_ of
                        Just player ->
                            { model | players = Players.put pid { player | hand = hand } model.players }

                        Nothing ->
                            model

                _ ->
                    model

        "reveal" ->
            case val of
                [ pid, cid ] ->
                    revealCard model pid cid

                _ ->
                    model

        _ ->
            model


revealCard : Model -> Int -> Int -> Model
revealCard m pid cid =
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
            { m | players = Players.updateReveal cid card player m.players }

        _ ->
            m



-- Private


getPlayer : Model -> Int -> Maybe Player
getPlayer model pid =
    Players.get pid model.players


getActivePlayer : Model -> Maybe Player
getActivePlayer model =
    Players.get model.player_id model.players
