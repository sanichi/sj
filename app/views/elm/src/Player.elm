module Player exposing
    ( Player
    , Position(..)
    , badge
    , debug
    , replace
    , replaceAndCheckPoof
    , scoreText
    , totalScore
    )

import Card exposing (Card)
import Hand exposing (Hand)
import Msg exposing (Msg(..))
import Setup exposing (ProtoPlayer)


type alias Player =
    { pid : Int
    , handle : String
    , position : Position
    , hand : Hand
    , turn : Bool
    , penalty : Int
    , active : Bool
    , score : Int
    }


type Position
    = S
    | N
    | NW
    | NE
    | E
    | W


badge : Bool -> Player -> String
badge showTotal player =
    let
        old_ =
            if player.score == 0 then
                ""

            else
                String.fromInt player.score ++ " + "

        score =
            Hand.score player.hand

        score_ =
            String.fromInt score

        total =
            player.penalty * score + player.score

        penalty =
            if player.penalty == 2 then
                " × 2 "

            else
                ""

        total_ =
            if total == score || not showTotal then
                ""

            else
                penalty ++ " = " ++ String.fromInt total
    in
    player.handle ++ " " ++ old_ ++ score_ ++ total_


debug : Player -> String
debug player =
    let
        pid =
            String.fromInt player.pid

        pos =
            case player.position of
                S ->
                    "S"

                N ->
                    "N"

                NW ->
                    "NW"

                NE ->
                    "NE"

                E ->
                    "E"

                W ->
                    "W"

        trn =
            if player.turn then
                "*"

            else
                ""
    in
    pid ++ trn ++ " " ++ pos


replace : Int -> Card -> Player -> Player
replace cid card player =
    let
        uCard =
            Card.exposed card.num

        uHand =
            Hand.set cid uCard player.hand
    in
    { player | hand = uHand }


replaceAndCheckPoof : Int -> Card -> Player -> ( Player, Maybe Int )
replaceAndCheckPoof cid card player =
    let
        uCard =
            Card.exposed card.num

        uHand =
            Hand.set cid uCard player.hand

        uPlayer =
            { player | hand = uHand }

        ( cPlayer, discard ) =
            checkPoof uPlayer
    in
    ( cPlayer, discard )


scoreText : Player -> String
scoreText player =
    let
        score =
            Hand.score player.hand

        total =
            player.penalty * score + player.score

        penalty =
            if player.penalty == 2 then
                " × 2 "

            else
                ""
    in
    player.handle
        ++ ": "
        ++ String.fromInt player.score
        ++ " + "
        ++ String.fromInt score
        ++ penalty
        ++ " = "
        ++ String.fromInt total


totalScore : Player -> Int
totalScore player =
    player.penalty * Hand.score player.hand + player.score



-- Private


checkPoof : Player -> ( Player, Maybe Int )
checkPoof player =
    let
        ( hand, discard ) =
            Hand.checkPoof player.hand

        cPlayer =
            { player | hand = hand }
    in
    ( cPlayer, discard )
