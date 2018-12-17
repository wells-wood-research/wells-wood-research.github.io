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
                    -- This should be changed once self hosted
                    ( { model
                        | appInfo =
                            { appInfo
                                | route =
                                    UrlParser.parse routeParser url
                                        |> Maybe.withDefault About
                            }
                    }
                    --( model
                    , Cmd.none
                    --, Nav.pushUrl model.key (Url.toString url)
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
    layout [ height fill, width fill ]
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
        [ height fill
        , width fill
        ]
        [ header
        , links
        , content model.appInfo.route
        , footer
        ]



-- Landscape View


landscapeView : Model -> Element Msg
landscapeView model =
    row [ height fill, width fill ]
        [ column
            [ height fill, width (px 300), Background.color colours.lightGrey ]
            [ header, links, footer ]
        , content model.appInfo.route
        ]



-- Common Elements


header : Element Msg
header =
    column
        [ width fill
        , padding 30
        , spacing 30
        , Background.color colours.lightGrey
        ]
        [ link
            [ centerX ]
            { url = "/"
            , label =
                paragraph
                    [ titleFont
                    , Font.size <| floor <| scaled 4
                    , Font.bold
                    , Font.center
                    ]
                    [ text "Wells Wood Research Group" ]
            }
        , image [ width (px 200), centerX ]
            { src = "/static/images/uoe.svg"
            , description = "University of Edinburgh Logo"
            }
        ]


footer : Element msg
footer =
    column
        [ alignBottom
        , width fill
        , padding 30
        , spacing 30
        , Background.color colours.lightGrey
        , Font.center
        ]
        [ heading """Funded By"""
        , wrappedRow [ centerX ]
            [ image [ width (px 200) ]
                { src = "/static/images/epsrc.svg"
                , description = "EPSRC Logo"
                }
            ]
        ]


heading : String -> Element msg
heading label =
    paragraph
        [ titleFont
        , Font.size <| floor <| scaled 3
        , Font.bold
        ]
        [ text label ]


subHeading : String -> Element msg
subHeading label =
    paragraph
        [ titleFont
        , Font.size <| floor <| scaled 2
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
        , padding 10
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
    , Font.size <| floor <| scaled 1
    ]


simpleText : String -> Element msg
simpleText contentText =
    paragraph [] [ text contentText ]


simpleLink : { label : String, url : String } -> Element msg
simpleLink { label, url } =
    link
        [ Font.color colours.grey
        , Font.underline
        ]
        { url = url
        , label = text label
        }


defaultEach =
    { left = 0, right = 0, top = 0, bottom = 0 }



-- Content


content : Route -> Element msg
content route =
    el [ height fill, width fill, padding 30 ]
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
    textColumn
        (contentStyling ++ [ width fill, spacing 30 ])
        [ heading "About Us"
        , subHeading "Robust and accessible protein design"
        , """Our research focuses on improving the accessibility and
reliability of protein design so that it can be adopted more widely as a tool
for tackling challenges in biotechnology and synthetic biology. To do this,
we're developing tools that apply machine-learning, computational modelling
and structural bioinformatics to help guide users through the protein-design
process."""
            |> simpleText
        , paragraph
            contentStyling
            [ """We aim to test all the methods we develop in at scale in the
laboratory. To do this we using the robotics available at Edinburgh, in the
incredible """
                |> text
            , simpleLink
                { url = "https://www.genomefoundry.org/"
                , label = "Genome Foundary"
                }
            ]
        , """Our research is publically funded, so we are committed to making
our data, software and publications open access."""
            |> simpleText
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
