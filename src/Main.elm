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



-- Model


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



-- Update


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



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Browser.Events.onResize PageResized ]



-- View


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
                paragraph
                    [ titleFont
                    , Font.size <| floor <| scaled 5
                    , Font.center
                    ]
                    [ text "Wells Wood Research Group" ]
            }
        , newTabLink
            [ centerX ]
            { url = "https://www.ed.ac.uk/"
            , label =
                image [ width (px 200) ]
                    { src = "/static/images/uoe.svg"
                    , description = "University of Edinburgh Logo"
                    }
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
        [ heading """Funded By"""
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
                to making our outputs publicly available, including data
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
        ([ heading "News" ] ++ List.map newsItemView newsItems)


type alias NewsItem msg =
    { date : String
    , title : String
    , category : String
    , newsContent : Element msg
    }


newsItemView : NewsItem msg -> Element msg
newsItemView { date, title, category, newsContent } =
    column [ spacing 10 ]
        [ subHeading title
        , el [ Font.bold ] (text (date ++ ", " ++ category))
        , newsContent
        ]


newsItems : List (NewsItem msg)
newsItems =
    [ { date = "2019-05-08"
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
                    , text """, where we created mutants of a stable hexameric
                coiled coil and found that they adopted the anti-parallel
                conformation. We then discovered that certain mutants would
                revert back to the parallel hexamer structure when the pH was
                altered. Finally we used negative design to stablise the
                anti-parallel conformation, which resulted in apCC-Tet, a
                hyper-thermostable, anti-parallel tetramer. apCC-Tet is a robust
                scaffold that can now be used for applications in protein
                engineering and synthetic biology."""
                    ]
                , paragraph []
                    [ text """This was the last paper I worked on before leaving
                Dek Woolfson's group in Bristol and it was pretty satisfying to see
                it come together as it contains the first peptide that I ever
                made in the lab. Huge thank you to my co-first author, Guto
                Rhys, it was great fun working with him on the paper.""" ]
                ]
      }
    ]


people : Element msg
people =
    textColumn
        sectionStyling
        ([ heading "People"
         ]
            ++ List.map personView allPeople
            ++ [ heading "Join Us"
               , advert
               ]
        )


type alias Person msg =
    { pictureUrl : String
    , name : String
    , email : Maybe String
    , twitter : Maybe String
    , github : Maybe String
    , bio : Element msg
    }


allPeople : List (Person msg)
allPeople =
    [ { pictureUrl = "/static/images/people/chriswellswood.jpg"
      , name = "Chris Wells Wood"
      , email = Just "chris.wood@ed.ac.uk"
      , twitter = Just "https://twitter.com/ChrisWellsWood"
      , github = Just "https://github.com/ChrisWellsWood"
      , bio =
            paragraph []
                [ text """Chris took his undergraduate degree in Molecular and Cellular
Biology at the University of Glasgow. He then went on to undertake a PhD and
postdoc in the lab of """
                , simpleLink
                    { url = "https://woolfsonlab.wordpress.com/"
                    , label = "Prof. Dek Woolfson"
                    }
                , text """, where he worked on developing and applying tools for
computational-protein design. In 2018 he was awarded an EPSRC postdoctoral
fellowship and moved to the University of Edinburgh to establish his research
group."""
                ]
      }
    ]


