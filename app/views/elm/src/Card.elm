module Card exposing
    ( Card
    , exposed
    , hidden
    , poof
    , score
    )


type alias Card =
    { num : Int
    , exposed : Bool
    , exists : Bool
    }


exposed : Int -> Card
exposed num =
    Card num True True


hidden : Int -> Card
hidden num =
    Card num False True


poof : Card -> Card
poof card =
    { card | exists = False }


score : Card -> Int
score card =
    if card.exists && card.exposed then
        card.num

    else
        0
