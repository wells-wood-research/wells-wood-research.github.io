module Pages.Tools exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Background as Background
import Shared.Style as Style
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url exposing (Url)


page : Page Params Model Msg
page =
    Page.static
        { view = view
        }


type alias Model =
    Url Params


type alias Msg =
    Never



-- VIEW


type alias Params =
    ()


view : Url Params -> Document Msg
view _ =
    { title = "Tools"
    , body = [ tools ]
    }


tools : Element msg
tools =
    column
        (Style.contentStyling ++ [ height fill, width (fill |> maximum 960) ])
        (List.map toolView allTools)


type alias Tool msg =
    { name : String
    , application : Maybe String
    , source : Maybe String
    , description : Element msg
    , backgroundImageLink : Maybe String
    }


allTools : List (Tool msg)
allTools =
    [ { name = "BAlaS"
      , application = Just "https://balas.app"
      , source = Just "https://github.com/wells-wood-research/BAlaS"
      , description =
            paragraph []
                [ text
                    """BAlaS is a fast, interactive web tool for performing
                    computational alanine-scanning mutagenesis. It has a simple
                    user interface that allows users to easily submit jobs and
                    visualise results. Powered by """
                , Style.simpleLink
                    { url =
                        "http://www.bris.ac.uk/biochemistry/research/bude"
                    , label = "BUDE"
                    }
                , text " and "
                , Style.simpleLink
                    { url =
                        "https://github.com/isambard-uob/isambard"
                    , label = "ISAMBARD"
                    }
                , text """, users can download and run the scanning engine
locally when they need to scale up analysis."""
                ]
      , backgroundImageLink = Just "/static/images/tools/balas.jpg"
      }
    , { name = "CCBuilder/CCBuilder 2"
      , application = Just "https://pragmaticproteindesign.bio.ed.ac.uk/builder/"
      , source = Just "https://github.com/woolfson-group/ccbuilder2"
      , description =
            paragraph []
                [ text
                    """CCBuilder is a user-friendly web application for creating
                    atomistic models of coiled coils and collagen. It can
                    accurately model almost all architectures of coiled coils
                    observed in nature, as well more unusual structures like """
                , Style.simpleLink
                    { url =
                        "http://science.sciencemag.org/content/346/6208/485"
                    , label = "α-helical barrels"
                    }
                , text "."
                ]
      , backgroundImageLink = Just "/static/images/tools/ccbuilder.jpg"
      }
    , { name = "DE-STRESS"
      , application = Just "https://pragmaticproteindesign.bio.ed.ac.uk/de-stress/"
      , source = Just "https://github.com/wells-wood-research/de-stress"
      , description =
            paragraph []
                [ text
                    """DE-STRESS (DEsigned STRucture Evaluation ServiceS) provides a
                    suite of tools for evaluating protein designs. Our aim is to help
                    make protein design more reliable, by providing tools to help you
                    select the most promising designs to take into the lab.
                    """
                ]
      , backgroundImageLink = Just "/static/images/tools/destress.jpg"
      }
    , { name = "PDBench"
      , application = Nothing
      , source = Just "https://github.com/wells-wood-research/PDBench"
      , description =
            paragraph []
                [ text
                    """PDBench is a dataset and software package for evaluating
                    fixed-backbone sequence design algorithms. The structures included
                    in PDBench have been chosen to account for the diversity and quality
                    of observed protein structures, giving a more holistic view of
                    performance.
                    """
                ]
      , backgroundImageLink = Nothing
      }
    , { name = "ISAMBARD"
      , application = Nothing
      , source = Just "https://github.com/isambard-uob/isambard"
      , description =
            paragraph []
                [ text
                    """ISAMBARD (Intelligent System for Analysis, Model Building
                    And Rational Design) is a Python library for structural
                    analysis and rational design of biomolecules, with a
                    particular focus on parametric modelling of proteins."""
                ]
      , backgroundImageLink = Just "/static/images/tools/isambard.jpg"
      }
    ]


toolView : Tool msg -> Element msg
toolView tool =
    let
        toolLinks =
            ( tool.application, tool.source )
    in
    textColumn
        [ width fill
        , padding 30
        , spacing 10
        , case tool.backgroundImageLink of
            Just imageLink ->
                Background.image imageLink

            Nothing ->
                Background.color Style.colours.white
        ]
        (Style.subHeading tool.name
            :: (case toolLinks of
                    ( Nothing, Nothing ) ->
                        []

                    ( Just app, Nothing ) ->
                        [ row [ spacing 10 ]
                            [ Style.simpleLink { url = app, label = "Application" } ]
                        ]

                    ( Nothing, Just source ) ->
                        [ row [ spacing 10 ]
                            [ Style.simpleLink { url = source, label = "Source" } ]
                        ]

                    ( Just app, Just source ) ->
                        [ row [ spacing 10 ]
                            [ Style.simpleLink { url = app, label = "Application" }
                            , Style.simpleLink { url = source, label = "Source" }
                            ]
                        ]
               )
            ++ [ tool.description ]
        )
