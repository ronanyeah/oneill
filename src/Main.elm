module Main exposing (main)

import Animation
import Color exposing (Color, black, rgb, white)
import Element exposing (circle, column, el, empty, image, link, newTab, row, text, viewport)
import Element.Attributes exposing (center, class, maxWidth, px, spacing, spacingXY, vary, verticalCenter)
import Element.Events exposing (onClick)
import Html exposing (Html)
import Style exposing (Property, StyleSheet, cursor, importUrl, style, styleSheet, variation)
import Style.Border as Border
import Style.Color as Color exposing (background)
import Style.Font as Font
import Style.Transition as Transition
import Task
import Time exposing (second)
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- TYPES


type alias Model =
    { device : Element.Device
    , tab : Tab
    , anim : Animation.State
    }


type Msg
    = Resize Window.Size
    | SetTab Tab
    | Animate Animation.Msg


type Tab
    = Contact
    | Hours


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
    | Small



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { device = Element.classifyDevice { width = 0, height = 0 }
      , tab = Contact
      , anim =
            Animation.style [ Animation.opacity 0 ]
                |> Animation.interrupt
                    [ Animation.toWith
                        (Animation.easing
                            { duration = 2 * second
                            , ease = identity
                            }
                        )
                        [ Animation.opacity 1 ]
                    ]
      }
    , Task.perform Resize Window.size
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions { anim } =
    Sub.batch
        [ Window.resizes Resize
        , Animation.subscription Animate [ anim ]
        ]



-- STYLING


blue : Color
blue =
    rgb 16 46 80


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
            , variation Small [ Font.size 20 ]
            ]
        , style Social
            [ background white
            , Font.size 20
            , variation Fb [ background <| rgb 122 213 220 ]
            , variation Tw [ background <| rgb 255 204 83 ]
            , variation Insta [ background <| rgb 255 120 126 ]
            ]
        , style Address
            [ osc
            , Color.text white
            , Font.size 25
            , variation Small [ Font.size 20 ]
            ]
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
            , Transition.all
            ]
        ]



-- VIEW


view : Model -> Html Msg
view { device, tab, anim } =
    let
        thin =
            device.width < 375

        size =
            if device.portrait then
                toFloat device.width / 3
            else
                toFloat device.height / 3

        col =
            column None
                [ spacing 20 ]
                [ el Name [ center, vary Small thin ] <| text "O'NEILL COFFEE"
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

        logoLayout =
            if thin then
                column
            else
                row

        content =
            case tab of
                Contact ->
                    el None [ center ] <|
                        column None
                            [ spacing 20 ]
                            [ logoLayout None
                                [ verticalCenter, spacing 10, center ]
                                [ circle 20 Social [ vary Fb True ] <|
                                    el None [ class "fa fa-map-marker", center, verticalCenter ] empty
                                , newTab "https://www.google.com/maps/search/?api=1&query=51.548638,-9.267786&query_place_id=ChIJjzfi5b-lRUgRMa-Dov_hHrA" <|
                                    el Address [ center, vary Small thin ] <|
                                        text "64 TOWNSHEND STREET, SKIBBEREEN"
                                ]
                            , logoLayout None
                                [ verticalCenter, spacing 10, center ]
                                [ circle 20 Social [ vary Tw True ] <|
                                    el None [ class "fa fa-phone", center, verticalCenter ] empty
                                , link "tel:+353863334562" <|
                                    el Address [ center, vary Small thin ] <|
                                        text "086 333 4562"
                                ]
                            , logoLayout None
                                [ verticalCenter, spacing 10, center ]
                                [ circle 20 Social [ vary Insta True ] <|
                                    el None [ class "fa fa-envelope", center, verticalCenter ] empty
                                , link "mailto:oneillscoffee@gmail.com" <|
                                    el None [ center ] <|
                                        el Address [ center, vary Small thin ] <|
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

        fadeIn =
            (++)
                (Animation.render anim |> List.map Element.Attributes.toAttr)
    in
    viewport styling <|
        column None
            (fadeIn [ spacingXY 0 40 ])
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



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | device = Element.classifyDevice size }
            , Cmd.none
            )

        SetTab tab ->
            ( { model
                | tab = tab
              }
            , Cmd.none
            )

        Animate animMsg ->
            ( { model
                | anim = Animation.update animMsg model.anim
              }
            , Cmd.none
            )
