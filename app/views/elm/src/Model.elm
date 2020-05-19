module Model exposing
    ( Model
    , State(..)
    , chooseDiscard
    , chooseDiscardCard
    , choosePack
    , choosePackCard
    , choosePackDiscard
    , choosePackDiscardCard
    , debug
    , init
    , mainPlayer
    , myTotalScore
    , newHand
    , newUpdate
    , revealCard
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
    { pid : Int
    , pack : Card
    , discard : Card
    , players : Players
    , state : State
    , upto : Int
    , debug : Bool
    }


type State
    = Reveal
    | Choose
    | ChosenPack
    | ChosenPackDiscard
    | ChosenDiscard
    | HandOver
    | Waiting


init : Value -> Model
init flags =
    let
        setup =
            Setup.decode flags
    in
    { pid = setup.player_id
    , pack = Card.hidden 0
    , discard = Card.exposed 0
    , players = Players.init setup.player_id setup.players
    , state = Reveal
    , upto = setup.upto
    , debug = setup.debug
    }


mainPlayer : Model -> Maybe Player
mainPlayer model =
    Players.get model.pid model.players


myTotalScore : Model -> Int
myTotalScore model =
    Players.totalScore model.pid model.players


newUpdate : Update -> Model -> Model
newUpdate update model =
    let
        ( key, val ) =
            update
    in
    case key of
        "deal_pack" ->
            case val of
                [ num ] ->
                    updatePack num model

                _ ->
                    model

        "deal_discard" ->
            case val of
                [ num ] ->
                    updateDiscard num model

                _ ->
                    model

        "deal_hand" ->
            case val of
                pid :: nums ->
                    playerHand pid nums model

                _ ->
                    model

        "reveal_card" ->
            case val of
                [ pid, cid ] ->
                    revealCard pid cid model

                _ ->
                    model

        "discard_card" ->
            case val of
                [ pid, cid ] ->
                    chooseDiscardCard pid cid model

                _ ->
                    model

        "discard_chosen" ->
            case val of
                [ pid ] ->
                    chooseDiscard pid model

                _ ->
                    model

        "pack_chosen" ->
            case val of
                [ pid ] ->
                    choosePack pid model

                _ ->
                    model

        "pack_card" ->
            case val of
                [ pid, cid ] ->
                    choosePackCard pid cid model

                _ ->
                    model

        "pack_discard_card" ->
            case val of
                [ pid, cid ] ->
                    choosePackDiscardCard pid cid model

                _ ->
                    model

        "pack_discard_chosen" ->
            case val of
                [ pid ] ->
                    choosePackDiscard pid model

                _ ->
                    model

        "next_hand" ->
            case val of
                [ pid, score ] ->
                    newHand pid score model

                _ ->
                    model

        "reset_player" ->
            case val of
                [ pid, score ] ->
                    resetPlayer pid score model

                _ ->
                    model

        _ ->
            model


chooseDiscard : Int -> Model -> Model
chooseDiscard pid model =
    if pid == model.pid then
        updateState ChosenDiscard model

    else
        model


chooseDiscardCard : Int -> Int -> Model -> Model
chooseDiscardCard pid cid model =
    let
        playerCard =
            getPlayerCard pid cid model
    in
    case playerCard of
        ( Just player, Just card ) ->
            let
                ( players, num ) =
                    Players.updateCard cid model.discard player model.players
            in
            model
                |> updatePlayers players
                |> updateDiscard (Maybe.withDefault card.num num)
                |> checkTurn

        _ ->
            model


choosePack : Int -> Model -> Model
choosePack pid model =
    let
        state =
            if pid == model.pid then
                ChosenPack

            else
                model.state
    in
    model
        |> exposePack
        |> updateState state


choosePackCard : Int -> Int -> Model -> Model
choosePackCard pid cid model =
    let
        playerCard =
            getPlayerCard pid cid model
    in
    case playerCard of
        ( Just player, Just card ) ->
            let
                ( players, num ) =
                    Players.updateCard cid model.pack player model.players
            in
            model
                |> hidePack
                |> updatePlayers players
                |> updateDiscard (Maybe.withDefault card.num num)
                |> checkTurn

        _ ->
            model


choosePackDiscard : Int -> Model -> Model
choosePackDiscard pid model =
    if pid == model.pid then
        model
            |> hidePack
            |> updateDiscard model.pack.num
            |> updateState ChosenPackDiscard

    else
        model


choosePackDiscardCard : Int -> Int -> Model -> Model
choosePackDiscardCard pid cid model =
    let
        playerCard =
            getPlayerCard pid cid model
    in
    case playerCard of
        ( Just player, Just card ) ->
            let
                ( players, num ) =
                    Players.updateCard cid card player model.players
            in
            if pid == model.pid then
                model
                    |> updatePlayers players
                    |> updateDiscard (Maybe.withDefault model.discard.num num)
                    |> checkTurn

            else
                model
                    |> hidePack
                    |> updatePlayers players
                    |> updateDiscard (Maybe.withDefault model.pack.num num)
                    |> checkTurn

        _ ->
            model


newHand : Int -> Int -> Model -> Model
newHand pid score model =
    if pid == model.pid then
        updateState Waiting model

    else
        model


resetPlayer : Int -> Int -> Model -> Model
resetPlayer pid score model =
    let
        player =
            Players.get pid model.players
    in
    case player of
        Just p ->
            let
                uPlayer =
                    { p | score = score, turn = True }

                uPlayers =
                    Players.put pid uPlayer model.players
            in
            { model | players = uPlayers, state = Reveal }

        Nothing ->
            model


debug : Model -> String
debug model =
    let
        pid =
            String.fromInt model.pid

        state =
            case model.state of
                Reveal ->
                    "Reveal"

                Choose ->
                    "Choose"

                ChosenPack ->
                    "ChosenPack"

                ChosenDiscard ->
                    "ChosenDiscard"

                ChosenPackDiscard ->
                    "ChosenPackDiscard"

                HandOver ->
                    "HandOver"

                Waiting ->
                    "Waiting"

        plrs =
            List.map Player.debug <| Players.toList model.players

        pck =
            String.fromInt model.pack.num

        mdl =
            String.join " " [ pid, pck, state ]
    in
    String.join " | " (mdl :: plrs)


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
                        Reveal
            in
            model
                |> updatePlayers players
                |> updateState state

        _ ->
            model



-- Private


checkTurn : Model -> Model
checkTurn model =
    let
        toMove =
            Players.toMove model.players

        state =
            case toMove of
                Just player ->
                    if Hand.out player.hand then
                        HandOver

                    else
                        Choose

                Nothing ->
                    HandOver
    in
    updateState state model


exposePack : Model -> Model
exposePack model =
    { model | pack = Card.exposed model.pack.num }


getPlayerCard : Int -> Int -> Model -> ( Maybe Player, Maybe Card )
getPlayerCard pid cid model =
    let
        player =
            Players.get pid model.players

        card =
            case player of
                Just p ->
                    Hand.get cid p.hand

                Nothing ->
                    Nothing
    in
    ( player, card )


hidePack : Model -> Model
hidePack model =
    { model | pack = Card.hidden model.pack.num }


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
            let
                uPlayer =
                    { p | hand = hand }

                uPlayers =
                    Players.put pid uPlayer model.players
            in
            { model | players = uPlayers }

        Nothing ->
            model


updateDiscard : Int -> Model -> Model
updateDiscard num model =
    { model | discard = Card.exposed num }


updatePack : Int -> Model -> Model
updatePack num model =
    { model | pack = Card.hidden num }


updatePlayers : Players -> Model -> Model
updatePlayers players model =
    { model | players = players }


updateState : State -> Model -> Model
updateState state model =
    { model | state = state }
