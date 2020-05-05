module Main exposing (main)

-- local modules

import Browser
import Html exposing (Html)
import Model
import Platform.Sub
import Ports
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)
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
    [ Util.bg, Util.pack, Util.disc model.disc ]
        ++ Util.hands model.cards
        |> svg [ id "card-table", version "1.1", Util.box ]



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        NewUpdate u ->
            ( Model.update m u, Cmd.none )
