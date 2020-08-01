module Spa.Generated.Pages exposing
    ( Model
    , Msg
    , init
    , load
    , save
    , subscriptions
    , update
    , view
    )

import Pages.Top
import Pages.News
import Pages.NotFound
import Pages.People
import Pages.Publications
import Pages.Tools
import Shared
import Spa.Document as Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page exposing (Page)
import Spa.Url as Url


-- TYPES


type Model
    = Top__Model Pages.Top.Model
    | News__Model Pages.News.Model
    | NotFound__Model Pages.NotFound.Model
    | People__Model Pages.People.Model
    | Publications__Model Pages.Publications.Model
    | Tools__Model Pages.Tools.Model


type Msg
    = Top__Msg Pages.Top.Msg
    | News__Msg Pages.News.Msg
    | NotFound__Msg Pages.NotFound.Msg
    | People__Msg Pages.People.Msg
    | Publications__Msg Pages.Publications.Msg
    | Tools__Msg Pages.Tools.Msg



-- INIT


init : Route -> Shared.Model -> ( Model, Cmd Msg )
init route =
    case route of
        Route.Top ->
            pages.top.init ()
        
        Route.News ->
            pages.news.init ()
        
        Route.NotFound ->
            pages.notFound.init ()
        
        Route.People ->
            pages.people.init ()
        
        Route.Publications ->
            pages.publications.init ()
        
        Route.Tools ->
            pages.tools.init ()



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update bigMsg bigModel =
    case ( bigMsg, bigModel ) of
        ( Top__Msg msg, Top__Model model ) ->
            pages.top.update msg model
        
        ( News__Msg msg, News__Model model ) ->
            pages.news.update msg model
        
        ( NotFound__Msg msg, NotFound__Model model ) ->
            pages.notFound.update msg model
        
        ( People__Msg msg, People__Model model ) ->
            pages.people.update msg model
        
        ( Publications__Msg msg, Publications__Model model ) ->
            pages.publications.update msg model
        
        ( Tools__Msg msg, Tools__Model model ) ->
            pages.tools.update msg model
        
        _ ->
            ( bigModel, Cmd.none )



-- BUNDLE - (view + subscriptions)


bundle : Model -> Bundle
bundle bigModel =
    case bigModel of
        Top__Model model ->
            pages.top.bundle model
        
        News__Model model ->
            pages.news.bundle model
        
        NotFound__Model model ->
            pages.notFound.bundle model
        
        People__Model model ->
            pages.people.bundle model
        
        Publications__Model model ->
            pages.publications.bundle model
        
        Tools__Model model ->
            pages.tools.bundle model


view : Model -> Document Msg
view =
    bundle >> .view


subscriptions : Model -> Sub Msg
subscriptions =
    bundle >> .subscriptions


save : Model -> Shared.Model -> Shared.Model
save =
    bundle >> .save


load : Model -> Shared.Model -> ( Model, Cmd Msg )
load =
    bundle >> .load



-- UPGRADING PAGES


type alias Upgraded params model msg =
    { init : params -> Shared.Model -> ( Model, Cmd Msg )
    , update : msg -> model -> ( Model, Cmd Msg )
    , bundle : model -> Bundle
    }


type alias Bundle =
    { view : Document Msg
    , subscriptions : Sub Msg
    , save : Shared.Model -> Shared.Model
    , load : Shared.Model -> ( Model, Cmd Msg )
    }


upgrade : (model -> Model) -> (msg -> Msg) -> Page params model msg -> Upgraded params model msg
upgrade toModel toMsg page =
    let
        init_ params shared =
            page.init shared (Url.create params shared.key shared.url) |> Tuple.mapBoth toModel (Cmd.map toMsg)

        update_ msg model =
            page.update msg model |> Tuple.mapBoth toModel (Cmd.map toMsg)

        bundle_ model =
            { view = page.view model |> Document.map toMsg
            , subscriptions = page.subscriptions model |> Sub.map toMsg
            , save = page.save model
            , load = load_ model
            }

        load_ model shared =
            page.load shared model |> Tuple.mapBoth toModel (Cmd.map toMsg)
    in
    { init = init_
    , update = update_
    , bundle = bundle_
    }


pages :
    { top : Upgraded Pages.Top.Params Pages.Top.Model Pages.Top.Msg
    , news : Upgraded Pages.News.Params Pages.News.Model Pages.News.Msg
    , notFound : Upgraded Pages.NotFound.Params Pages.NotFound.Model Pages.NotFound.Msg
    , people : Upgraded Pages.People.Params Pages.People.Model Pages.People.Msg
    , publications : Upgraded Pages.Publications.Params Pages.Publications.Model Pages.Publications.Msg
    , tools : Upgraded Pages.Tools.Params Pages.Tools.Model Pages.Tools.Msg
    }
pages =
    { top = Pages.Top.page |> upgrade Top__Model Top__Msg
    , news = Pages.News.page |> upgrade News__Model News__Msg
    , notFound = Pages.NotFound.page |> upgrade NotFound__Model NotFound__Msg
    , people = Pages.People.page |> upgrade People__Model People__Msg
    , publications = Pages.Publications.page |> upgrade Publications__Model Publications__Msg
    , tools = Pages.Tools.page |> upgrade Tools__Model Tools__Msg
    }