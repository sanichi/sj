module Card exposing
    ( Card
    , exposed
    , hidden
    , score
    )


type alias Card =
    { num : Int
    , exp : Bool
    }


exposed : Int -> Card
exposed num =
    Card num True


hidden : Int -> Card
hidden num =
    Card num False


score : Card -> Int
score card =
    if card.exp then
        card.num

    else
        0
