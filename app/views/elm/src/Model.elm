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
    , updateChoosePackCard
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
    | Choose
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


newUpdate : Update -> Model -> Model
newUpdate update model =
    let
        ( key, val ) =
            update
    in
    case key of
        "pack" ->
            case val of
                [ num ] ->
                    updatePack num model

                _ ->
                    model

        "discard" ->
            case val of
                [ num ] ->
                    updateDiscard num model

                _ ->
                    model

        "hand" ->
            case val of
                pid :: nums ->
                    playerHand pid nums model

                _ ->
                    model

        "reveal" ->
            case val of
                [ pid, cid ] ->
                    revealCard pid cid model

                _ ->
                    model

        "pack_card" ->
            case val of
                [ pid, cid, num ] ->
                    model
                        |> updateChoosePackCard pid cid
                        |> updatePack num

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
updateChooseDiscard model =
    model
        |> updateState ChosenDiscard


updateChoosePack : Model -> Model
updateChoosePack model =
    model
        |> updatePackExposed model.pack.num
        |> updateState ChosenPack


updateChoosePackCard : Int -> Int -> Model -> Model
updateChoosePackCard pid cid model =
    case model.state of
        ChosenPack ->
            let
                playerCard =
                    getPlayerCard pid cid model
            in
            case playerCard of
                ( Just player, Just card ) ->
                    let
                        players =
                            Players.updatePackCard cid model.pack player model.players
                    in
                    model
                        |> updatePlayers players
                        |> updateDiscard card.num
                        |> updateState Choose

                _ ->
                    model

        _ ->
            model


revealCard : Int -> Int -> Model -> Model
revealCard pid cid model =
    let
        playerCard =
            getPlayerCard pid cid model
    in
    case playerCard of
        ( Just player, Just card ) ->
            let
                players =
                    Players.updateReveal cid card player model.players

                allDone =
                    Players.toList players
                        |> List.map .hand
                        |> List.map Hand.exposed
                        |> List.map (\n -> n == 2)
                        |> List.foldl (&&) True

                state =
                    if allDone then
                        Choose

                    else
                        model.state
            in
            model
                |> updatePlayers players
                |> updateState state

        _ ->
            model


debug : Model -> String
debug model =
    let
        pid =
            String.fromInt model.player_id

        state =
            case model.state of
                Revealing ->
                    "Revealing"

                Choose ->
                    "Choose"

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


getPlayer : Int -> Model -> Maybe Player
getPlayer pid model =
    Players.get pid model.players


getPlayerCard : Int -> Int -> Model -> ( Maybe Player, Maybe Card )
getPlayerCard pid cid model =
    let
        player =
            getPlayer pid model

        card =
            case player of
                Just p ->
                    Hand.get cid p.hand

                Nothing ->
                    Nothing
    in
    ( player, card )


playerHand : Int -> List Int -> Model -> Model
playerHand pid nums model =
    let
        player =
            Players.get pid model.players

        hand =
            Hand.init nums
    in
    case player of
        Just p ->
            { model | players = Players.put pid { p | hand = hand } model.players }

        Nothing ->
            model


updateDiscard : Int -> Model -> Model
updateDiscard num model =
    { model | discard = Card.exposed num }


updatePack : Int -> Model -> Model
updatePack num model =
    { model | pack = Card.hidden num }


updatePackExposed : Int -> Model -> Model
updatePackExposed num model =
    { model | pack = Card.exposed num }


updatePlayers : Players -> Model -> Model
updatePlayers players model =
    { model | players = players }


updateState : State -> Model -> Model
updateState state model =
    { model | state = state }
