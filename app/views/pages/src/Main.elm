module Main exposing (main)

-- local modules

import Browser
import Html exposing (Html)
import Messages exposing (Msg(..))
import Model exposing (Model)
import Platform.Sub
import Ports
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Update
import Util



-- main program


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( Model.init, Cmd.none )
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
    let
        back =
            rect [ class "background", Util.viewWidth, Util.viewHeight ] []

        pack =
            image [ Util.packX, Util.packY, Util.cardWidth, Util.cardHeight, Util.back ] []

        disc =
            image [ Util.discX, Util.discY, Util.cardWidth, Util.cardHeight, Util.image model.disc ] []
    in
    svg [ id "card-table", version "1.1", Util.viewBox ] [ back, pack, disc ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        NewUpdate u ->
            ( Model.update m u, Cmd.none )
