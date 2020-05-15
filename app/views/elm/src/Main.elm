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
    Ports.pullUpdate (NewUpdate << Update.decode)



-- view


view : Model -> Html Msg
view model =
    [ View.bg, View.pack model, View.discard model, View.debug model ]
        ++ View.hands model
        |> Svg.svg [ Atr.id "card-table", Atr.version "1.1", View.box ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        NewUpdate u ->
            ( Model.newUpdate m u, Cmd.none )

        RevealCard pid cid ->
            ( Model.revealCard m pid cid, push msg )

        ChoosePack ->
            ( Model.updateChoosePack m, push msg )

        ChoosePackCard pid cid ->
            ( Model.updateChoosePackCard m pid cid, push msg )

        ChooseDiscard ->
            ( Model.updateChooseDiscard m, push msg )

        Noop ->
            ( m, Cmd.none )



-- private


push : Msg -> Cmd Msg
push msg =
    Msg.value msg |> Ports.pushUpdates