personView : Person msg -> Element msg
personView person =
    column [ spacing 30 ]
        [ wrappedRow [ spacing 30 ]
            [ column [ spacing 10 ]
                [ el [ centerX ] (subHeading person.name)
                , image [ centerX, width (px 250) ]
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
            , person.bio
            ]
        ]


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
    column [ spacing 10 ]
        [ newTabLink
            linkStyling
            { url = publication.link, label = subHeading publication.title }
        , case publication.preprintLink of
            Just preprintLink ->
                newTabLink
                    linkStyling
                    { url = preprintLink
                    , label =
                        el [ Font.bold ] (text "Preprint")
                    }

            Nothing ->
                none
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
        ]


allPublications : List Publication
allPublications =
    [ { authors =
            "Wood, Christopher W*; Bruning, Marc; Ibarra, Amaurys A; "
                ++ "Bartlett, Gail J; Thomson, Andrew R; Sessions, Richard B; "
                ++ "Brady, R Leo; Woolfson, Derek N*"
      , title =
            "CCBuilder: an interactive web-based tool for building, "
                ++ "designing and assessing coiled-coil protein assemblies"
      , link = "https://academic.oup.com/bioinformatics/article/30/21/3029/2422267"
      , preprintLink = Nothing
      , journal = "Bioinformatics"
      , volume = "30"
      , pages = "3029-3035"
      , year = "2014"
      }
    , { authors =
            "Thomson, Andrew R; Wood, Christopher W; Burton, Antony J; "
                ++ "Bartlett, Gail J; Sessions, Richard B; Brady, R Leo; "
                ++ "Woolfson, Derek N*"
      , title = "Computational design of water-soluble α-helical barrels"
      , link = "http://science.sciencemag.org/content/346/6208/485"
      , preprintLink = Nothing
      , journal = "Science"
      , volume = "346"
      , pages = "485-488"
      , year = "2014"
      }
    , { authors =
            "Woolfson, Derek N*; Bartlett, Gail J; Burton, Antony J; "
                ++ "Heal, Jack W; Niitsu, Ai; Thomson, Andrew R; Wood, "
                ++ "Christopher W"
      , title =
            "De novo protein design: how do we expand into the universe of "
                ++ "possible protein structures?"
      , link = "https://www.sciencedirect.com/science/article/pii/S0959440X1500069X"
      , preprintLink = Nothing
      , journal = "Current opinion in structural biology"
      , volume = "33"
      , pages = "16-26"
      , year = "2015"
      }
    , { authors =
            "Burgess, Natasha C; Sharp, Thomas H; Thomas, Franziska; "
                ++ "Wood, Christopher W; Thomson, Andrew R; Zaccai, Nathan R; "
                ++ "Brady, R Leo; Serpell, Louise C; Woolfson, Derek N*"
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
            "ISAMBARD: an open-source computational environment for "
                ++ "biomolecular analysis, modelling and design"
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
            "Pellizzoni, Michela M; Schwizer, Fabian; Wood, "
                ++ "Christopher W; Sabatino, Valerio; Cotelle, Yoann; "
                ++ "Matile, Stefan; Woolfson, Derek N; Ward, Thomas R*"
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
            "Heal, Jack W; Bartlett, Gail J; Wood, Christopher W; "
                ++ "Thomson, Andrew R; Woolfson, Derek N*"
      , title =
            "Applying graph theory to protein structures: an atlas of "
                ++ "coiled coils"
      , link = "https://academic.oup.com/bioinformatics/article/34/19/3316/4990824"
      , preprintLink = Nothing
      , journal = "Bioinformatics"
      , volume = "34"
      , pages = "3316-3323"
      , year = "2018"
      }
    , { authors =
            "Rhys, Guto G; Wood, Christopher W; Lang, Eric JM; "
                ++ "Mulholland, Adrian J; Brady, R Leo; Thomson, Andrew R; "
                ++ "Woolfson, Derek N*"
      , title = "Maintaining and breaking symmetry in homomeric coiled-coil assemblies"
      , journal = "Nature Communications"
      , link = "https://www.nature.com/articles/s41467-018-06391-y"
      , preprintLink = Nothing
      , volume = "9"
      , pages = "4132"
      , year = "2018"
      }
    , { authors =
            "Rhys, Guto G; Wood, Christopher W; Beesley, Joseph L; "
                ++ "Zaccai, Nathan R; Burton, Antony J; Brady, R Leo; "
                ++ "Thomson, Andrew R; Woolfson, Derek N*"
      , title = "Navigating the structural landscape of de novo α-helical bundles"
      , journal = "Journal of the American Chemical Society"
      , link = "https://pubs.acs.org/doi/10.1021/jacs.8b13354"
      , preprintLink = Just "https://www.biorxiv.org/content/early/2018/12/21/503698"
      , volume = "141"
      , pages = "8787-8797"
      , year = "2019"
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
    , backgroundImageLink : String
    }


allTools : List (Tool msg)
allTools =
    [ { name = "CCBuilder/CCBuilder 2"
      , application = Just "http://coiledcoils.chm.bris.ac.uk/ccbuilder2/builder"
      , source = Just "https://github.com/woolfson-group/ccbuilder2"
      , description =
            paragraph []
                [ text """CCBuilder is a user-friendly web application for
creating atomistic models of coiled coils and collagen. It can accurately model
almost all architectures of coiled coils observed in nature, as well more
unusual structures like """
                , simpleLink
                    { url =
                        "http://science.sciencemag.org/content/346/6208/485"
                    , label = "α-helical barrels"
                    }
                , text "."
                ]
      , backgroundImageLink = "/static/images/tools/ccbuilder.jpg"
      }
    , { name = "BAlaS"
      , application = Just "http://coiledcoils.chm.bris.ac.uk/balas"
      , source = Just "https://github.com/woolfson-group/balas"
      , description =
            paragraph []
                [ text """BAlaS is a fast, interactive web tool for performing
computational alanine-scanning mutagenesis. It has a simple user interface that
allows users to easily submit jobs and visualise results. Powered by """
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
      , backgroundImageLink = "/static/images/tools/balas.jpg"
      }
    , { name = "ISAMBARD"
      , application = Nothing
      , source = Just "https://github.com/woolfson-group/balas"
      , description =
            paragraph []
                [ text """ISAMBARD (Intelligent System for Analysis, Model
Building And Rational Design) is a Python library for structural analysis and
rational design of biomolecules, with a particular focus on parametric
modelling of proteins."""
                ]
      , backgroundImageLink = "/static/images/tools/isambard.jpg"
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
        , Background.image tool.backgroundImageLink
        ]
        ([ subHeading tool.name ]
            ++ (case toolLinks of
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
        [ contentFont
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


bullet : String -> Element msg
bullet string =
    text <| "→ " ++ string


defaultEach =
    { left = 0, right = 0, top = 0, bottom = 0 }
