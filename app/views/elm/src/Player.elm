module Player exposing
    ( Player
    , Position(..)
    , State(..)
    , badge
    , cardMsg
    , update
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
    , state : State
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
    | Revealing
    | Picking


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


cardMsg : Player -> Int -> Card -> Msg
cardMsg player cid card =
    case player.state of
        Revealing ->
            if card.vis then
                Noop

            else
                Reveal player.pid cid

        _ ->
            Noop


update : State -> Player -> Player
update state player =
    case player.state of
        Passive ->
            player

        _ ->
            { player | state = state }
