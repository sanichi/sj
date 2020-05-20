module Player exposing
    ( Player
    , Position(..)
    , badge
    , debug
    , replace
    , replaceAndCheck
    , scoreText
    , totalScore
    , unveil
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


badge : Player -> String
badge player =
    let
        handle =
            player.handle

        total =
            String.fromInt player.score

        current =
            String.fromInt (Hand.score player.hand)
    in
    player.handle ++ " " ++ total ++ "•" ++ current


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


replaceAndCheck : Int -> Card -> Player -> ( Player, Maybe Int )
replaceAndCheck cid card player =
    let
        uCard =
            Card.exposed card.num

        uHand =
            Hand.set cid uCard player.hand

        uPlayer =
            { player | hand = uHand }

        ( cPlayer, discard ) =
            check uPlayer
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


unveil : Int -> Player -> Player
unveil pid player =
    { player | hand = Hand.unveil player.hand }



-- Private


check : Player -> ( Player, Maybe Int )
check player =
    let
        ( hand, discard ) =
            Hand.check player.hand

        cPlayer =
            { player | hand = hand }
    in
    ( cPlayer, discard )
