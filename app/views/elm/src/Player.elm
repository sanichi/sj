module Player exposing (Player, Players, Position(..), State(..), all, badge, get, init, msg, put)

import Card exposing (Card)
import Dict exposing (Dict)
import Hand exposing (Hand)
import Msg exposing (Msg(..))
import Setup exposing (ProtoPlayer)


type alias Player =
    { pid : Int
    , handle : String
    , position : Position
    , hand : Hand
    , score : Int
    }


type alias Players =
    Dict Int Player


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


all : Players -> List Player
all players =
    Dict.values players


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
    player.handle ++ " " ++ total ++ "/" ++ current


get : Int -> Players -> Maybe Player
get pid players =
    Dict.get pid players


init : List ProtoPlayer -> Players
init list =
    build list Dict.empty


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


put : Int -> Player -> Players -> Players
put pid player players =
    Dict.insert pid player players



-- Private


build : List ProtoPlayer -> Players -> Players
build list players =
    case list of
        [] ->
            players

        proto :: rest ->
            let
                nPlayer =
                    convert proto

                uPlayers =
                    put proto.pid nPlayer players
            in
            build rest uPlayers


convert : ProtoPlayer -> Player
convert proto =
    let
        position =
            decode proto.position

        hand =
            Hand.init <| List.repeat 12 0
    in
    Player proto.pid proto.handle position hand 0


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


state : Player -> State
state player =
    if player.position == S then
        if Hand.hidden player.hand > 10 then
            Starting

        else
            Passive

    else
        Passive
