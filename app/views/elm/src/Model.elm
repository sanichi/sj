module Model exposing
    ( Model
    , State(..)
    , debug
    , init
    , mainPlayer
    , newUpdate
    , revealCard
    , updateChooseDiscard
    , updateChoosePack
    )

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Msg exposing (Msg(..))
import Player exposing (Player)
import Players exposing (Players)
import Setup
import Update exposing (Update)


type alias Model =
    { player_id : Int
    , pack : Card
    , discard : Card
    , players : Players
    , state : State
    }


type State
    = Revealing
    | Ready
    | ChosenPack
    | ChosenDiscard


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
    , state = Revealing
    }


mainPlayer : Model -> Maybe Player
mainPlayer model =
    Players.get model.player_id model.players


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
                    updatePack model num

                _ ->
                    model

        "discard" ->
            case val of
                [ num ] ->
                    updateDiscard model num

                _ ->
                    model

        "hand" ->
            case val of
                pid :: nums ->
                    playerHand model pid nums

                _ ->
                    model

        "reveal" ->
            case val of
                [ pid, cid ] ->
                    revealCard model pid cid

                _ ->
                    model

        "elm_state" ->
            case val of
                [ code ] ->
                    case code of
                        1 ->
                            updateChoosePack model

                        2 ->
                            updateChooseDiscard model

                        _ ->
                            model

                _ ->
                    model

        _ ->
            model


updateChooseDiscard : Model -> Model
updateChooseDiscard m =
    { m | state = ChosenDiscard }


updateChoosePack : Model -> Model
updateChoosePack m =
    let
        pack =
            Card.exposed m.pack.num
    in
    { m | pack = pack, state = ChosenPack }


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
            let
                players =
                    Players.updateReveal cid card player m.players

                allDone =
                    Players.toList players
                        |> List.map .hand
                        |> List.map Hand.exposed
                        |> List.map (\n -> n == 2)
                        |> List.foldl (&&) True

                state =
                    if allDone then
                        Ready

                    else
                        m.state
            in
            { m | players = players, state = state }

        _ ->
            m


debug : Model -> String
debug model =
    let
        pid =
            String.fromInt model.player_id

        state =
            case model.state of
                Revealing ->
                    "Revealing"

                Ready ->
                    "Ready"

                ChosenPack ->
                    "ChosenPack"

                ChosenDiscard ->
                    "ChosenDiscard"

        plrs =
            List.map Player.debug <| Players.toList model.players

        pck =
            String.fromInt model.pack.num

        mdl =
            String.join " " [ pid, pck, state ]
    in
    String.join " | " (mdl :: plrs)



-- Private


getPlayer : Model -> Int -> Maybe Player
getPlayer model pid =
    Players.get pid model.players


playerHand : Model -> Int -> List Int -> Model
playerHand model pid nums =
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


updatePack : Model -> Int -> Model
updatePack model num =
    { model | pack = Card.hidden num }


updateDiscard : Model -> Int -> Model
updateDiscard model num =
    { model | discard = Card.exposed num }
