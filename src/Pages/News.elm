module Pages.News exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Shared.Style as Style exposing (defaultEach)
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
    { title = "News"
    , body = [ news ]
    }


news : Element msg
news =
    textColumn
        Style.sectionStyling
        (Style.heading "News" :: List.map newsItemView newsItems)


type alias NewsItem msg =
    { date : String
    , title : String
    , category : String
    , newsContent : Element msg
    }


newsItemView : NewsItem msg -> Element msg
newsItemView { date, title, category, newsContent } =
    column
        [ paddingXY 0 30
        , spacing 15
        , Border.widthEach
            { defaultEach | top = 1 }
        ]
        [ Style.subHeading title
        , el [ Font.bold ] (text (date ++ ", " ++ category))
        , newsContent
        ]


newsItems : List (NewsItem msg)
newsItems =
    [ { date = "2022-01-13"
      , title =
            """DE-STRESS paper now open access in PEDS"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text <|
                        """The DE-STRESS paper has now been published in Protein
                        Engineering, Design and Selection. The peer review process was
                        very constructive and I think it really improved the paper.
                        You can find a link to the application in the "Tools" page, give
                        it a go and let us know what you think!
                        """
                    ]
                ]
      }
    , { date = "2021-05-07"
      , title =
            """DE-STRESS: A user-friendly web application for the evaluation of protein
            designs
            """
      , category = "Preprint"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                destressNews
      }
    , { date = "2021-04-19"
      , title =
            """Generation of photocaged nanobodies for in vivo applications using genetic
            code expansion and computationally guided protein engineering
            """
      , category = "Preprint"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                photocagedNanobodiesNews
      }
    , { date = "2020-01-20"
      , title = """BAlaS: fast, interactive and accessible computational alanine-
                scanning using BudeAlaScan"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                balasNews
      }
    , { date = "2019-07-15"
      , title = "Conference: Protein Engineering II"
      , category = "Conference"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                protEngConfNews
      }
    , { date = "2019-05-08"
      , title = "Navigating the structural landscape of de novo α-helical bundles"
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text """Our research on de novo designed pH sensitive and
                    highly thermostable helical bundles has now been """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://pubs.acs.org/doi/10.1021/jacs.8b13354"
                        , label = text "published in JACS"
                        }
                    , text """. See the news article from 2019-01-01 for more
                    information."""
                    ]
                , paragraph []
                    [ text
                        """Chris."""
                    ]
                ]
      }
    , { date = "2019-01-01"
      , title = "Navigating the structural landscape of de novo α-helical bundles"
      , category = "Preprint"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width fill ]
                    { src = "/static/images/news/2019-01-01-tetramers.jpg"
                    , description = "Designed anti-parallel tetramers exhibit structural plasticity."
                    }
                , paragraph []
                    [ text "We've just release a "
                    , newTabLink
                        Style.linkStyling
                        { url = "https://www.biorxiv.org/content/early/2018/12/21/503698"
                        , label = text "preprint of our latest paper"
                        }
                    , text
                        """, where we created mutants of a stable hexameric
                        coiled coil and found that they adopted the
                        anti-parallel conformation. We then discovered that
                        certain mutants would revert back to the parallel
                        hexamer structure when the pH was altered. Finally we
                        used negative design to stablise the anti-parallel
                        conformation, which resulted in apCC-Tet, a
                        hyper-thermostable, anti-parallel tetramer. apCC-Tet is
                        a robust scaffold that can now be used for applications
                        in protein engineering and synthetic biology."""
                    ]
                , paragraph []
                    [ text
                        """This was the last paper I worked on before leaving
                        Dek Woolfson's group in Bristol and it was pretty
                        satisfying to see it come together as it contains the
                        first peptide that I ever made in the lab. Huge thank
                        you to my co-first author, Guto Rhys, it was great fun
                        working with him on the paper."""
                    ]
                , paragraph []
                    [ text
                        """Chris."""
                    ]
                ]
      }
    ]


destressNews : List (Element msg)
destressNews =
    [ paragraph []
        [ text
            """DE-STRESS, our web application for evaluating models of designed and
            engineered proteins, is out now! You can find the web application """
        , Style.simpleLink
            { label = "here"
            , url = "http://destressprotein.design"
            }
        , text " and the source code "
        , Style.simpleLink
            { label = "here"
            , url = "https://github.com/wells-wood-research/de-stress"
            }
        , text
            """. The manuscript is under review at the moment, and you can find the
            preprint on """
        , Style.simpleLink
            { label = "Biorxiv"
            , url = "https://www.biorxiv.org/content/10.1101/2021.04.28.441790v1"
            }
        , text "."
        ]
    , paragraph []
        [ text
            """ It's been almost 2 years since I first demoed an early prototype of
            DE-STRESS, and it's been much more difficult to get to this
            point than I first thought it would be, but we're really happy with how
            the app has turned out. Let us know what you think of it, does it have all
            the features that you need? Get in contact if you have any questions or
            comments!
            """
        ]
    ]


