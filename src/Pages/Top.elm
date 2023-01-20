module Pages.Top exposing (Model, Msg, Params, page)

import Element exposing (..)
import Html
import Html.Attributes as HAtt
import Shared.Advert exposing (advert)
import Shared.Style as Style
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


type alias Params =
    ()


type alias Model =
    Url Params


type alias Msg =
    Never


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }



-- VIEW


view : Url Params -> Document Msg
view _ =
    { title = "Wells Wood Research Group"
    , body = [ body ]
    }


body : Element msg
body =
    textColumn
        Style.sectionStyling
        [ Style.heading "About Us"
        , Html.iframe
            [ HAtt.height 400
            , HAtt.src "https://www.youtube.com/embed/Am45c83iLg4"
            , HAtt.title "YouTube video player"
            , HAtt.attribute "frameborder" "0"
            , HAtt.attribute "allow"
                "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            , HAtt.attribute "allowfullscreen" ""
            ]
            []
            |> html
            |> el [ centerX, width <| maximum 700 <| fill ]
            |> el [ width fill ]
        , Style.subHeading "Making protein design more accessible"
        , paragraph []
            [ Style.simpleText
                """Based in the University of Edinburgh, our research focuses on
                improving the accessibility and reliability of protein design, with the
                aim of increasing its use as a tool for tackling challenges in
                biotechnology and synthetic biology. To do this, we're developing
                software that applies machine-learning, computational modelling and
                structural bioinformatics to help guide users through the protein-design
                process.
                """
            ]
        , Style.subHeading "Rigorously tested methods"
        , paragraph
            Style.contentStyling
            [ """We apply all the methods that we create at scale in the
                laboratory, using the robotics available at Edinburgh through
                the incredible """
                |> text
            , Style.simpleLink
                { url = "https://www.genomefoundry.org/"
                , label = "Genome Foundry"
                }
            , text """. All data and scripts are made publicly available so
                that users are confident in the effectiveness of the methods and can
                apply them to their fullest."""
            ]
        , Style.subHeading "Committed to open-access research"
        , paragraph []
            [ text """Our research is publicly funded, so we are committed
                to making our outputs publicly available, including data,
                software and publications."""
            ]
        , Style.heading "Join Us"
        , advert
        ]
