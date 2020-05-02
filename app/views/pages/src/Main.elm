module Main exposing (main)

-- local modules

import Browser
import Config
import Html exposing (Html)
import Platform.Sub
import Svg exposing (..)
import Svg.Attributes exposing (..)


type Msg
    = NoOp


type alias Model =
    Int


type alias Flags =
    { focus : Int
    }


initModel : Flags -> Int
initModel flags =
    1



-- main program


main : Program Flags Model Msg
main =
    Browser.element
        { init = \flags -> ( initModel flags, initTasks )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


initTasks : Cmd Msg
initTasks =
    Cmd.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- view


view : Model -> Html Msg
view model =
    let
        background =
            rect [ class "background", width (String.fromInt Config.width), height (String.fromInt Config.height) ] []

        pack =
            image [ x "450", y "450", width "100", height "100", xlinkHref "/images/back.jpg" ] []
    in
    svg [ id "card-table", version "1.1", viewBox Config.viewBox ] [ background, pack ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
