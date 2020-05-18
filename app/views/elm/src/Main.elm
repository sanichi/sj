module Main exposing (main)

import Browser
import Html exposing (Html)
import Json.Decode exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Platform.Sub
import Ports
import Update exposing (Update)
import View


main : Program Value Model Msg
main =
    Browser.element
        { init = \flags -> ( Model.init flags, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> Html Msg
view model =
    View.view model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUpdate u ->
            ( Model.newUpdate u model, Cmd.none )

        RevealCard cid ->
            ( Model.revealCard model.pid cid model, push msg )

        ChooseDiscard ->
            ( Model.chooseDiscard model.pid model, push msg )

        ChooseDiscardCard cid ->
            ( Model.chooseDiscardCard model.pid cid model, push msg )

        ChoosePack ->
            ( Model.choosePack model.pid model, push msg )

        ChoosePackCard cid ->
            ( Model.choosePackCard model.pid cid model, push msg )

        ChoosePackDiscard ->
            ( Model.choosePackDiscard model.pid model, push msg )

        ChoosePackDiscardCard cid ->
            ( Model.choosePackDiscardCard model.pid cid model, push msg )

        NextHand score ->
            ( model, push msg )

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.pullUpdate (NewUpdate << Update.decode)


push : Msg -> Cmd Msg
push msg =
    Msg.value msg |> Ports.pushUpdates
