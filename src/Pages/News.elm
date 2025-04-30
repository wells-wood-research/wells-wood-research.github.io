module Pages.News exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes as HAtt
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
    [ { date = "2025-04-22"
      , title =
            """Congratulations Dr Castorina!"""
      , category = "Group"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 600 ]
                    { src = "static/images/news/2025-04-22-leos-viva.jpg"
                    , description = "Group members in the pub with Leo after his viva."
                    }
                , paragraph []
                    [ text <|
                        """Many congratulations to Dr Leonardo Castorina, who passed the
                        viva for his thesis title "Towards Efficient and Accessible Protein
                        Design with Machine Learning". Leo initially joined the lab as an
                        undergraduate project student, and I've been continually impressed
                        by his drive. Many thanks to his examiners, Noelia Ferruz and Matteo
                        Degiacomi. Leo is now off to take up a position at Astra Zeneca
                        in Cambridge, we wish him all the best and he will be missed!
                        """
                    ]
                ]
      }
    , { date = "2024-10-09"
      , title =
            """2024 Nobel Prize in Chemistry"""
      , category = "Group"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 600 ]
                    { src = "static/images/news/2024-10-09-group-photo.jpg"
                    , description = "Group photo Oct 2024"
                    }
                , paragraph []
                    [ text <|
                        """The lab got together to eat pizza and celebrate the 2024 Nobel
                        Prize in Chemistry being awarded to David Baker, for computational
                        protein design, and John Jumper and Demis Hassabis, for protein
                        structure prediction. The prize was thoroughly well deserved by all
                        parties and it's no exaggeration to say that the research of both
                        groups has had a transformational affect on the field of protein science.
                        """
                    ]
                , paragraph []
                    [ text <|
                        "Many congratulations!"
                    ]
                ]
      }
    , { date = "2024-09-09"
      , title =
            """The Protein Design Archive"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 600 ]
                    { src = "static/images/news/2024-08-09-pda.jpg"
                    , description = "Front page of the PDA."
                    }
                , paragraph []
                    [ text <|
                        """We have just released the first iteration of "The Protein Design
                        Archive". We are aiming for this resource to be the first place people
                        look to find information on designed proteins. It presents a structure-centric
                        view of protein design over time, although we're planning on expanding
                        it to proteins that are not structurally characterised in the future.
                        """
                    ]
                , paragraph []
                    [ text <|
                        """We also performed some analysis of the designed proteins in the database and
                        discovered some interesting things, although many of them will not be a surprise
                        to the protein design community. For example, alpha-helical regions
                        are over represented in designed proteins compared to natural proteins, and
                        sequence complexity is generally lower. Although this opens an interesting discussion
                        around whether we should be aiming to design proteins that look like natural proteins
                        in the first place! Regardless, they're useful numbers to have at hand. See the """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://doi.org/10.1101/2024.09.05.611465"
                        , label = text "preprint"
                        }
                    , text <|
                        """ for more information."""
                    ]
                , paragraph []
                    [ text <|
                        """Thank you to Marta and Michael for all their hard work putting this together, and
                        thank you to our wonderful collaborators Luigi and Dek. Here's link to the web
                        application, please let us know if you have any feedback: """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://pragmaticproteindesign.bio.ed.ac.uk/pda"
                        , label = text "https://pragmaticproteindesign.bio.ed.ac.uk/pda"
                        }
                    ]
                ]
      }
    , { date = "2024-05-14"
      , title =
            """Congratulations Dr Stam!"""
      , category = "Group"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 600 ]
                    { src = "static/images/news/2024-05-14-michaels-viva.jpg"
                    , description = "Group photo with Michael after he passed his viva."
                    }
                , paragraph []
                    [ text <|
                        """Many congratulations to Michael Stam, who passed his viva
                        with flying colours. Michael was the first PhD student to join
                        the group and he has been a joy to supervise. Despite starting
                        in the midst of the COVID pandemic, he took everything in his
                        stride and has worked diligently to produce some excellent
                        research. Michael is staying on in the group to undertake a
                        PDRA position. Many thanks to Birte Höcker and Ajitha Rajan
                        for examining.
                        """
                    ]
                ]
      }
    , { date = "2024-05-01"
      , title =
            """Firbush Lab Retreat"""
      , category = "Group"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 600 ]
                    { src = "static/images/news/2024-05-01-firbush.jpg"
                    , description = "Wood lab members at Firbush."
                    }
                , paragraph []
                    [ text <|
                        """Some members of the lab went on a retreat to the University
                        of Edinburgh's cabin on Loch Tay with the Wallace and Regan
                        groups. It was a fun mix of science, water sports, walking,
                        cycling and socialising.
                        """
                    ]
                ]
      }
    , { date = "2024-01-30"
      , title =
            """TIMED-Design: flexible and accessible protein sequence design
            with convolutional neural networks"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text <|
                        """Our paper on using convolutional neural networks to design
                        proteins has just been published in Protein Engineering,
                        Design and Selection. We've been working on our methods for
                        around 5 years and this was a nice opportunity to show what
                        we've been working on. It's especially nice to share it as
                        the first author, Leo Castorina, initially started working on
                        this during his undergraduate project."""
                    ]
                , paragraph []
                    [ text <|
                        """We released all our models, as well as other convolutional
                        neural networks that have been published previously, but were
                        unavailable to the community, that we implemented and retrained. 
                        Leo made a nice """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://pragmaticproteindesign.bio.ed.ac.uk/timed"
                        , label = text "user interface"
                        }
                    , text <|
                        """ where you can test the models. The paper is open access, 
                        and you can read it for free """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://doi.org/10.1093/protein/gzae002"
                        , label = text "here"
                        }
                    , text ". Well done and thank you to everyone involved."
                    ]
                ]
      }
    , { date = "2023-12-06"
      , title =
            """Christmas Night Out 2023"""
      , category = "Group"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 400 ]
                    { src = "static/images/news/2023-12-06-xmas-night-out.jpg"
                    , description = "Group photo taken during our Christmas dinner."
                    }
                , paragraph []
                    [ text <|
                        """We had a really fun day on the 6th, with a brain storming
                        session followed by a Christmas meal and some drinks.
                        Thank you to everyone in and associated with the group, 
                        it's an absolute pleasure to work with you all. Special thanks
                        to Eugene for organising the day. Merry Christmas and a Happy
                        New Year to you all!
                        """
                    ]
                ]
      }
    , { date = "2023-02-20"
      , title =
            """Differential Sensing with Arrays of De Novo Designed Peptide Assemblies"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 400 ]
                    { src = "static/images/news/2023-01-25-badass.jpeg"
                    , description = "Overview of differential sensing with designed peptides."
                    }
                , paragraph []
                    [ text <|
                        """Our work on differential sensing with designed peptides,
                        led by Dek Woolfson, has just been published in Nature
                        Communications. It has been a long and winding road to
                        get to this point. The project, known as BADASS (Barrel
                        Array Diagnostics And SenSing) to those in the know,
                        started in 2016 with a conversation between Dek and
                        Dave Tew (GSK), while I was a PDRA in Dek's lab. They
                        had come up with this idea to use our peptides to make
                        a sensing array that mimics mammalian olfaction. Dek
                        told me about this and I got very excited, partly
                        because it was just a cool idea, but also because I
                        suggested that we use machine learning (ML) to identify
                        analytes and the robotics platforms to setup the
                        assays.
                        """
                    ]
                , paragraph []
                    [ text <|
                        """Me and a few members of the lab (Will Dawson, Guto
                        Rhys and Arne Scott) tried it out, and it worked
                        spectacularly well, which made us all very concerned as
                        that's not usually how science goes! I was particularly
                        concerned as I knew that there was a risk I was
                        overfitting the data. We continued to work on it and
                        overtime we became more confident that it was working
                        as intended. Eventually, Dek was so convinced that he
                        established a company around the technology called Rosa
                        Biotech.
                        """
                    ]
                , paragraph []
                    [ text <|
                        """Over the next few years, my wife and I had two
                        children, then I got a fellowship and moved to Edinburgh to
                        start my own group. Kathryn Shelley took over the ML
                        and did a fantastic job, really rigourous work. I
                        remained involved, helping to supervise the ML work and
                        producing the manuscript.  And that's how we got here!
                        I'm really pleased how the paper turned out, well done
                        and thank you to everyone involved, especially Will,
                        Kathryn and, of course, Dek. You can access the paper 
                        """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://doi.org/10.1038/s41467-023-36024-y"
                        , label = text "here"
                        }
                    , text "."
                    ]
                ]
      }
    , { date = "2023-01-14"
      , title =
            """Benchmarking Protein Sequence Design"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text <|
                        """Leo and Rokas's work on benchmarking protein sequence design
                        methods has just been published in Bioinformatics. We've
                        developed a robust framework for evaluating the performance of
                        sequence design methods, with an aim to shine a light on the
                        biological implications of the sequences that are generated.
                        This method has been really important to guide the development
                        of our deep-learning based design methods (more on those to be
                        published soon), and hopefully it will be useful to other groups
                        too! Well done to Leo and Rokas, and thanks for your hard work!
                        """
                    ]
                , paragraph []
                    [ text <|
                        """The paper is open access, and you can read it for free """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://doi.org/10.1093/bioinformatics/btad027"
                        , label = text "here"
                        }
                    , text <|
                        """. Leo also wrote a """
                    , newTabLink
                        Style.linkStyling
                        { url =
                            "https://twitter.com/leocastorina/status/1614180921480970240?s=20&t=LqJhfQBbGBJcKuim2yF2Og"
                        , label = text "really nice Twitter thread"
                        }
                    , text <|
                        """ summarising the results, which you might find
                          interesting."""
                    ]
                ]
      }
    , { date = "2022-09-23"
      , title =
            """BBSRC sLOLA Award"""
      , category = "Funding"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text <|
                        """I'm very excited to announce that we are part of a team that
                        have been awarded a BBSRC sLOLA grant. The team is led by Nigel
                        Scrutton from University of Manchester (UoM), along with Perdita
                        Barran (UoM) and Dek Woolfson (University of Bristol). Our plan
                        is to use design and engineering to gain a deep understanding of
                        photoactive enzymes, with a view to making new enzymes that have
                        useful applications in industrial biotechnology.
                        """
                    ]
                , paragraph []
                    [ text <|
                        """You can read more about the project in the """
                    , newTabLink
                        Style.linkStyling
                        { url =
                            "https://www.ukri.org/news/19-million-to-investigate-bold-ideas-in-bioscience-research/"
                        , label = text "BBSRC's official announcement"
                        }
                    , text "."
                    ]
                ]
      }
    , { date = "2022-07-10"
      , title =
            """Royal Society Summer Exhibition"""
      , category = "Public Engagement"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width <| px 400 ]
                    { src = "/static/images/news/2022-07-10-rsse.jpeg"
                    , description = "The team standing outside the Royal Society."
                    }
                , paragraph []
                    [ text <|
                        """We were fortunate enough to be selected to present an exhibit
                        at the Royal Society Summer Science Exhibition this year. We had
                        a wonderful time telling thousands of people all about proteins
                        and protein design. For the exhibit, we developed a game that
                        demonstrated the difficulty brute forcing the sequence design
                        problem, which was a big hit, especially with the school
                        children that attended. It was a huge amount of work and really
                        tiring, but it was a great experience. Thanks to Kartic Subr for
                        suggesting that we put in an application in the first place and
                        to all the PhD students that volunteered to help with the whole
                        thing."""
                    ]
                ]
      }
    , { date = "2022-06-22"
      , title =
            """Engineered light responsive protein-protein interactions in worms!"""
      , category = "New Article"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ paragraph []
                    [ text <|
                        """Jack O'Shea's amazing work on engineering protein-protein
                        interfaces in worms to be light responsive, is now available in
                        ChemBioChem. It was a long road to get to this point, and Jack
                        put in a heroic amount of work. Well done and thank you to him!
                        You can access it online """
                    , newTabLink
                        Style.linkStyling
                        { url = "https://doi.org/10.1002/cbic.202200321"
                        , label = text "here"
                        }
                    , text "."
                    ]
                ]
      }
    , { date = "2022-06-07"
      , title =
            """Protein Folding with People!"""
      , category = "Public Engagement"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ Html.iframe
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
                , paragraph []
                    [ text <|
                        """We made a promotional video for our Royal Society Summer
                        Science exhibit, which includes a protein folding simulation
                        using people instead of amino acids! It was a lot of fun to
                        make, thanks to all the people that came out to help with the
                        demonstration!"""
                    ]
                ]
      }
    , { date = "2022-04-22"
      , title =
            """APFED 2022"""
      , category = "Conference"
      , newsContent =
            textColumn [ spacing 16, width fill ]
                [ image [ centerX, width fill ]
                    { src = "/static/images/news/2022-04-22-apfed.jpeg"
                    , description = "Conference attendees for APFED 2022."
                    }
                , paragraph []
                    [ text <| """At the beginning of the month, most of the lab attended
                        Advances in Protein Folding, Evolution, and Design (APFED) 2022.
                        The conference was organised by members of Birte Höcker's group
                        in the University of Beyreuth, and the whole event was
                        excellent, from the science to the organisation. This was the
                        first in person conference that I've attended since the start of
                        the pandemic, and for many members of the lab, it was the first
                        in person conference that they'd ever attended! There were some
                        really exciting presentations, and some even more interesting
                        discussions at the poster sessions and meals, some of which have
                        already led to new collaborations.""" ]
                , paragraph []
                    [ text <|
                        """I presented an overview of our lab's work, while Leo and Michael
                        brought along posters presenting their work on TIMED (our DNN based
                        sequence design algorithm) and DE-STRESS (our design evaluation
                        pipeline) respectively."""
                    ]
                , paragraph []
                    [ text <|
                        """I really hope there's an APFED 2023 or 2024, and if there is,
                        I'd recommend that you attend!
                        """
                    ]
                ]
      }
    , { date = "2022-01-13"
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
