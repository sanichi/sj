module Players exposing
    ( Players
    , all
    , get
    , init
    , put
    , updateReveal
    )

import Card exposing (Card)
import Dict exposing (Dict)
import Hand exposing (Hand)
import Player exposing (Player, Position(..), State(..))
import Setup exposing (ProtoPlayer)


type alias Players =
    Dict Int Player


all : Players -> List Player
all players =
    Dict.values players


get : Int -> Players -> Maybe Player
get pid players =
    Dict.get pid players


init : Int -> List ProtoPlayer -> Players
init pid list =
    build pid list Dict.empty


put : Int -> Player -> Players -> Players
put pid player players =
    Dict.insert pid player players


updateReveal : Int -> Card -> Player -> Players -> Players
updateReveal cid card player players =
    let
        uCard =
            Card.exposed card.num

        uHand =
            Hand.set cid uCard player.hand

        uPlayer =
            { player | hand = uHand }

        uPlayers =
            put player.pid uPlayer players
    in
    updateRevealTurns uPlayers



-- Private


build : Int -> List ProtoPlayer -> Players -> Players
build pid list players =
    case list of
        [] ->
            players

        proto :: rest ->
            let
                nPlayer =
                    convert pid proto

                uPlayers =
                    put proto.pid nPlayer players
            in
            build pid rest uPlayers


convert : Int -> ProtoPlayer -> Player
convert pid proto =
    let
        position =
            decode proto.position

        hand =
            Hand.init <| List.repeat 12 0

        state =
            if proto.pid == pid then
                Revealing

            else
                Passive
    in
    Player proto.pid proto.handle position hand True state 0


decode : String -> Position
decode position =
    case position of
        "S" ->
            S

        "N" ->
            N

        "E" ->
            E

        "W" ->
            W

        "NE" ->
            NE

        "NW" ->
            NW

        _ ->
            S


updateRevealTurns : Players -> Players
updateRevealTurns players =
    let
        uPlayers =
            Dict.map updateRevealTurn players

        stillOn =
            List.filter .turn <| Dict.values uPlayers
    in
    if List.isEmpty stillOn then
        updateRevealWho uPlayers

    else
        uPlayers


updateRevealTurn : Int -> Player -> Player
updateRevealTurn pid player =
    if Hand.exposed player.hand >= 2 then
        Player.update ReadyForTurn { player | turn = False }

    else
        player


updateRevealWho : Players -> Players
updateRevealWho players =
    let
        mapper =
            \p -> ( Hand.score p.hand, Hand.highest p.hand, p.pid )

        sorted =
            Dict.values players
                |> List.map mapper
                |> List.sort
                |> List.reverse

        playerToMove =
            case List.head sorted of
                Just ( score, highest, pid ) ->
                    get pid players

                Nothing ->
                    Nothing
    in
    case playerToMove of
        Just player ->
            put player.pid { player | turn = True } players

        Nothing ->
            players
