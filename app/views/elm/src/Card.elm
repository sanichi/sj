module Card exposing (Card, exposed, hidden)


type alias Card =
    { num : Int
    , vis : Bool
    }


exposed : Int -> Card
exposed num =
    Card num False


hidden : Int -> Card
hidden num =
    Card num True
