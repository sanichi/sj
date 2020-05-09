module Hand exposing (Hand, init)

import Card exposing (Card)


type alias Hand =
    List Card


init : Hand
init =
    Card.hidden 0 |> List.repeat 12
