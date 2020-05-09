module Main exposing (main)

-- local modules

import Browser
import Html exposing (Html)
import Json.Decode exposing (Value)
import Model exposing (Model)
import Platform.Sub
import Ports
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Update exposing (Update)
import Util



-- main program


main : Program Value Model Msg
main =
    Browser.element
        { init = \flags -> ( Model.init flags, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.updates (NewUpdate << Update.decode)



-- view


view : Model -> Html Msg
view model =
    [ Util.bg, Util.pack model, Util.disc model ]
        ++ Util.hands model
        |> svg [ id "card-table", version "1.1", Util.box ]



-- update


type Msg
    = NewUpdate Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        NewUpdate u ->
            ( Model.update m u, Cmd.none )
