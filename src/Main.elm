module Main exposing (main)

import Color exposing (Color, rgb, white)
import Element exposing (circle, column, el, empty, image, link, newTab, row, text, viewport)
import Element.Attributes exposing (center, class, fill, height, maxWidth, px, spacing, spread, vary, verticalCenter, width)
import Element.Events exposing (onClick)
import Html exposing (Html)
import Style exposing (StyleSheet, cursor, importUrl, style, styleSheet, variation)
import Style.Border as Border
import Style.Color as Color exposing (background)
import Style.Font as Font
import Task
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = ( emptyModel, Task.perform Resize Window.size )
        , subscriptions = \_ -> Window.resizes Resize
        , update = update
        , view = view
        }


type alias Model =
    { device : Element.Device
    , tab : Tab
    }


type Styles
    = None
    | Name
    | Icon
    | Social
    | Address
    | Day


type Variations
    = Fb
    | Tw
    | Insta


blue : Color
blue =
    rgb 16 46 80


type Msg
    = Resize Window.Size
    | SetTab Tab


type Tab
    = Contact
    | Hours


styling : StyleSheet Styles Variations
styling =
    styleSheet
        [ importUrl "/font-awesome/css/font-awesome.min.css"
        , importUrl "/style.css"
        , style None []
        , style Name
            [ Border.top 2
            , Border.bottom 2
            , Color.text white
            , Color.border white
            , Font.size 40
            ]
        , style Social
            [ background white
            , variation Fb [ background <| rgb 122 213 220 ]
            , variation Tw [ background <| rgb 255 204 83 ]
            , variation Insta [ background <| rgb 255 120 126 ]
            ]
        , style Address
            [ Color.text white ]
        , style Day
            [ Color.text white ]
        , style Icon
            [ background white, cursor "pointer" ]
        ]


view : Model -> Html Msg
view { device, tab } =
    let
        size =
            if device.portrait then
                toFloat device.width / 3
            else
                toFloat device.height / 3

        col =
            column None
                [ spacing 10 ]
                [ el Name [ center ] <| text "O'NEILL COFFEE"
                , newTab "https://goo.gl/maps/tXCDmxYtMiv" <|
                    el Address [ center ] <|
                        text "64 TOWNSHEND STREET SKIBBEREEN"
                , row None
                    [ spread ]
                    [ newTab "https://www.facebook.com/ONeill-Coffee-710833155767900/" <|
                        circle 20 Social [ vary Fb True ] <|
                            el None [ class "fa fa-facebook", center, verticalCenter ] empty
                    , newTab "https://twitter.com/oneillcoffee" <|
                        circle 20 Social [ vary Tw True ] <|
                            el None [ class "fa fa-twitter", center, verticalCenter ] empty
                    , newTab "https://www.instagram.com/oneillcoffee/" <|
                        circle 20 Social [ vary Insta True ] <|
                            el None [ class "fa fa-instagram", center, verticalCenter ] empty
                    ]
                ]

        icons =
            row None
                [ center, spacing 20 ]
                [ circle 30 Icon [ onClick <| SetTab Contact ] <|
                    el None [ class "fa fa-info", center, verticalCenter ] empty
                , circle 30 Icon [ onClick <| SetTab Hours ] <|
                    el None [ class "fa fa-clock-o", center, verticalCenter ] empty
                ]

        content =
            case tab of
                Contact ->
                    column None
                        [ center, spacing 20 ]
                        [ row None
                            [ verticalCenter, spacing 10 ]
                            [ circle 20 Social [ vary Fb True ] <|
                                el None [ class "fa fa-map-marker", center, verticalCenter ] empty
                            , newTab "https://goo.gl/maps/tXCDmxYtMiv" <|
                                el Address [ center ] <|
                                    text "64 TOWNSHEND STREET SKIBBEREEN"
                            ]
                        , row None
                            [ verticalCenter, spacing 10 ]
                            [ circle 20 Social [ vary Tw True ] <|
                                el None [ class "fa fa-phone", center, verticalCenter ] empty
                            , link "tel:+353863334562" <|
                                el Address [ center ] <|
                                    text "086 333 4562"
                            ]
                        , row None
                            [ verticalCenter, spacing 10 ]
                            [ circle 20 Social [ vary Insta True ] <|
                                el None [ class "fa fa-envelope", center, verticalCenter ] empty
                            , link "mailto:oneillscoffee@gmail.com" <|
                                el Address [ center ] <|
                                    text "oneillscoffee@gmail.com"
                            ]
                        ]

                Hours ->
                    column None
                        [ center ]
                        [ el Day [] <| text "M 8:30 AM — 5:00 PM"
                        , el Day [] <| text "T 8:30 AM — 5:00 PM"
                        , el Day [] <| text "W 8:30 AM — 5:00 PM"
                        , el Day [] <| text "T 8:30 AM — 5:00 PM"
                        , el Day [] <| text "F 8:30 AM — 5:00 PM"
                        , el Day [] <| text "S 9:00 AM — 5:00 PM"
                        , el Day [] <| text "S Closed"
                        ]
    in
    viewport styling <|
        el None [ height fill, width fill, verticalCenter ] <|
            column None
                [ spacing 30 ]
                [ row None
                    [ verticalCenter, center ]
                    [ image None
                        [ center, verticalCenter, maxWidth <| px size ]
                        { src = "/pic.jpg"
                        , caption = "O'Neill Coffee"
                        }
                    , col
                    ]
                , icons
                , content
                ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | device = Element.classifyDevice size }, Cmd.none )

        SetTab tab ->
            ( { model
                | tab = tab
              }
            , Cmd.none
            )


emptyModel : Model
emptyModel =
    { device = Element.classifyDevice { width = 0, height = 0 }
    , tab = Contact
    }
