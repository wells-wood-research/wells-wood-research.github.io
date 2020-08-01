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
import Element.Font as Font
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
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
view { page } _ =
    { title = page.title
    , body =
        [ column [ padding 20, spacing 20, height fill ]
            [ row [ spacing 20 ]
                [ link [ Font.color (rgb 0 0.25 0.5), Font.underline ]
                    { url = Route.toString Route.Top, label = text "Homepage" }
                , link [ Font.color (rgb 0 0.25 0.5), Font.underline ]
                    { url = Route.toString Route.NotFound, label = text "Not found" }
                ]
            , column [ height fill ] page.body
            ]
        ]
    }
