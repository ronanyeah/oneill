module Main exposing (main)

import Color exposing (Color, black, rgb, white)
import Element exposing (circle, column, el, empty, image, link, newTab, row, text, viewport)
import Element.Attributes exposing (center, class, maxWidth, px, spacing, spacingXY, vary, verticalCenter)
import Element.Events exposing (onClick)
import Html exposing (Html)
import Style exposing (Property, StyleSheet, cursor, importUrl, style, styleSheet, variation)
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
    | Selected


blue : Color
blue =
    rgb 16 46 80


type Msg
    = Resize Window.Size
    | SetTab Tab


type Tab
    = Contact
    | Hours


montserrat : Property class variation
montserrat =
    Font.typeface
        [ Font.font "Montserrat"
        , Font.sansSerif
        ]


osc : Property class variation
osc =
    Font.typeface
        [ Font.font "Open Sans Condensed"
        , Font.sansSerif
        ]


styling : StyleSheet Styles Variations
styling =
    styleSheet
        [ importUrl "https://fonts.googleapis.com/css?family=Montserrat|Open+Sans+Condensed:300"
        , importUrl "/font-awesome/css/font-awesome.min.css"
        , importUrl "/style.css"
        , style None []
        , style Name
            [ Border.top 2
            , Border.bottom 2
            , Color.text white
            , Color.border white
            , Font.size 40
            , montserrat
            ]
        , style Social
            [ background white
            , Font.size 20
            , variation Fb [ background <| rgb 122 213 220 ]
            , variation Tw [ background <| rgb 255 204 83 ]
            , variation Insta [ background <| rgb 255 120 126 ]
            ]
        , style Address
            [ osc, Color.text white, Font.size 25 ]
        , style Day
            [ osc, Color.text white, Font.size 25 ]
        , style Icon
            [ background blue
            , cursor "pointer"
            , Border.solid
            , Border.all 1
            , Color.border white
            , Color.text white
            , Font.size 30
            , variation Selected [ background white, Color.text black ]
            ]
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
                [ spacing 20 ]
                [ el Name [ center ] <| text "O'NEILL COFFEE"
                , row None
                    [ spacing 30, center ]
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
            el None [ center ] <|
                row None
                    [ spacing 20 ]
                    [ circle 30 Icon [ onClick <| SetTab Contact, vary Selected <| tab == Contact ] <|
                        el None [ class "fa fa-info", center, verticalCenter ] empty
                    , circle 30 Icon [ onClick <| SetTab Hours, vary Selected <| tab == Hours ] <|
                        el None [ class "fa fa-clock-o", center, verticalCenter ] empty
                    ]

        content =
            case tab of
                Contact ->
                    el None [ center ] <|
                        column None
                            [ spacing 20 ]
                            [ row None
                                [ verticalCenter, spacing 10 ]
                                [ circle 20 Social [ vary Fb True ] <|
                                    el None [ class "fa fa-map-marker", center, verticalCenter ] empty
                                , newTab "https://www.google.com/maps/search/?api=1&query=51.548634,-9.267783&query_place_id=ChIJjzfi5b-lRUgRMa-Dov_hHrA" <|
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
                    el None
                        [ center ]
                    <|
                        column None
                            [ center, spacing 20 ]
                            [ el Day [] <| text "M 8:30 AM - 5:00 PM"
                            , el Day [] <| text "T 8:30 AM - 5:00 PM"
                            , el Day [] <| text "W 8:30 AM - 5:00 PM"
                            , el Day [] <| text "T 8:30 AM - 5:00 PM"
                            , el Day [] <| text "F 8:30 AM - 5:00 PM"
                            , el Day [] <| text "S 9:00 AM - 5:00 PM"
                            , el Day [] <| text "S Closed"
                            ]

        layout =
            if device.phone then
                column
            else
                row
    in
    viewport styling <|
        column None
            [ spacingXY 0 40 ]
            [ layout None
                [ verticalCenter, center ]
                [ image None
                    [ maxWidth <| px size ]
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