photocagedNanobodiesNews : List (Element msg)
photocagedNanobodiesNews =
    [ paragraph []
        [ text "We have a "
        , Style.simpleLink
            { label = "new preprint"
            , url = "https://doi.org/10.1101/2021.04.16.440193"
            }
        , text
            """ out on Biorxiv. The major objective of the research was to engineer
            nanobodies in order to make their binding photo-activatable. Non-canonical
            amino acids were introduced to the binding interface that have bulky
            chemical groups that are cleaved off when exposed to UV light. It
            turns out that these "photocaged" amino acids are not sufficient to disrupt
            the interaction, so we used a technique called computational alanine
            scanning mutagenesis, combined with molecular-dynamics simulations, to guide
            engineering of the binding interface. The end result is that we managed to
            make 2 photo-activatable nanobodies, and the coolest thing is that
            they work in the nematode worm C. elegans! This came out of a really fun
            collaboration with the """
        , Style.simpleLink
            { label = "Greiss Lab"
            , url = "https://www.ed.ac.uk/discovery-brain-sciences/our-staff/research-groups/sebastian-greiss"
            }
        , text ", hopefully the first of many!"
        ]
    ]


balasNews : List (Element msg)
balasNews =
    [ paragraph []
        [ text
            """2020 was off too a good start when I found out that the BAlaS paper
            was accepted for publication. The paper is open access and available """
        , Style.simpleLink
            { label = "here"
            , url = "https://doi.org/10.1093/bioinformatics/btaa026"
            }
        , text """. BAlaS is a web tool for performing
            computational alanine scanning mutagenesis. There are a good few tools
            available for performing this type of analysis, but the advantage of BAlaS
            is that it has an intuitive web-based interface that allows you to submit
            jobs and analyse results with no set up at all. This is made possible as it
            is built on top of the blazingly fast BUDEAlaScan commandline application,
            which is described and benchmarked in detail in """
        , Style.simpleLink
            { label = "this paper"
            , url = "https://doi.org/10.1021/acschembio.9b00560"
            }
        , text
            """, created by the Sessions Group in University of Bristol. Give it a go
            and let me know what you think. A link to the application and the source
            code can be found on the tools page."""
        ]
    , el [ Font.italic ] <| text "Abstract"
    , paragraph []
        [ text """In experimental protein engineering, alanine-scanning mutagenesis
        involves the replacement of selected residues with alanine to determine the
        energetic contribution of each side chain to forming an interaction. For
        example, it is often used to study protein-protein interactions. However, such
        experiments can be time-consuming and costly, which has led to the development
        of programs for performing computational alanine-scanning mutagenesis (CASM) to
        guide experiments. While programs are available for this, there is a need for a
        real-time web application that is accessible to non-expert users."""
        ]
    , paragraph []
        [ text """Here we present BAlaS, an interactive web application for performing CASM via
        BudeAlaScan and visualizing its results. BAlaS is interactive and intuitive to
        use.  Results are displayed directly in the browser for the structure being
        interrogated enabling their rapid inspection. BAlaS has broad applications in
        areas such as drug discovery and protein-interface design."""
        ]
    ]


protEngConfNews : List (Element msg)
protEngConfNews =
    [ image [ centerX, width fill ]
        { src = "/static/images/news/2019-07-15-venue.jpg"
        , description = "Protein Engineering II Venue, University of York"
        }
    , paragraph []
        [ text
            """This week I went to an excellent conference organised by the """
        , Style.simpleLink
            { url = "https://biochemistry.org/"
            , label = "Biochemical Society"
            }
        , text
            """ called "Protein engineering II: from new molecules to new 
            processes". There was an amazing array of speakers from a range of
            areas, both from academia and industry. I think the highlights for
            me were: Mihriban Tuna from """
        , Style.simpleLink
            { url = "http://www.f-star.com/"
            , label = "F-Star"
            }
        , text
            """ talking about bifunctionalised antibodies as cancer theraputics; 
            Jana Aupič, from """
        , Style.simpleLink
            { url = "https://www.ki.si/en/departments/d12-department-of-synthetic-biology-and-immunology/"
            , label = "Roman Jerala's group"
            }
        , text
            """ in Slovenia, talking about reusing coiled coil building blocks
            while making complex protein origami; and """
        , Style.simpleLink
            { url = "http://lemkelab.com/"
            , label = "Edward Lemke's"
            }
        , text
            """ talk on making membraneless organelles.
            """
        ]
    , paragraph []
        [ text
            """Many more of the posters and talks were excellent, including my
            old boss Dek Woolfson and my colleague here at Edinburgh, Louise
            Horsfall. The venue was excellent (picture attached!) and
            organisation from the academic organisers and the Biochemical
            Society was great. It sounds like there's going to be a Protein
            Engineering III, so definitely come along to that if you're even
            vaguely in this area!
            """
        ]
    , paragraph []
        [ text
            """Finally, I got the oportunity to talk about DE-STRESS, my protein
            design evaluation web application, which I'm planning to have a
            closed beta of by the end of the summer, so do get in touch if
            you're interested in getting involved in that! More information
            soon.
            """
        ]
    ]
