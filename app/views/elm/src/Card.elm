module Card exposing (Card, exposed, hidden)


type alias Card =
    ( Int, Bool )


exposed : Int -> Card
exposed val =
    ( val, True )


hidden : Int -> Card
hidden val =
    ( val, False )
