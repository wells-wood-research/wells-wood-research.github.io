module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Task
import Url


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- Model


type alias Model =
    { appInfo : AppInfo
    , key : Nav.Key
    }


type alias AppInfo =
    { mDevice : Maybe Device
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { appInfo = { mDevice = Nothing }, key = key }
    , Task.perform
        (\viewport ->
            PageResized
                (floor viewport.scene.width)
                (floor viewport.scene.height)
        )
        Browser.Dom.getViewport
    )



-- Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageResized Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { appInfo } =
            model
    in
    case msg of
        PageResized width height ->
            ( { model
                | appInfo =
                    { appInfo
                        | mDevice =
                            Just <|
                                classifyDevice
                                    { width = width, height = height }
                    }
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Browser.Events.onResize PageResized ]



-- View


view : Model -> Browser.Document Msg
view model =
    { title = "Wells Wood Research Group"
    , body = [ body model ]
    }


body : Model -> Html Msg
body model =
    let
        { appInfo } =
            model

        { mDevice } =
            appInfo
    in
    layout [ width fill ]
        (case mDevice of
            Just device ->
                case device.orientation of
                    Portrait ->
                        portraitView model

                    Landscape ->
                        landscapeView model

            Nothing ->
                portraitView model
        )



-- Portrait View


portraitView : Model -> Element Msg
portraitView model =
    column
        [ width fill
        , spacing 20
        ]
        [ title
        , links
        ]



-- Landscape View


landscapeView : Model -> Element Msg
landscapeView model =
    row [ width fill ]
        [ column [ width (px 300) ] [ title, links ]
        , paragraph [ width fill ] [ text "Content." ]
        ]



-- Common Elements


title : Element Msg
title =
    link
        [ width fill ]
        { url = "/"
        , label =
            paragraph
                [ centerX
                , titleFont
                , Font.size <| floor <| scaled 4
                , Font.bold
                , Font.center
                ]
                [ text "Wells Wood Research Group" ]
        }


links : Element msg
links =
    column [ width fill ]
        [ navLink "About" "/"
        , navLink "People" "/people"
        , navLink "Publications" "/publications"
        , navLink "Tools" "/tools"
        ]


navLink : String -> String -> Element msg
navLink label url =
    link
        [ width fill
        , paddingXY 0 5
        , mouseOver [ Background.color colours.grey ]
        , Background.color colours.darkGrey
        , Font.color colours.white
        , Font.center
        , contentFont
        ]
        { url = url
        , label = text label
        }



-- Styles


colours =
    { black = rgb 0 0 0
    , white = rgb 1 1 1
    , lightGrey = rgb 0.7 0.7 0.7
    , grey = rgb 0.5 0.5 0.5
    , darkGrey = rgb 0.3 0.3 0.3
    }


scaled : Int -> Float
scaled =
    modular 20.0 1.25


titleFont : Element.Attribute msg
titleFont =
    Font.family
        [ Font.external
            { name = "Poiret One"
            , url = "https://fonts.googleapis.com/css?family=Poiret+One"
            }
        , Font.serif
        ]


contentFont : Element.Attribute msg
contentFont =
    Font.family
        [ Font.external
            { name = "Raleway"
            , url = "https://fonts.googleapis.com/css?family=Raleway"
            }
        , Font.sansSerif
        ]
