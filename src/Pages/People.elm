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
        , peopleSection "Post Doctoral Research Associates"
            (postDocs
                |> List.filter .active
            )
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
        , previousPeopleSection "Previous Members"
            ((postDocs ++ phdStudents ++ mastersStudents ++ undergraduateStudents)
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


previousPeopleSection : String -> List (Person msg) -> Element msg
previousPeopleSection headingText peopleInSection =
    if List.isEmpty peopleInSection then
        none

    else
        column [] <|
            Style.subHeading headingText
                :: (peopleInSection
                        |> List.map previousPersonView
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
                Edinburgh to establish his research group. In 2020, he attained a
                permanent position in the School of Biological Science as a
                Lecturer in Biotechnology.
                """
            ]
    , active = True
    }


postDocs : List (Person msg)
postDocs =
    [ { pictureUrl = "/static/images/people/eugeneshrimptonphoenix.jpg"
      , name = "Eugene Shrimpton-Phoenix"
      , associatedLab = Nothing
      , email = Just "eshrimpt@ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/ESPhoenix"
      , bio =
            paragraph []
                [ text
                    """Eugene studied Chemistry at the University of Manchester
                    for his integrated masters degree. He completed his PhD in
                    the lab of Prof. Michael Bühl and Dr. John Mitchell at the
                    University of St Andrews. In his PhD, Eugene applied hybrid
                    quantum mechanical/ molecular mechanical (QM/MM) techniques
                    to explore the catalytic mechanism of Is-PETase, an enzyme
                    capable of degrading poly(ethylene) terephthalate. He is
                    now working on a project in the Wells Wood lab to develop
                    machine learning models that can be used to design
                    photo-activated flavin-dependent enzymes.
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
                    He has recently submitted his thesis for the PhD stage of the UKRI CDT in Biomedical
                    Artificial Intelligence programme, where he was looking at optimising
                    the reliability of de novo protein design, by understanding the
                    different reasons why most protein designs fail."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/jackoshea.jpg"
      , name = "Jack O'Shea"
      , associatedLab = Nothing
      , email = Just "j.m.o'shea@sms.ed.ac.uk"
      , twitter = Just "https://twitter.com/jack_oshea97"
      , github = Just "https://github.com/97joshea"
      , bio =
            paragraph []
                [ text
                    """Jack studied Natural Sciences (Synthetic Organic
                    Chemistry and Molecular and Cell Biology) at University
                    Collage London for his undergraduate degree. He completed
                    his PhD in Dr. Sebastian Greiss' lab at the University of
                    Edinburgh, during which he worked with the Wells Wood lab
                    to tune the affinity of protein-protein interactions.
                    
                    He is now undertaking a project in the Wells Wood lab to develop a
                    novel pipeline for high-throughput design of protein based sensors.
                    """
                ]
      , active = False
      }
    ]


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
    , { pictureUrl = "/static/images/people/martachronowska.jpg"
      , name = "Marta Chronowska"
      , associatedLab = Nothing
      , email = Just "m.chronowska@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/LunaPrau"
      , bio =
            paragraph []
                [ text
                    """Marta obtained her integrated Master’s degree in
                    Chemistry at the University of Edinburgh. Her final year
                    project completed at the Nagoya University in Japan
                    explored use of lasers to control chemical reactions. She
                    is now continuing her studies in Edinburgh by pursuing a
                    PhD in collaboration between the Wells Wood lab and the
                    Jarvis Group, thanks to the EASTBIO DTP funding. Her
                    research will span chemistry, biology and computer science
                    to develop data-driven methods for de novo design of
                    flavoprotein-based light-activated novel enzymes.
                    """
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/tadaskluonis.jpg"
      , name = "Tadas Kluonis"
      , associatedLab = Nothing
      , email = Just "t.kluonis@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/profdocpizza"
      , bio =
            paragraph []
                [ text
                    """Tadas Kluonis is currently pursuing a PhD position in
                    the Wells Wood lab, where his research focuses on utilizing
                    generative algorithms to explore the dark matter of protein
                    space. He obtained his undergraduate degree in
                    Biotechnology from the University of Edinburgh.
                    """
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/evanotari.jpg"
      , name = "Evangelia Notari"
      , associatedLab =
            Style.simpleLink
                { url = "https://www.julienmichel.net/lab/"
                , label = "Michel Lab, UoE"
                }
                |> Just
      , email = Just "e.notari@sms.ed.ac.uk"
      , twitter = Just "https://twitter.com/EvaNotari"
      , github = Just "https://github.com/eva-not"
      , bio =
            paragraph []
                [ text
                    """Eva received her integrated Masters in Chemical Engineering from
                    the National Technical University of Athens and then did a Masters
                    in Biotechnology at the University of Edinburgh. She is now
                    undertaking her PhD in the Michel lab as part of the EASTBIO DTP,
                    and is collaborating with the Wells Wood lab to design multi-state
                    proteins with the aid of molecular-dynamics simulations and machine
                    learning."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/anaroblesmartin.jpg"
      , name = "Ana Robles Martin"
      , associatedLab = Nothing
      , email = Nothing
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Ana Robles Martin is a PhD candidate at the Barcelona
                    Supercomputing Center and the University of Barcelona. She
                    studied Biochemistry at the University of Seville and later
                    pursued a Master's in Bioinformatics at the Autonomous
                    University of Barcelona. Her research focuses on
                    computational de novo design of hydrolase active sites for
                    polyethylene terephthalate (PET) degradation using
                    molecular modeling techniques such as Monte Carlo and
                    Molecular Dynamics simulations. Currently, Ana is
                    completing a Visiting Research Internship at the Wells Wood
                    lab, investigating enzymes involved in PET monomers
                    upcycling and applying methods to potentially modify the
                    substrate specificity of these enzymes."""
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
    , { pictureUrl = "/static/images/people/mertunal.jpg"
      , name = "Mert Ünal"
      , associatedLab = Nothing
      , email = Just "s.m.unal@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Mert did his undergraduate degree in Molecular Biology, Genetics
                    & Bioengineering at Sabanci University in Turkey and Master`s degree
                    in Synthetic Biology & Biotechnology at the University of Edinburgh.
                    He has research experience in protein biochemistry, evolutionary
                    biology and bioinformatics, and he is aiming to combine all of these
                    in his PhD project for the incorporation of unnatural cofactors into
                    the computationally designed proteins, in collaboration with the
                    Wallace Lab, UoE."""
                ]
      , active = True
      }
    , { pictureUrl = "/static/images/people/jonathanmorales.jpg"
      , name = "Jonathan Morales-Espinoza"
      , associatedLab =
            Style.simpleLink
                { url = "http://virtualplant.bio.puc.cl/"
                , label = "GutiÃ©rrez Lab, PUC"
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
                    of Rodrigo GutiÃ©rrez. Currently, Jonathan works in plant
                    molecular signal transduction triggered by nutrients and is
                    visiting the Wells Wood Lab to design and develop a new
                    protein-based sensors to understand nutrient movement in
                    plants."""
                ]
      , active = False
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
      , active = False
      }
    , { pictureUrl = "/static/images/people/handingwang.jpg"
      , name = "Handing Wang"
      , associatedLab = Nothing
      , email = Just "h.wang-243@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text """Handing is currently pursuing his Ph.D. in the Wood lab in
                    collaboration with Prof. Baojun Wang at ZJU, where his
                    interest lies in designing sensing domains using
                    computational modeling tools. Before starting his doctoral
                    studies, he received his Master's at Zhejiang University,
                    where he conducted research in CRISPR screening and
                    Nanopore sequencing in yeast.
                    """
                ]
      , active = True
      }
    ]


mastersStudents : List (Person msg)
mastersStudents =
    [ { pictureUrl = "/static/images/people/benorton.jpg"
      , name = "Ben Orton"
      , associatedLab = Nothing
      , email = Just "s1704921@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Ben completed his undergraduate degree in Biochemistry at the
                    University of Edinburgh. He is now undertaking a Master’s in Systems
                    and Synthetic Biology and is carrying out his research project with
                    the Wells Wood Lab. Ben is working with Mert to incorporate
                    unnatural cofactors into computationally designed proteins.
                    """
                ]
      , active = False
      }
    , { pictureUrl = "/static/images/people/haoruowei.jpg"
      , name = "Haoruo Wei"
      , associatedLab = Nothing
      , email = Just "h.wei-13@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Haoruo completed his undergraduate degree in Bioengineering at
                    Harbin Institute of Technology, and is undertaking his master degree
                    in Biotechnology in University of Edinburgh and performing research
                    project in the Wells Wood Lab. Right now, he is assisting with the
                    experimental evaluation of our protein design TIMED with the help of
                    Jack.
                    """
                ]
      , active = False
      }
    , { pictureUrl = "/static/images/people/gangliu.jpg"
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
      , active = False
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
    , { pictureUrl = "/static/images/people/ceciliahong.jpg"
      , name = "Cecilia Hong"
      , associatedLab = Nothing
      , email = Nothing
      , twitter = Nothing
      , github = Nothing
      , bio =
            paragraph []
                [ text
                    """Cecilia is an undergraduate Chemistry preparing for her year
                    abroad in South Korea for her masters. Having had previous
                    computation experience in Materials Chemistry, she has joined the
                    Wells Wood Research Group for the summer to undertake a project on
                    simulating P450-BM3 and related proteins.
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


previousPersonView : Person msg -> Element msg
previousPersonView person =
    column
        [ paddingXY 0 30
        , spacing 30
        ]
        [ wrappedRow [ spacing 30 ]
            [ column [ spacing 10 ]
                [ image [ centerX, width (px 125) ]
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
            , column [ spacing 10, width fill, Font.size 16 ]
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
