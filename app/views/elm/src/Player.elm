module Player exposing
    ( Player
    , Position(..)
    , badge
    , debug
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
