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
    { player_id : Int
    , pack : Card
    , discard : Card
    , players : Players
    , state : State
    }


type State
    = Reveal
    | Choose
    | ChosenPack
    | ChosenPackDiscard
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
    , state = Reveal
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

        _ ->
            model


chooseDiscard : Int -> Model -> Model
chooseDiscard pid model =
    if pid == model.player_id then
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
                players =
                    Players.updateDiscardCard cid model.discard player model.players
            in
            model
                |> updatePlayers players
                |> updateDiscard card.num
                |> updateState Choose

        _ ->
            model


choosePack : Int -> Model -> Model
choosePack pid model =
    let
        state =
            if pid == model.player_id then
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
                players =
                    Players.updatePackCard cid model.pack player model.players
            in
            model
                |> hidePack
                |> updatePlayers players
                |> updateDiscard card.num
                |> updateState Choose

        _ ->
            model


choosePackDiscard : Int -> Model -> Model
choosePackDiscard pid model =
    if pid == model.player_id then
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
                players =
                    Players.updatePackDiscardCard cid card player model.players
            in
            if pid == model.player_id then
                model
                    |> updatePlayers players
                    |> updateState Choose

            else
                model
                    |> hidePack
                    |> updatePlayers players
                    |> updateDiscard model.pack.num

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
                        Reveal
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

        plrs =
            List.map Player.debug <| Players.toList model.players

        pck =
            String.fromInt model.pack.num

        mdl =
            String.join " " [ pid, pck, state ]
    in
    String.join " | " (mdl :: plrs)



-- Private


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
            { model | players = Players.put pid { p | hand = hand } model.players }

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
