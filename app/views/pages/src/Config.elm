module Config exposing (height, viewBox, width)

import String


width : Int
width =
    1000


height : Int
height =
    1000


viewBox : String
viewBox =
    String.join " " [ "0 0", String.fromInt width, String.fromInt height ]
