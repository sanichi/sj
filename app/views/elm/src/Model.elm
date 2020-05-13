module Model exposing (Model, init, packMsg, packVis, reveal, update)

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
            { m | players = Players.updateReveal cid card player m.players }

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
            case u.pack_vis of
                Just vis ->
                    packVis m1 vis

                Nothing ->
                    m1

        m3 =
            case u.discard of
                Just num ->
                    { m2 | discard = Card.exposed num }

                Nothing ->
                    m2

        p =
            case u.player_id of
                Just pid ->
                    Players.get pid m.players

                Nothing ->
                    Nothing

        h =
            case u.hand of
                Just nums ->
                    Just (Hand.init nums)

                Nothing ->
                    Nothing

        m4 =
            case ( p, h ) of
                ( Just player, Just hand ) ->
                    { m3 | players = Players.put player.pid { player | hand = hand } m.players }

                _ ->
                    m3

        m5 =
            case ( p, u.reveal ) of
                ( Just player, Just cid ) ->
                    reveal m4 player.pid cid

                _ ->
                    m4
    in
    m5



-- Private


getPlayer : Model -> Int -> Maybe Player
getPlayer model pid =
    Players.get pid model.players


getActivePlayer : Model -> Maybe Player
getActivePlayer model =
    Players.get model.player_id model.players
