port module Main exposing (main)

import Color exposing (Color, rgb)
import Element exposing (Attribute, Element, centerX, centerY, column, el, empty, height, html, image, layout, link, newTabLink, padding, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes as Attr
import Json.Decode as Decode exposing (Decoder, Value)
import Task
import Window exposing (Size)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


port hours : (Value -> msg) -> Sub msg



-- TYPES


type Device
    = Mobile
    | Desktop


type alias Model =
    { device : Device
    , size : Size
    , details : Maybe Details
    }


type Msg
    = Resize Size
    | Hours Value


type alias Details =
    { location : String
    , hours : List String
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { device = Desktop
      , size = { width = 0, height = 0 }
      , details = Nothing
      }
    , Task.perform Resize Window.size
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Window.resizes Resize
        , hours Hours
        ]



-- STYLING


blue : Color
blue =
    rgb 16 46 80


montserrat : Attribute msg
montserrat =
    Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Montserrat"
            , name = "Montserrat"
            }
        ]


osc : Attribute msg
osc =
    Font.family
        [ Font.external
            { url = "https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300"
            , name = "Open Sans Condensed"
            }
        ]



-- VIEW


view : Model -> Html Msg
view { device, size, details } =
    let
        thin =
            size.width < 425

        wall =
            if size.height > size.width then
                toFloat size.width / 3
            else
                toFloat size.height / 3

        iconStyle =
            [ Font.size 15
            , centerX
            , centerY
            ]

        addressStyle =
            [ osc
            , Font.color Color.white
            , Font.size 25
            , centerX
            ]

        header =
            el
                [ Border.widthXY 0 2
                , Font.color Color.white
                , Border.color Color.white
                , Font.size 40
                , centerX
                , montserrat
                ]
            <|
                text "O'NEILL COFFEE"

        socialLinks =
            el [ centerX ] <|
                row
                    [ spacing 30 ]
                    [ newTabLink []
                        { url = "https://www.facebook.com/ONeill-Coffee-710833155767900/"
                        , label =
                            circle 50 [ Background.color <| rgb 122 213 220 ] <|
                                fa iconStyle "fab fa-facebook-f"
                        }
                    , newTabLink []
                        { url = "https://twitter.com/oneillcoffee"
                        , label =
                            circle 50 [ Background.color <| rgb 255 204 83 ] <|
                                fa iconStyle "fab fa-twitter"
                        }
                    , newTabLink []
                        { url = "https://www.instagram.com/oneillcoffee/"
                        , label =
                            circle 50 [ Background.color <| rgb 255 120 126 ] <|
                                fa iconStyle "fab fa-instagram"
                        }
                    ]

        logoLayout =
            if thin then
                column
            else
                row

        info =
            el [ centerX ] <|
                column
                    [ spacing 20 ]
                    [ logoLayout
                        [ spacing 10 ]
                        [ circle 30 [ Background.color <| rgb 122 213 220 ] <|
                            fa iconStyle "fas fa-map-marker-alt"
                        , let
                            addr =
                                el addressStyle <|
                                    text "64 TOWNSHEND STREET, SKIBBEREEN"
                          in
                          case details of
                            Just { location } ->
                                newTabLink []
                                    { url = location
                                    , label = addr
                                    }

                            Nothing ->
                                addr
                        ]
                    , logoLayout
                        [ spacing 10 ]
                        [ circle 30 [ Background.color <| rgb 255 204 83 ] <|
                            fa iconStyle "fas fa-phone"
                        , link []
                            { url = "tel:+353863334562"
                            , label =
                                el addressStyle <|
                                    text "086 333 4562"
                            }
                        ]
                    , logoLayout
                        [ spacing 10 ]
                        [ circle 30 [ Background.color <| rgb 255 120 126 ] <|
                            fa iconStyle "fas fa-envelope"
                        , link []
                            { url = "mailto:oneillscoffee@gmail.com"
                            , label =
                                el addressStyle <|
                                    text "oneillscoffee@gmail.com"
                            }
                        ]
                    ]

        hours =
            details
                |> Maybe.map
                    (.hours
                        >> List.map
                            (String.toUpper
                                >> text
                                >> el
                                    [ osc
                                    , Font.color Color.white
                                    , Font.size 25
                                    , centerX
                                    ]
                            )
                        >> column [ spacing 20 ]
                        >> el [ centerX ]
                    )
                |> Maybe.withDefault empty

        top =
            (case device of
                Mobile ->
                    column

                Desktop ->
                    row
            )
                [ centerY, centerX ]
                [ image
                    [ width <| px <| round wall
                    , centerX
                    ]
                    { src = "/pic.jpg"
                    , description = "O'Neill Coffee"
                    }
                , el [ centerY ] <|
                    column
                        [ spacing 20 ]
                        [ header
                        , socialLinks
                        ]
                ]
    in
    layout [ Background.color blue, padding 20 ] <|
        el [ centerX ] <|
            column
                [ spacing 50, centerX ]
                [ top
                , info
                , hours
                ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model
                | device =
                    if size.width < 600 then
                        Mobile
                    else
                        Desktop
                , size = size
              }
            , Cmd.none
            )

        Hours val ->
            ( val
                |> Decode.decodeValue decodeDetails
                |> Result.toMaybe
                |> (\result ->
                        { model | details = result }
                   )
            , Cmd.none
            )



-- SUPPORT


circle : Int -> List (Attribute msg) -> Element msg -> Element msg
circle diameter attrs =
    el
        ([ width <| px diameter
         , height <| px diameter
         , Border.rounded <| diameter // 2
         , Background.color Color.green
         ]
            ++ attrs
        )


fa : List (Attribute msg) -> String -> Element msg
fa attrs =
    Attr.class
        >> List.singleton
        >> flip Html.span []
        >> html
        >> el attrs


decodeDetails : Decoder Details
decodeDetails =
    Decode.map2 Details
        (Decode.field "url" Decode.string)
        (Decode.at [ "opening_hours", "weekday_text" ] (Decode.list Decode.string))
