module Pages.Publications exposing (Model, Msg, Params, page)

import Element exposing (..)
import Element.Border as Border
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
    { title = "Publications"
    , body = [ publications ]
    }


publications : Element msg
publications =
    textColumn
        Style.sectionStyling
        (Style.heading "Publications"
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
            Style.linkStyling
            { url = publication.link, label = Style.subHeading publication.title }
        , Style.simpleText publication.authors
        , Style.simpleText <|
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
                    Style.linkStyling
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
            """Wood CW*, Bruning M, Ibarra AA, Bartlett Gail J, Thomson AR,
            Sessions RB, Brady RL, Woolfson DN*"""
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
            """Thomson AR, Wood CW, Burton AJ, Bartlett GJ, Sessions RB,
            Brady RL, Woolfson DN*"""
      , title = "Computational design of water-soluble α-helical barrels"
      , link = "http://science.sciencemag.org/content/346/6208/485"
      , preprintLink = Nothing
      , journal = "Science"
      , volume = "346"
      , pages = "485-488"
      , year = "2014"
      }
    , { authors =
            """Woolfson DN*, Bartlett GJ, Burton AJ, Heal JW, Niitsu A,
            Thomson AR, Wood CW"""
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
            """Burgess NC, Sharp TH, Thomas F, Wood CW, Thomson AR,
            Zaccai NR, Brady RL, Serpell LC, Woolfson DN*"""
      , title = "Modular design of self-assembling peptide-based nanotubes"
      , link = "https://pubs.acs.org/doi/abs/10.1021/jacs.5b03973"
      , preprintLink = Nothing
      , journal = "Journal of the American Chemical Society"
      , volume = "137"
      , pages = "10554-10562"
      , year = "2015"
      }
    , { authors =
            """Wood CW*, Heal JW, Thomson AR, Bartlett GJ, Ibarra AÁ, Brady RL,
            Sessions RB, Woolfson DN*"
            """
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
    , { authors = "Wood CW and Woolfson DN"
      , title = "CCBuilder 2.0: Powerful and accessible coiled‐coil modeling"
      , link = "https://onlinelibrary.wiley.com/doi/full/10.1002/pro.3279"
      , preprintLink = Nothing
      , journal = "Protein Science"
      , volume = "27"
      , pages = "103-111"
      , year = "2018"
      }
    , { authors =
            """Pellizzoni MM, Schwizer F, Wood CW, Sabatino V, Cotelle Y,
            Matile S, Woolfson DN, Ward TR*"""
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
            "Heal JW, Bartlett GJ, Wood CW, Thomson AR, Woolfson DN*"
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
            """Rhys GG, Wood CW, Lang EJM, Mulholland AJ, Brady RL,
            Thomson AR, Woolfson DN*"""
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
            """Rhys GG, Wood CW, Beesley JL, Zaccai NR, Burton AJ,
            Brady RL, Thomson AR, Woolfson DN*"""
      , title = "Navigating the structural landscape of de novo α-helical bundles"
      , journal = "Journal of the American Chemical Society"
      , link = "https://pubs.acs.org/doi/10.1021/jacs.8b13354"
      , preprintLink = Just "https://www.biorxiv.org/content/early/2018/12/21/503698"
      , volume = "141"
      , pages = "8787-8797"
      , year = "2019"
      }
    , { authors =
            """Juan J, Baker EG, Wood CW, Bath J, Woolfson DN*,
            Turberfield AJ*"""
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
            """Wood CW*, Ibarra AA, Bartlett GJ, Wilson AJ, Woolfson DN,
            Sessions RB*"""
      , title =
            """BAlaS: fast, interactive and accessible computational alanine-scanning
            using BudeAlaScan"""
      , journal = "Bioinformatics"
      , link = "https://doi.org/10.1093/bioinformatics/btaa026"
      , preprintLink = Nothing
      , volume = "36"
      , pages = "2917-2919"
      , year = "2020"
      }
    , { authors =
            """Galloway JM, Bray HEV, Shoemark DK, Hodgson LR, Coombs J, Mantell JM,
            Rose RS, Ross JF, Morris C, Harniman RL, Wood CW, Arthur C, Verkade P,
            Woolfson DN
            """
      , title =
            """De Novo Designed Peptide and Protein Hairpins Self‐Assemble into Sheets
            and Nanoparticles
            """
      , journal = "Small"
      , link = "https://doi.org/10.1002/smll.202100472"
      , preprintLink = Just "https://www.biorxiv.org/content/10.1101/2020.08.14.251462v2"
      , volume = "17"
      , pages = "2100472"
      , year = "2021"
      }
    , { authors =
            """O’Shea JM, Goutou A, Sethna C, Wood CW, Greiss S
            """
      , title =
            """Preprint: Generation of photocaged nanobodies for in vivo applications
            using genetic code expansion and computationally guided protein engineering
            """
      , journal = "Biorxiv"
      , link = "https://doi.org/10.1101/2021.04.16.440193"
      , preprintLink = Nothing
      , volume = "_"
      , pages = "_"
      , year = "2021"
      }
    , { authors = "Stam MJ and Wood CW"
      , title =
            """Preprint: DE-STRESS: A user-friendly web application for the evaluation
            of protein designs
            """
      , journal = "Biorxiv"
      , link = "https://doi.org/10.1101/2021.04.28.441790"
      , preprintLink = Nothing
      , volume = "_"
      , pages = "_"
      , year = "2021"
      }
    ]
