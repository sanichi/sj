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
    , endGame
    , init
    , mainPlayer
    , newHand
    , newUpdate
    , revealCard
    , totalForMain
    , totalsForAll
    )

import Card exposing (Card)
import Hand exposing (Hand)
import Json.Decode exposing (Value)
import Msg exposing (Msg(..))
import Player exposing (Player)
import Players exposing (Players)
import Setup exposing (Options)
import Update exposing (Update)


type alias Model =
    { pid : Int
    , pack : Card
    , discard : Card
    , players : Players
    , state : State
    , upto : Int
    , options : Options
    }


type State
    = Reveal2
    | Choose
    | ChosenDiscard
    | ChosenPack
    | ChosenPackDiscard
    | RevealRest Int
    | HandOver
    | Waiting
    | GameOver


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
    , state = Reveal2
    , upto = setup.upto
    , options = setup.options
    }


mainPlayer : Model -> Maybe Player
mainPlayer model =
    Players.get model.pid model.players


totalForMain : Model -> Int
totalForMain model =
    Players.totalScore model.pid model.players


totalsForAll : Model -> List Int
totalsForAll model =
    Players.totalScores model.players


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

        "end_game" ->
            case val of
                [ pid ] ->
                    endGame pid model

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

                discard =
                    Maybe.withDefault card.num num
            in
            model
                |> updatePlayers players
                |> updateDiscard discard
                |> checkOver

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

                discard =
                    Maybe.withDefault card.num num
            in
            model
                |> hidePack
                |> updatePlayers players
                |> updateDiscard discard
                |> checkOver

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
                    |> checkOver

            else
                model
                    |> hidePack
                    |> updatePlayers players
                    |> updateDiscard (Maybe.withDefault model.pack.num num)
                    |> checkOver

        _ ->
            model


newHand : Int -> Int -> Model -> Model
newHand pid score model =
    if pid == model.pid then
        updateState Waiting model

    else
        model


endGame : Int -> Model -> Model
endGame pid model =
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
                    { p | score = score, turn = True, penalty = 1 }

                uPlayers =
                    Players.put pid uPlayer model.players
            in
            { model | players = uPlayers, state = Reveal2 }

        Nothing ->
            model


debug : Model -> String
debug model =
    let
        pid =
            String.fromInt model.pid

        state =
            case model.state of
                Reveal2 ->
                    "Reveal2"

                Choose ->
                    "Choose"

                ChosenDiscard ->
                    "ChosenDiscard"

                ChosenPack ->
                    "ChosenPack"

                ChosenPackDiscard ->
                    "ChosenPackDiscard"

                RevealRest outPid ->
                    "RevealRest " ++ String.fromInt outPid

                HandOver ->
                    "HandOver"

                Waiting ->
                    "Waiting"

                GameOver ->
                    "GameOver"

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
            case model.state of
                Reveal2 ->
                    reveal2Card cid card player model

                RevealRest outPid ->
                    revealRestCard outPid cid card player model

                _ ->
                    model

        _ ->
            model



-- Private


checkOver : Model -> Model
checkOver model =
    let
        toMove =
            Players.toMove model.players

        ( state, outPid ) =
            case toMove of
                Just player ->
                    if Hand.out player.hand then
                        if Players.allOut model.players then
                            ( HandOver, player.pid )

                        else
                            ( RevealRest player.pid, 0 )

                    else
                        ( Choose, 0 )

                Nothing ->
                    ( HandOver, 0 )

        players =
            case state of
                HandOver ->
                    Players.updatePenalty outPid model.players
                        |> Players.updateRevealRestTurns

                RevealRest pid ->
                    Players.updateRevealRestTurns model.players

                _ ->
                    model.players

        gameOver =
            if state == HandOver then
                Players.uptoExceeded model.upto players

            else
                False

        finalState =
            if gameOver then
                GameOver

            else
                state
    in
    { model | state = finalState, players = players }


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


reveal2Card : Int -> Card -> Player -> Model -> Model
reveal2Card cid card player model =
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
                Reveal2
    in
    model
        |> updatePlayers players
        |> updateState state


revealRestCard : Int -> Int -> Card -> Player -> Model -> Model
revealRestCard outPid cid card player model =
    let
        ( pPlayers, num ) =
            Players.replaceAndCheckPoof cid card player model.players

        tPlayers =
            Players.updateRevealRestTurns pPlayers

        state =
            if Players.allOut tPlayers then
                HandOver

            else
                RevealRest outPid

        uPlayers =
            case state of
                HandOver ->
                    Players.updatePenalty outPid tPlayers

                _ ->
                    tPlayers

        gameOver =
            if state == HandOver then
                Players.uptoExceeded model.upto uPlayers

            else
                False

        uState =
            if gameOver then
                GameOver

            else
                state

        discard =
            Maybe.withDefault model.discard.num num
    in
    model
        |> updatePlayers uPlayers
        |> updateDiscard discard
        |> updateState uState


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
