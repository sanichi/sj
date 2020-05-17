module Player exposing
    ( Player
    , Position(..)
    , badge
    , debug
    , replace
    , replaceAndCheck
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
                "T"

            else
                "W"
    in
    String.join " " [ pid, pos, trn ]


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
