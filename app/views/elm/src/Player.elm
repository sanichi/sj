module Player exposing
    ( Player
    , Position(..)
    , badge
    , msg
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


msg : Player -> Int -> Card -> Msg
msg player cid card =
    if player.active then
        if not card.vis && (Hand.hidden player.hand > 10) then
            Reveal player.pid cid

        else
            Noop

    else
        Noop
