module Main exposing (main)

-- local modules

import Browser
import Html exposing (Html)
import Json.Decode exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Platform.Sub
import Ports
import Svg
import Svg.Attributes as Atr
import Update exposing (Update)
import View



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
    [ View.bg, View.pack model, View.discard model ]
        ++ View.hands model
        |> Svg.svg [ Atr.id "card-table", Atr.version "1.1", View.box ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        NewUpdate u ->
            ( Model.update m u, Cmd.none )

        Reveal pid cid ->
            ( Model.reveal m pid cid, Cmd.none )

        Noop ->
            ( m, Cmd.none )
