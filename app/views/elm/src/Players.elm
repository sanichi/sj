module Players exposing
    ( Players
    , all
    , allOut
    , get
    , init
    , put
    , replaceAndCheckPoof
    , size
    , toList
    , toMove
    , totalScore
    , totalScores
    , updateCard
    , updatePenalty
    , updateReveal
    , updateRevealRestTurns
    , uptoExceeded
    )

import Card exposing (Card)
import Dict exposing (Dict)
import Hand exposing (Hand)
import Player exposing (Player, Position(..))
import Setup exposing (ProtoPlayer)


type alias Players =
    Dict Int Player


all : Players -> List Player
all players =
    Dict.values players


allOut : Players -> Bool
allOut players =
    all players
        |> List.map .hand
        |> List.map Hand.out
        |> List.foldl (&&) True


get : Int -> Players -> Maybe Player
get pid players =
    Dict.get pid players


init : Int -> Bool -> List ProtoPlayer -> Players
init pid four list =
    build pid four list Dict.empty


replaceAndCheckPoof : Int -> Card -> Player -> Players -> ( Players, Maybe Int )
replaceAndCheckPoof cid card player players =
    let
        ( uPlayer, discard ) =
            Player.replaceAndCheckPoof cid card player

        uPlayers =
            put player.pid uPlayer players
    in
    ( uPlayers, discard )


size : Players -> Int
size players =
    Dict.size players


totalScore : Int -> Players -> Int
totalScore pid players =
    let
        p =
            get pid players
    in
    case p of
        Just player ->
            Player.totalScore player

        Nothing ->
            0


totalScores : Players -> List Int
totalScores players =
    players
        |> all
        |> List.map (\p -> [ p.pid, Player.totalScore p ])
        |> List.concat


toList : Players -> List Player
toList players =
    Dict.values players


toMove : Players -> Maybe Player
toMove players =
    let
        onMove =
            List.filter .turn (all players)
    in
    case onMove of
        [ player ] ->
            Just player

        _ ->
            Nothing


put : Int -> Player -> Players -> Players
put pid player players =
    Dict.insert pid player players


updateCard : Int -> Card -> Player -> Players -> ( Players, Maybe Int )
updateCard cid card player players =
    let
        ( uPlayers, discard ) =
            replaceAndCheckPoof cid card player players

        next =
            updateNextTurn player.position (size uPlayers)
    in
    ( Dict.map next uPlayers, discard )


updatePenalty : Int -> Players -> Players
updatePenalty outPid players =
    let
        totals =
            all players |> List.map (\p -> Hand.score p.hand)

        lowest =
            List.minimum totals |> Maybe.withDefault 1000

        duplicates =
            List.filter (\t -> t == lowest) totals |> List.length

        penaliser pid player =
            if player.pid == outPid && (Hand.score player.hand > lowest || duplicates > 1) then
                { player | penalty = 2 }

            else
                player
    in
    Dict.map penaliser players


updateReveal : Int -> Card -> Player -> Players -> Players
updateReveal cid card player players =
    players
        |> replaceCard cid card player
        |> updateRevealTurns


updateRevealRestTurns : Players -> Players
updateRevealRestTurns players =
    let
        mover index player =
            if Hand.out player.hand then
                { player | turn = False }

            else
                { player | turn = True }
    in
    Dict.map mover players


uptoExceeded : Int -> Players -> Bool
uptoExceeded upto players =
    let
        highest =
            players
                |> toList
                |> List.map Player.totalScore
                |> List.maximum
                |> Maybe.withDefault 0
    in
    highest >= upto



-- Private


build : Int -> Bool -> List ProtoPlayer -> Players -> Players
build pid four list players =
    case list of
        [] ->
            players

        proto :: rest ->
            let
                nPlayer =
                    convert pid four proto

                uPlayers =
                    put proto.pid nPlayer players
            in
            build pid four rest uPlayers


convert : Int -> Bool -> ProtoPlayer -> Player
convert pid four proto =
    let
        position =
            decode proto.position

        hand =
            Hand.init <| List.repeat 12 0

        active =
            if proto.pid == pid then
                True

            else
                False
    in
    Player proto.pid proto.handle position hand True 1 active 0 four


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


replaceCard : Int -> Card -> Player -> Players -> Players
replaceCard cid card player players =
    let
        uPlayer =
            Player.replace cid card player
    in
    put player.pid uPlayer players


updateNextTurn : Position -> Int -> Int -> Player -> Player
updateNextTurn position number pid player =
    if player.position == position then
        { player | turn = False }

    else
        let
            turn =
                case number of
                    4 ->
                        case ( position, player.position ) of
                            ( S, W ) ->
                                True

                            ( W, N ) ->
                                True

                            ( N, E ) ->
                                True

                            ( E, S ) ->
                                True

                            _ ->
                                False

                    3 ->
                        case ( position, player.position ) of
                            ( S, NW ) ->
                                True

                            ( NW, NE ) ->
                                True

                            ( NE, S ) ->
                                True

                            _ ->
                                False

                    _ ->
                        True
        in
        { player | turn = turn }


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
    if Hand.exposed player.hand == 2 then
        { player | turn = False }

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
