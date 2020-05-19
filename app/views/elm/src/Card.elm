module Card exposing
    ( Card
    , blank
    , exposed
    , hidden
    , score
    , unveil
    )


type alias Card =
    { num : Int
    , exposed : Bool
    , exists : Bool
    }


blank : Card
blank =
    Card 0 False False


exposed : Int -> Card
exposed num =
    Card num True True


hidden : Int -> Card
hidden num =
    Card num False True


score : Card -> Int
score card =
    if card.exists && card.exposed then
        card.num

    else
        0


unveil : Card -> Card
unveil card =
    if card.exists && not card.exposed then
        { card | exposed = True }

    else
        card
