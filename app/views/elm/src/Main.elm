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

        RevealCard pid cid ->
            ( Model.revealCard pid cid model, push msg )

        ChooseDiscard pid ->
            ( Model.chooseDiscard pid model, push msg )

        ChooseDiscardCard pid cid ->
            ( Model.chooseDiscardCard pid cid model, push msg )

        ChoosePack pid ->
            ( Model.choosePack pid model, push msg )

        ChoosePackCard pid cid ->
            ( Model.choosePackCard pid cid model, push msg )

        ChoosePackDiscard pid ->
            ( Model.choosePackDiscard pid model, push msg )

        ChoosePackDiscardCard pid cid ->
            ( Model.choosePackDiscardCard pid cid model, push msg )

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.pullUpdate (NewUpdate << Update.decode)


push : Msg -> Cmd Msg
push msg =
    Msg.value msg |> Ports.pushUpdates
