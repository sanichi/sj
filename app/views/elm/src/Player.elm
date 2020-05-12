module Player exposing
    ( Player
    , Position(..)
    , State(..)
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
    , score : Int
    }


type Position
    = S
    | N
    | NW
    | NE
    | E
    | W


type State
    = Passive
    | Starting


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
    player.handle ++ " " ++ total ++ "|" ++ current


msg : Player -> Int -> Card -> Msg
msg player cid card =
    case state player of
        Passive ->
            Noop

        Starting ->
            if card.vis then
                Noop

            else
                Reveal player.pid cid



-- Private


state : Player -> State
state player =
    if player.position == S then
        if Hand.hidden player.hand > 10 then
            Starting

        else
            Passive

    else
        Passive
