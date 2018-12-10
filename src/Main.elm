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
import Url.Parser as UrlParser


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
    , route : Route
    }


type Route
    = About
    | People
    | Publications
    | Tools


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { appInfo = { mDevice = Nothing, route = About }, key = key }
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


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map About UrlParser.top
        , UrlParser.map About (UrlParser.s "about")
        , UrlParser.map People (UrlParser.s "people")
        , UrlParser.map Publications (UrlParser.s "publications")
        , UrlParser.map Tools (UrlParser.s "tools")
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { appInfo } =
            model
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( { model
                | appInfo =
                    { appInfo
                        | route =
                            UrlParser.parse routeParser url
                                |> Maybe.withDefault About
                    }
              }
            , Cmd.none
            )

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
        ]
        [ title
        , links
        , content model.appInfo.route
        ]



-- Landscape View


landscapeView : Model -> Element Msg
landscapeView model =
    row [ width fill ]
        [ column [ width (px 300) ] [ title, links ]
        , content model.appInfo.route
        ]



-- Common Elements


title : Element Msg
title =
    link
        [ width fill
        , paddingXY 0 10
        , Background.color colours.lightGrey
        ]
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


heading : String -> Element msg
heading label =
    paragraph
        [ titleFont
        , Font.size <| floor <| scaled 3
        , Font.bold
        ]
        [ text label ]


links : Element msg
links =
    column [ width fill ]
        [ navLink "About" "/about"
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


contentStyling : List (Element.Attribute msg)
contentStyling =
    [ contentFont
    ]



-- Content


content : Route -> Element msg
content route =
    el [ width fill, padding 10 ]
        (case route of
            About ->
                about

            People ->
                people

            Publications ->
                publications

            Tools ->
                tools
        )


about : Element msg
about =
    paragraph
        contentStyling
        [ heading "About"
        ]


people : Element msg
people =
    paragraph
        contentStyling
        [ heading "People"
        ]


publications : Element msg
publications =
    paragraph
        contentStyling
        [ heading "Publications"
        ]


tools : Element msg
tools =
    paragraph
        contentStyling
        [ heading "Tools"
        ]
