module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FeatherIcons
import Html exposing (Html)
import Task
import Url
import Url.Parser as UrlParser


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- {{{ Model


type alias Model =
    { appInfo : AppInfo
    , key : Nav.Key
    }


type alias AppInfo =
    { mDevice : Maybe Device
    , route : Route
    }


type Route
    = About
    | News
    | People
    | Publications
    | Tools



-- }}}
-- {{{ Init


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( model, cmds ) =
            { appInfo = { mDevice = Nothing, route = About }, key = key }
                |> update (UrlChanged url)
    in
    ( model
    , Cmd.batch
        [ cmds
        , Task.perform
            (\viewport ->
                PageResized
                    (floor viewport.scene.width)
                    (floor viewport.scene.height)
            )
            Browser.Dom.getViewport
        ]
    )



-- }}}
-- {{{ Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PageResized Int Int


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.fragment stringToRoute


stringToRoute : Maybe String -> Route
stringToRoute mString =
    case mString of
        Just string ->
            case string of
                "about" ->
                    About

                "news" ->
                    News

                "people" ->
                    People

                "publications" ->
                    Publications

                "tools" ->
                    Tools

                _ ->
                    About

        Nothing ->
            About


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { appInfo } =
            model
    in
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    -- This should be changed once self hosted
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( { model
                | appInfo =
                    { appInfo
                        | route =
                            UrlParser.parse routeParser url
                                |> Maybe.withDefault About
                    }
              }
            , Cmd.none
            )

        PageResized width height ->
            ( { model
                | appInfo =
                    { appInfo
                        | mDevice =
                            Just <|
                                classifyDevice
                                    { width = width, height = height }
                    }
              }
            , Cmd.none
            )



-- }}}
-- {{{ Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Browser.Events.onResize PageResized ]



-- }}}
-- {{{ View


view : Model -> Browser.Document Msg
view model =
    { title = "Wells Wood Research Group"
    , body = [ body model ]
    }


body : Model -> Html Msg
body model =
    let
        { appInfo } =
            model

        { mDevice } =
            appInfo
    in
    layout [ height fill, width fill ]
        (case mDevice of
            Just device ->
                case device.orientation of
                    Portrait ->
                        portraitView model

                    Landscape ->
                        landscapeView model

            Nothing ->
                portraitView model
        )



-- Portrait View


portraitView : Model -> Element Msg
portraitView model =
    column
        [ height fill
        , width fill
        ]
        [ header
        , links
        , el [ centerX ] (content model.appInfo.route)
        , footer
        ]



-- Landscape View


landscapeView : Model -> Element Msg
landscapeView model =
    el [ height fill, centerX ]
        (row [ height fill, width fill ]
            [ column
                [ height fill
                , width (px 300)
                , scrollbars
                , Background.color colours.lightGrey
                ]
                [ header, links, footer ]
            , el
                [ height fill
                , width (fill |> maximum 960)
                , scrollbars
                , Border.widthEach { defaultEach | right = 2 }
                , Border.color colours.lightGrey
                ]
                (content model.appInfo.route)
            ]
        )



-- Common


header : Element Msg
header =
    column
        [ width fill
        , padding 30
        , spacing 30
        , Background.color colours.lightGrey
        ]
        [ link
            [ centerX ]
            { url = "/"
            , label =
                column [ spacing 20 ]
                    [ paragraph
                        [ titleFont
                        , Font.size <| floor <| scaled 5
                        , Font.center
                        ]
                        [ text "Wells Wood Research Group" ]
                    , paragraph
                        [ titleFont
                        , Font.size <| floor <| scaled 2
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
        , Background.color colours.lightGrey
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
        , subHeading """Funded By"""
        , wrappedRow [ centerX ]
            [ image [ width (px 200) ]
                { src = "/static/images/epsrc.svg"
                , description = "EPSRC Logo"
                }
            ]
        ]



-- Content


content : Route -> Element msg
content route =
    case route of
        About ->
            about

        News ->
            news

        People ->
            people

        Publications ->
            publications

        Tools ->
            tools


about : Element msg
about =
    textColumn
        sectionStyling
        [ heading "About Us"
        , subHeading "Making protein design more accessible"
        , simpleText """Our research focuses on improving the accessibility and
            reliability of protein design so that it can be adopted more widely
            as a method for tackling challenges in biotechnology and synthetic
            biology. To do this, we're developing tools that apply
            machine-learning, computational modelling and structural
            bioinformatics to help guide users through the protein-design
            process."""
        , subHeading "Rigorously tested methods"
        , paragraph
            contentStyling
            [ """We apply all the methods that we create at scale in the
                laboratory, using the robotics available at Edinburgh through
                the incredible """
                |> text
            , simpleLink
                { url = "https://www.genomefoundry.org/"
                , label = "Genome Foundary"
                }
            , text """. All data and scripts are made publicly available so
that users are confident in the effectiveness of the methods and can apply them
to their fullest."""
            ]
        , subHeading "Committed to open-access research"
        , paragraph []
            [ text """Our research is publicly funded, so we are committed
                to making our outputs publicly available, including data,
                software and publications."""
            ]
        , heading "Join Us"
        , advert
        ]


advert : Element msg
advert =
    paragraph []
        [ text """Fancy automating experiments using state-of-the-art robotics?
            How about applying the newest methods in machine-learning to design
            completely novel proteins? If you're interested in joining us, """
        , simpleLink
            { url = "mailto:chris.wood@ed.ac.uk"
            , label = "get in touch"
            }
        , text " to find out more about current opportunities."
        ]



-- ###NEWS###


news : Element msg
news =
    textColumn
        sectionStyling
        (heading "News" :: List.map newsItemView newsItems)


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
        [ subHeading title
        , el [ Font.bold ] (text (date ++ ", " ++ category))
        , newsContent
        ]


newsItems : List (NewsItem msg)
newsItems =
    [ { date = "2020-01-20"
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
                        linkStyling
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
                        linkStyling
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


balasNews : List (Element msg)
balasNews =
    [ paragraph []
        [ text
            """2020 was off too a good start when I found out that the BAlaS paper
            was accepted for publication. The paper is open access and available """
        , simpleLink
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
        , simpleLink
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
    , paragraph []
        [ text
            """Chris.
            """
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
        , simpleLink
            { url = "https://biochemistry.org/"
            , label = "Biochemical Society"
            }
        , text
            """ called "Protein engineering II: from new molecules to new 
            processes". There was an amazing array of speakers from a range of
            areas, both from academia and industry. I think the highlights for
            me were: Mihriban Tuna from """
        , simpleLink
            { url = "http://www.f-star.com/"
            , label = "F-Star"
            }
        , text
            """ talking about bifunctionalised antibodies as cancer theraputics; 
            Jana Aupič, from """
        , simpleLink
            { url = "https://www.ki.si/en/departments/d12-department-of-synthetic-biology-and-immunology/"
            , label = "Roman Jerala's group"
            }
        , text
            """ in Slovenia, talking about reusing coiled coil building blocks
            while making complex protein origami; and """
        , simpleLink
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
    , paragraph []
        [ text
            """Chris.
            """
        ]
    ]



---- PEOPLE ----


people : Element msg
people =
    textColumn
        sectionStyling
        ([ heading "People"
         , personView chrisWellsWood
         , subHeading "PhD Students"
         ]
            ++ (phdStudents
                    |> List.map personView
               )
            ++ [ subHeading "Undergraduate Project Students"
               ]
            ++ (undergraduateStudents
                    |> List.map personView
               )
            ++ [ heading "Join Us"
               , advert
               ]
        )


type alias Person msg =
    { pictureUrl : String
    , name : String
    , associatedLab : Maybe (Element msg)
    , email : Maybe String
    , twitter : Maybe String
    , github : Maybe String
    , bio : Element msg
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
            , simpleLink
                { url = "https://woolfsonlab.wordpress.com/"
                , label = "Prof. Dek Woolfson"
                }
            , text
                """, where he worked on developing and applying tools for
                computational protein design. In 2018 he was awarded an
                EPSRC postdoctoral fellowship and moved to the University of
                Edinburgh to establish his research group."""
            ]
    }


phdStudents : List (Person msg)
phdStudents =
    [ { pictureUrl = "/static/images/people/jonathanmorales.jpg"
      , name = "Jonathan Morales-Espinoza"
      , associatedLab =
            simpleLink
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
      }
    , { pictureUrl = "/static/images/people/jackoshea.jpg"
      , name = "Jack O'Shea"
      , associatedLab =
            simpleLink
                { url = "https://www.ed.ac.uk/discovery-brain-sciences/our-staff/research-groups/sebastian-greiss"
                , label = "Greiss Lab, UoE"
                }
                |> Just
      , email = Just "j.m.o'shea@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Nothing
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
      }
    , { pictureUrl = "/static/images/people/mattscheier.jpg"
      , name = "Matthew Scheier"
      , associatedLab =
            simpleLink
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
                , simpleLink
                    { url = "http://horsfall.bio.ed.ac.uk"
                    , label = "Horsfall Lab"
                    }
                , text
                    """, and is working in the Wells Wood lab to engineer
                    encapsulins to enable novel metal nanoparticle synthesis
                    using synthetic biology."""
                ]
      }
    ]


undergraduateStudents : List (Person msg)
undergraduateStudents =
    [ { pictureUrl = "/static/images/people/leocastorina.jpg"
      , name = "Leonardo Castorina"
      , associatedLab = Nothing
      , email = Just "s1622572@sms.ed.ac.uk"
      , twitter = Nothing
      , github = Just "https://github.com/universvm"
      , bio =
            paragraph []
                [ text
                    """Leonardo is currently in the final year of his
                    undergraduate degree in Biotechnology at
                    the University of Edinburgh. He is interested in Biology,
                    Chemistry and Computer Science, especially the intersection
                    of these three with Machine Learning."""
                ]
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
                [ subHeading person.name
                , case person.associatedLab of
                    Just associatedLab ->
                        paragraph [ Font.italic ]
                            [ text "In association with the "
                            , associatedLab
                            ]

                    Nothing ->
                        none
                , person.bio
                ]
            ]
        ]



---- PUBLICATIONS ----


publications : Element msg
publications =
    textColumn
        sectionStyling
        (heading "Publications"
            :: List.map publicationView (List.reverse allPublications)
        )


type alias Publication =
    { title : String
    , link : String
    , preprintLink : Maybe String
    , authors : String
    , journal : String
    , volume : String
    , pages : String
    , year : String
    }


publicationView : Publication -> Element msg
publicationView publication =
    column
        [ paddingXY 0 30
        , spacing 15
        , Border.widthEach
            { defaultEach | top = 1 }
        ]
        [ newTabLink
            linkStyling
            { url = publication.link, label = subHeading publication.title }
        , simpleText publication.authors
        , simpleText <|
            publication.journal
                ++ ", "
                ++ publication.volume
                ++ ", "
                ++ publication.pages
                ++ ", "
                ++ publication.year
                ++ "."
        , case publication.preprintLink of
            Just preprintLink ->
                newTabLink
                    linkStyling
                    { url = preprintLink
                    , label =
                        el [] (text "Preprint")
                    }

            Nothing ->
                none
        ]


allPublications : List Publication
allPublications =
    [ { authors =
            """Wood, CW*; Bruning, M; Ibarra, AA; Bartlett, Gail J; Thomson, AR;
            Sessions, RB; Brady, RL; Woolfson, DN*"""
      , title =
            """CCBuilder: an interactive web-based tool for building, designing
            and assessing coiled-coil protein assemblies"""
      , link = "https://academic.oup.com/bioinformatics/article/30/21/3029/2422267"
      , preprintLink = Nothing
      , journal = "Bioinformatics"
      , volume = "30"
      , pages = "3029-3035"
      , year = "2014"
      }
    , { authors =
            """Thomson, AR; Wood, CW; Burton, AJ; Bartlett, GJ; Sessions, RB;
            Brady, RL; Woolfson, DN*"""
      , title = "Computational design of water-soluble α-helical barrels"
      , link = "http://science.sciencemag.org/content/346/6208/485"
      , preprintLink = Nothing
      , journal = "Science"
      , volume = "346"
      , pages = "485-488"
      , year = "2014"
      }
    , { authors =
            """Woolfson, DN*; Bartlett, GJ; Burton, AJ; Heal, JW; Niitsu, A;
            Thomson, AR; Wood, CW"""
      , title =
            """De novo protein design: how do we expand into the universe of
            possible protein structures?"""
      , link = "https://www.sciencedirect.com/science/article/pii/S0959440X1500069X"
      , preprintLink = Nothing
      , journal = "Current opinion in structural biology"
      , volume = "33"
      , pages = "16-26"
      , year = "2015"
      }
    , { authors =
            """Burgess, NC; Sharp, TH; Thomas, F; Wood, CW; Thomson, AR;
            Zaccai, NR; Brady, RL; Serpell, LC; Woolfson, DN*"""
      , title = "Modular design of self-assembling peptide-based nanotubes"
      , link = "https://pubs.acs.org/doi/abs/10.1021/jacs.5b03973"
      , preprintLink = Nothing
      , journal = "Journal of the American Chemical Society"
      , volume = "137"
      , pages = "10554-10562"
      , year = "2015"
      }
    , { authors =
            "Wood, Christopher W*; Heal, Jack W; Thomson, Andrew R; "
                ++ "Bartlett, Gail J; Ibarra, Amaurys Á; Brady, R Leo; Sessions, "
                ++ "Richard B; Woolfson, Derek N*"
      , title =
            """ISAMBARD: an open-source computational environment for
            biomolecular analysis, modelling and design"""
      , link = "https://academic.oup.com/bioinformatics/article/33/19/3043/3861331"
      , preprintLink = Nothing
      , journal = "Bioinformatics"
      , volume = "33"
      , pages = "3043-3050"
      , year = "2017"
      }
    , { authors = "Wood, Christopher W; Woolfson, Derek N*"
      , title = "CCBuilder 2.0: Powerful and accessible coiled‐coil modeling"
      , link = "https://onlinelibrary.wiley.com/doi/full/10.1002/pro.3279"
      , preprintLink = Nothing
      , journal = "Protein Science"
      , volume = "27"
      , pages = "103-111"
      , year = "2018"
      }
    , { authors =
            """Pellizzoni, MM; Schwizer, F; Wood, CW; Sabatino, V; Cotelle, Y;
            Matile, S; Woolfson, DN; Ward, TR*"""
      , title =
            "Chimeric Streptavidins as Host Proteins for Artificial "
                ++ "Metalloenzymes"
      , link = "https://pubs.acs.org/doi/abs/10.1021/acscatal.7b03773"
      , preprintLink = Nothing
      , journal = "ACS Catalysis"
      , volume = "8"
      , pages = "1476-1484"
      , year = "2018"
      }
    , { authors =
            "Heal, JW; Bartlett, GJ; Wood, CW; Thomson, AR; Woolfson, DN*"
      , title =
            """Applying graph theory to protein structures: an atlas of coiled
            coils"""
      , link = "https://academic.oup.com/bioinformatics/article/34/19/3316/4990824"
      , preprintLink = Nothing
      , journal = "Bioinformatics"
      , volume = "34"
      , pages = "3316-3323"
      , year = "2018"
      }
    , { authors =
            """Rhys, GG; Wood, CW; Lang, EJM; Mulholland, AJ; Brady, RL;
            Thomson, AR; Woolfson, DN*"""
      , title =
            """Maintaining and breaking symmetry in homomeric coiled-coil
          assemblies"""
      , journal = "Nature Communications"
      , link = "https://www.nature.com/articles/s41467-018-06391-y"
      , preprintLink = Nothing
      , volume = "9"
      , pages = "4132"
      , year = "2018"
      }
    , { authors =
            """Rhys, GG; Wood, CW; Beesley, JL; Zaccai, NR; Burton, AJ;
            Brady, RL; Thomson, AR; Woolfson, DN*"""
      , title = "Navigating the structural landscape of de novo α-helical bundles"
      , journal = "Journal of the American Chemical Society"
      , link = "https://pubs.acs.org/doi/10.1021/jacs.8b13354"
      , preprintLink = Just "https://www.biorxiv.org/content/early/2018/12/21/503698"
      , volume = "141"
      , pages = "8787-8797"
      , year = "2019"
      }
    , { authors =
            """Juan, J; Baker, EG; Wood, CW; Bath, J; Woolfson, DN*;
            Turberfield, AJ*"""
      , title =
            """Peptide Assembly Directed and Quantified Using Megadalton DNA
          Nanostructures"""
      , journal = "ACS Nano"
      , link = "https://pubs.acs.org/doi/10.1021/acsnano.9b04251"
      , preprintLink = Nothing
      , volume = "13"
      , pages = "9927-9935"
      , year = "2019"
      }
    , { authors =
            """Wood, CW*; Ibarra, AA; Bartlett, GJ; Wilson, AJ; Woolfson, DN;
            Sessions RB*"""
      , title =
            """BAlaS: fast, interactive and accessible computational alanine-scanning
            using BudeAlaScan"""
      , journal = "Bioinformatics"
      , link = "https://doi.org/10.1093/bioinformatics/btaa026"
      , preprintLink = Nothing
      , volume = "XXX"
      , pages = "XXX-XXX"
      , year = "2020"
      }
    ]


tools : Element msg
tools =
    column
        (contentStyling ++ [ height fill, width (fill |> maximum 960) ])
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
                , simpleLink
                    { url =
                        "http://www.bris.ac.uk/biochemistry/research/bude"
                    , label = "BUDE"
                    }
                , text " and "
                , simpleLink
                    { url =
                        "https://github.com/isambard-uob/isambard"
                    , label = "ISAMBARD"
                    }
                , text """, users can download and run the scanning engine
locally when they need to scale up analysis."""
                ]
      , backgroundImageLink = Just "/static/images/tools/balas.jpg"
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
                , simpleLink
                    { url =
                        "mailto:chris.wood@ed.ac.uk"
                    , label = "Chris Wood"
                    }
                , text
                    """ if you're interested in getting involved."""
                ]
      , backgroundImageLink = Nothing
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
                , simpleLink
                    { url =
                        "http://science.sciencemag.org/content/346/6208/485"
                    , label = "α-helical barrels"
                    }
                , text "."
                ]
      , backgroundImageLink = Just "/static/images/tools/ccbuilder.jpg"
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
                Background.color colours.lightGrey
        ]
        (subHeading tool.name
            :: (case toolLinks of
                    ( Nothing, Nothing ) ->
                        []

                    ( Just app, Nothing ) ->
                        [ row [ spacing 10 ]
                            [ simpleLink { url = app, label = "Application" } ]
                        ]

                    ( Nothing, Just source ) ->
                        [ row [ spacing 10 ]
                            [ simpleLink { url = source, label = "Source" } ]
                        ]

                    ( Just app, Just source ) ->
                        [ row [ spacing 10 ]
                            [ simpleLink { url = app, label = "Application" }
                            , simpleLink { url = source, label = "Source" }
                            ]
                        ]
               )
            ++ [ tool.description ]
        )



-- Custom Elements


heading : String -> Element msg
heading label =
    paragraph
        [ titleFont
        , Font.size <| floor <| scaled 4
        ]
        [ text label ]


subHeading : String -> Element msg
subHeading label =
    paragraph
        [ titleFont
        , Font.size <| floor <| scaled 2
        ]
        [ text label ]


links : Element msg
links =
    column [ width fill ]
        [ navLink "About" "/#about"
        , navLink "News" "/#news"
        , navLink "People" "/#people"
        , navLink "Publications" "/#publications"
        , navLink "Tools" "/#tools"
        ]


navLink : String -> String -> Element msg
navLink label url =
    link
        [ width fill
        , padding 10
        , mouseOver [ Background.color colours.grey ]
        , Background.color colours.darkGrey
        , Font.color colours.white
        , Font.center
        , contentFont
        ]
        { url = url
        , label = text label
        }



-- Styles


colours =
    { black = rgb 0 0 0
    , white = rgb 1 1 1
    , lightGrey = rgb 0.7 0.7 0.7
    , grey = rgb 0.5 0.5 0.5
    , darkGrey = rgb 0.3 0.3 0.3
    }


scaled : Int -> Float
scaled =
    modular 22.0 1.25


titleFont : Element.Attribute msg
titleFont =
    Font.family
        [ Font.external
            { name = "Poiret One"
            , url = "https://fonts.googleapis.com/css?family=Poiret+One"
            }
        , Font.serif
        ]


contentFont : Element.Attribute msg
contentFont =
    Font.family
        [ Font.external
            { name = "Raleway"
            , url = "https://fonts.googleapis.com/css?family=Raleway"
            }
        , Font.sansSerif
        ]


contentStyling : List (Element.Attribute msg)
contentStyling =
    [ contentFont
    , Font.size <| floor <| scaled 1
    , Background.color colours.white
    ]


sectionStyling : List (Element.Attribute msg)
sectionStyling =
    contentStyling
        ++ [ height fill
           , width fill
           , padding 25
           , spacing 25
           ]


linkStyling : List (Element.Attribute msg)
linkStyling =
    [ Font.color colours.darkGrey
    , Font.underline
    ]


simpleText : String -> Element msg
simpleText contentText =
    paragraph [] [ text contentText ]


simpleLink : { label : String, url : String } -> Element msg
simpleLink { label, url } =
    newTabLink
        linkStyling
        { url = url
        , label = text label
        }


defaultEach =
    { left = 0, right = 0, top = 0, bottom = 0 }



-- }}}
