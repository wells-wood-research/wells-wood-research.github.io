module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    , view
    )

import Browser.Dom
import Browser.Events
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Shared.Style as Style exposing (defaultEach)
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Task
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , mDevice : Maybe Device
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { url = url
      , key = key
      , mDevice = Nothing
      }
    , Task.perform
        (\viewport ->
            PageResized
                (floor viewport.scene.width)
                (floor viewport.scene.height)
        )
        Browser.Dom.getViewport
    )



-- UPDATE


type Msg
    = PageResized Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PageResized width height ->
            ( { model
                | mDevice =
                    Just <|
                        classifyDevice
                            { width = width, height = height }
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize PageResized



-- VIEW


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page } { mDevice } =
    { title = page.title
    , body =
        [ body mDevice page ]
    }


body : Maybe Device -> Document msg -> Element msg
body mDevice page =
    el [ height fill, width fill ]
        (case mDevice of
            Just device ->
                case device.orientation of
                    Portrait ->
                        portraitView page

                    Landscape ->
                        landscapeView page

            Nothing ->
                portraitView page
        )


portraitView : Document msg -> Element msg
portraitView page =
    column
        [ height fill
        , width fill
        ]
        [ header
        , links
        , column [] page.body
        , footer
        ]


landscapeView : Document msg -> Element msg
landscapeView page =
    el [ height fill, centerX ]
        (row [ height fill, width fill ]
            [ column
                [ height fill
                , width (px 300)
                , scrollbars
                , Background.color Style.colours.lightGrey
                ]
                [ header, links, footer ]
            , column
                [ height fill
                , width (fill |> maximum 960)
                , scrollbars
                , Border.widthEach { defaultEach | right = 2 }
                , Border.color Style.colours.lightGrey
                ]
                page.body
            ]
        )


header : Element msg
header =
    column
        [ width fill
        , padding 30
        , spacing 30
        , Background.color Style.colours.lightGrey
        ]
        [ link
            [ centerX ]
            { url = "/"
            , label =
                column [ spacing 20 ]
                    [ paragraph
                        [ Style.titleFont
                        , Font.size <| floor <| Style.scaled 5
                        , Font.center
                        ]
                        [ text "Wells Wood Research Group" ]
                    , paragraph
                        [ Style.titleFont
                        , Font.size <| floor <| Style.scaled 2
                        , Font.center
                        ]
                        [ text "Pragmatic Protein Design" ]
                    , image [ centerX, width (px 100) ]
                        { src = "/static/images/logo.svg"
                        , description = "Lab Logo"
                        }
                    ]
            }
        ]


footer : Element msg
footer =
    column
        [ alignBottom
        , width fill
        , padding 30
        , spacing 30
        , Background.color Style.colours.lightGrey
        , Font.center
        ]
        [ newTabLink
            [ centerX ]
            { url = "https://www.ed.ac.uk/"
            , label =
                image [ width (px 200) ]
                    { src = "/static/images/uoe.svg"
                    , description = "University of Edinburgh Logo"
                    }
            }
        , Style.subHeading """Funded By"""
        , wrappedRow [ centerX ]
            [ image [ width (px 200) ]
                { src = "/static/images/epsrc.svg"
                , description = "EPSRC Logo"
                }
            ]
        ]


links : Element msg
links =
    column [ width fill ]
        [ navLink "About" Route.Top

        -- , navLink "News" "/#news"
        -- , navLink "People" "/#people"
        -- , navLink "Publications" "/#publications"
        -- , navLink "Tools" "/#tools"
        ]


navLink : String -> Route -> Element msg
navLink label route =
    link
        [ width fill
        , padding 10
        , mouseOver [ Background.color Style.colours.grey ]
        , Background.color Style.colours.darkGrey
        , Font.color Style.colours.white
        , Font.center
        , Style.contentFont
        ]
        { url = Route.toString route
        , label = text label
        }
