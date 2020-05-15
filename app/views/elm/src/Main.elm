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
update msg model =
    case msg of
        NewUpdate u ->
            ( Model.newUpdate u model, Cmd.none )

        RevealCard pid cid ->
            ( Model.revealCard pid cid model, push msg )

        ChooseDiscard ->
            ( Model.updateChooseDiscard model, push msg )

        ChooseDiscardCard pid cid ->
            ( Model.updateChooseDiscardCard pid cid model, push msg )

        ChoosePack ->
            ( Model.updateChoosePack model, push msg )

        ChoosePackCard pid cid ->
            ( Model.updateChoosePackCard pid cid model, push msg )

        ChoosePackDiscard ->
            ( Model.updateChoosePackDiscard model, push msg )

        ChoosePackDiscardCard pid cid ->
            ( Model.updateChoosePackDiscardCard pid cid model, push msg )

        Noop ->
            ( model, Cmd.none )



-- private


push : Msg -> Cmd Msg
push msg =
    Msg.value msg |> Ports.pushUpdates
