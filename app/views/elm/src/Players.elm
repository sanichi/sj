module Players exposing
    ( Players
    , all
    , get
    , init
    , put
    , size
    , toList
    , toMove
    , totalScore
    , totalScores
    , unveilAll
    , updateCard
    , updateReveal
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


get : Int -> Players -> Maybe Player
get pid players =
    Dict.get pid players


init : Int -> List ProtoPlayer -> Players
init pid list =
    build pid list Dict.empty


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


unveilAll : Players -> Players
unveilAll players =
    Dict.map Player.unveil players


updateCard : Int -> Card -> Player -> Players -> ( Players, Maybe Int )
updateCard cid card player players =
    let
        ( uPlayers, discard ) =
            replaceAndCheck cid card player players

        next =
            updateNextTurn player.position (size uPlayers)
    in
    ( Dict.map next uPlayers, discard )


updateReveal : Int -> Card -> Player -> Players -> Players
updateReveal cid card player players =
    players
        |> replace cid card player
        |> updateRevealTurns


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

        active =
            if proto.pid == pid then
                True

            else
                False
    in
    Player proto.pid proto.handle position hand True active 0


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


replace : Int -> Card -> Player -> Players -> Players
replace cid card player players =
    let
        uPlayer =
            Player.replace cid card player
    in
    put player.pid uPlayer players


replaceAndCheck : Int -> Card -> Player -> Players -> ( Players, Maybe Int )
replaceAndCheck cid card player players =
    let
        ( uPlayer, discard ) =
            Player.replaceAndCheck cid card player

        uPlayers =
            put player.pid uPlayer players
    in
    ( uPlayers, discard )


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
