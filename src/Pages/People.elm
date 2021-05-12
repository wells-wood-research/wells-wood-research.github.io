module Pages.People exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Font as Font
import FeatherIcons
import Shared.Advert exposing (advert)
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
    { title = "People"
    , body = [ people ]
    }


people : Element msg
people =
    textColumn
        Style.sectionStyling
        [ Style.heading "People"
        , personView chrisWellsWood
        , peopleSection "PhD Students"
            (phdStudents
                |> List.filter .active
            )
        , peopleSection "Masters Students"
            (mastersStudents
                |> List.filter .active
            )
        , peopleSection "Undergraduate Students"
            (undergraduateStudents
                |> List.filter .active
            )
        , peopleSection "Previous Members"
            ((phdStudents ++ mastersStudents ++ undergraduateStudents)
                |> List.filter (not << .active)
            )
        , Style.heading "Join Us"
        , advert
        ]


peopleSection : String -> List (Person msg) -> Element msg
peopleSection headingText peopleInSection =
    if List.isEmpty peopleInSection then
        none

    else
        column [] <|
            Style.subHeading headingText
                :: (peopleInSection
                        |> List.map personView
                   )


type alias Person msg =
    { pictureUrl : String
    , name : String
    , associatedLab : Maybe (Element msg)
    , email : Maybe String
    , twitter : Maybe String
    , github : Maybe String
    , bio : Element msg
    , active : Bool
    }


chrisWellsWood : Person msg
chrisWellsWood =
    { pictureUrl = "/static/images/people/chriswellswood.jpg"
    , name = "Chris Wells Wood"
    , associatedLab = Nothing
    , email = Just "chris.wood@ed.ac.uk"
    , twitter = Just "https://twitter.com/ChrisWellsWood"
    , github = Just "https://github.com/ChrisWellsWood"
    , bio =
        paragraph []
            [ text
                """Chris took his undergraduate degree in Molecular and
                Cellular Biology at the University of Glasgow. He then went
                on to undertake a PhD and postdoc in the lab of """
            , Style.simpleLink
                { url = "https://woolfsonlab.wordpress.com/"
                , label = "Prof. Dek Woolfson"
                }
            , text
                """, where he worked on developing and applying tools for
                computational protein design. In 2018 he was awarded an
                EPSRC postdoctoral fellowship and moved to the University of
                Edinburgh to establish his research group."""
            ]
    , active = True
    }


