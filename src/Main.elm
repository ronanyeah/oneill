module Main exposing (main)

import Color exposing (rgb)
import Element exposing (el, image, viewport)
import Element.Attributes exposing (center, fill, height, maxWidth, px, verticalCenter, width)
import Html exposing (Html)
import Style exposing (StyleSheet, style, styleSheet)
import Style.Color exposing (background)
import Task
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = ( emptyModel, Task.perform Resize Window.size )
        , subscriptions = always Sub.none
        , update = update
        , view = view
        }


type alias Model =
    { device : Element.Device
    }


type Styles
    = None
    | Background


type Msg
    = Resize Window.Size


styling : StyleSheet Styles vars
styling =
    styleSheet
        [ style None []
        , style Background [ background <| rgb 16 46 80 ]
        ]


view : Model -> Html Msg
view { device } =
    let
        size =
            if device.portrait then
                toFloat device.width / 2
            else
                toFloat device.height / 2
    in
    viewport styling <|
        el Background [ height fill, width fill ] <|
            image None
                [ center, verticalCenter, maxWidth <| px size ]
                { src = "https://user-images.githubusercontent.com/9598261/34369822-19a1b73e-eab7-11e7-9048-222db6302506.png"
                , caption = "O'Neill Coffee"
                }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | device = Element.classifyDevice size }, Cmd.none )


emptyModel : Model
emptyModel =
    { device = Element.classifyDevice { width = 0, height = 0 }
    }
