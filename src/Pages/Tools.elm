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
      , application = Just "http://coiledcoils.chm.bris.ac.uk/ccbuilder2/builder"
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
    , { name = "DE-STRESS -- COMING SOON!"
      , application = Nothing
      , source = Nothing
      , description =
            paragraph []
                [ text
                    """DE-STRESS (DEsigned STRucture Evaluation ServiceS) is a
                    web application and associate web API that provides
                    automated assessment of the quality of protein designs with
                    respect to their intended application. DE-STRESS is
                    currently under development, but a closed beta is planned
                    for the end of summer 2019, so please contact """
                , Style.simpleLink
                    { url =
                        "mailto:chris.wood@ed.ac.uk"
                    , label = "Chris Wood"
                    }
                , text
                    """ if you're interested in getting involved."""
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