phdStudents : List (Person msg)
phdStudents =
    [ { pictureUrl = "/static/images/people/leocastorina.jpg"
      , name = "Leonardo Castorina"
      , associatedLab = Nothing
      , email = Just "leonardo.castorina@ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/universvm"
      , bio =
            paragraph []
                [ text
                    """Leo is currently a CDT candidate at the UKRI CDT in Biomedical
                    Artificial Intelligence programme. He studied Biochemistry at the
                    University of Edinburgh and interned at IBM, P&G and the Swiss
                    Institute of Bioinformatics.

                    Leo is interested in developing accessible and explainable methods
                    for de novo protein design using deep learning.
                    """
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/michaeljamesstam.jpg"
      , name = "Michael James Stam"
      , associatedLab = Nothing
      , email = Just "michael.stam@ed.ac.uk"
      , twitter = Just "https://twitter.com/mjstam"
      , github = Just "https://github.com/MichaelJamesStam"
      , bio =
            paragraph []
                [ text
                    """Michael Stam received his undergraduate degree in Mathematics
                    from the University of Edinburgh. After graduating, he went to work
                    in financial services for four years, where he applied statistical
                    analysis and machine learning techniques to financial data.
                    Currently, he is in the PhD stage of the UKRI CDT in Biomedical
                    Artificial Intelligence programme, where he is looking at optimising
                    the reliability of de novo protein design, by understanding the
                    different reasons why most protein designs fail."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/jonathanmorales.jpg"
      , name = "Jonathan Morales-Espinoza"
      , associatedLab =
            Style.simpleLink
                { url = "http://virtualplant.bio.puc.cl/"
                , label = "Gutiérrez Lab, PUC"
                }
                |> Just
      , email = Just "j.morales-espinoza@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Jonathan Morales studied a biochemistry at the Universidad
                    De Santiago De Chile. During this time he worked in fungal
                    cell biology testing the antifungal mechanism of different
                    natural phenolic compounds against Botrytis cinerea, one of
                    the most worldwide relevant phytopathogenic fungus. After
                    his undergraduate studies, he moved to the Pontificia
                    Universidad Catolica de Chile to undertake a PhD in the lab
                    of Rodrigo Gutiérrez. Currently, Jonathan works in plant
                    molecular signal transduction triggered by nutrients and is
                    visiting the Wells Wood Lab to design and develop a new
                    protein-based sensors to understand nutrient movement in
                    plants."""
                ]
      , active = False
      }
    , { pictureUrl = "/static/images/people/jackoshea.jpg"
      , name = "Jack O'Shea"
      , associatedLab =
            Style.simpleLink
                { url = "https://www.ed.ac.uk/discovery-brain-sciences/our-staff/research-groups/sebastian-greiss"
                , label = "Greiss Lab, UoE"
                }
                |> Just
      , email = Just "j.m.o'shea@sms.ed.ac.uk"
      , twitter = Just "https://twitter.com/jack_oshea97"
      , github = Just "https://github.com/97joshea"
      , bio =
            paragraph []
                [ text
                    """Jack studied Natural Sciences (Synthetic Organic
                    Chemistry and Molecular and Cell Biology) at University
                    Collage London for his undergraduate degree. He is taking
                    his PhD in Dr. Sebastian Greiss' lab at the University of
                    Edinburgh, and is collaborating with the Wells Wood lab
                    to tune the affinity of protein-protein interactions."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/mattscheier.jpg"
      , name = "Matthew Scheier"
      , associatedLab =
            Style.simpleLink
                { url = "http://horsfall.bio.ed.ac.uk"
                , label = "Horsfall Lab, UoE"
                }
                |> Just
      , email = Just "matthew.scheier@ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/mscheier"
      , bio =
            paragraph []
                [ text
                    """Matthew did his undergraduate degree in Biochemistry at
                    the University of Edinburgh and a research Masters in
                    Systems and Synthetic Biology at Imperial College London. He
                    started his PhD in October 2018 in the """
                , Style.simpleLink
                    { url = "http://horsfall.bio.ed.ac.uk"
                    , label = "Horsfall Lab"
                    }
                , text
                    """, and is working in the Wells Wood lab to engineer
                    encapsulins to enable novel metal nanoparticle synthesis
                    using synthetic biology."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/nataliaszlachetka.jpg"
      , name = "Natalia Szlachetka"
      , associatedLab =
            Style.simpleLink
                { url = "https://www.ed.ac.uk/profile/jelena-baranovic"
                , label = "Baranovic Lab, UoE"
                }
                |> Just
      , email = Just "s1510509@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Natalia is currently in the PhD stage of the UKRI CDT in
                    Biomedical Artificial Intelligence programme. She completed her
                    undergraduate degree in Biotechnology at the University of
                    Edinburgh.
                    """
                ]
      , active = True
      }
    ]


mastersStudents : List (Person msg)
mastersStudents =
    [ { pictureUrl = "/static/images/people/gangliu.jpg"
      , name = "Gang Liu"
      , associatedLab = Nothing
      , email = Just "g.liu-15@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Gang is a graduate student in biotechnology at the University of
                    Edinburgh. He is very interested in protein-structure analysis
                    and drug discovery. His research project centres on modelling
                    and simulation of the protein SUN1.
                    """
                ]
      , active = True
      }
    ]


undergraduateStudents : List (Person msg)
undergraduateStudents =
    [ { pictureUrl = "/static/images/people/rokaspetrenas.jpg"
      , name = "Rokas Petrenas"
      , associatedLab = Nothing
      , email = Just "s1706179@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/rokaske199"
      , bio =
            paragraph []
                [ text
                    """Rokas is currently in the final year of his undergraduate degree
                    in Biochemistry at the University of Edinburgh. He is interested in
                    Structural and Computational Biology, especially the development and
                    application of novel proteins.
                    """
                ]
      , active = False
      }
    ]


personView : Person msg -> Element msg
personView person =
    column
        [ paddingXY 0 30
        , spacing 30
        ]
        [ wrappedRow [ spacing 30 ]
            [ column [ spacing 10 ]
                [ image [ centerX, width (px 250) ]
                    { src = person.pictureUrl, description = person.name }
                , row [ centerX, spacing 10 ]
                    [ case person.email of
                        Just emailAccount ->
                            newTabLink
                                []
                                { url = "mailto:" ++ emailAccount
                                , label =
                                    FeatherIcons.mail
                                        |> FeatherIcons.toHtml []
                                        |> html
                                }

                        Nothing ->
                            none
                    , case person.twitter of
                        Just twitterAccount ->
                            newTabLink
                                []
                                { url = twitterAccount
                                , label =
                                    FeatherIcons.twitter
                                        |> FeatherIcons.toHtml []
                                        |> html
                                }

                        Nothing ->
                            none
                    , case person.github of
                        Just githubAccount ->
                            newTabLink
                                []
                                { url = githubAccount
                                , label =
                                    FeatherIcons.github
                                        |> FeatherIcons.toHtml []
                                        |> html
                                }

                        Nothing ->
                            none
                    ]
                ]
            , column [ spacing 10, width fill ]
                [ Style.subHeading person.name
                , case person.associatedLab of
                    Just associatedLab ->
                        paragraph [ Font.italic ]
                            [ text "Primary supervisor: "
                            , associatedLab
                            ]

                    Nothing ->
                        none
                , person.bio
                ]
            ]
        ]
