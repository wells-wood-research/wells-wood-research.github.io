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
            :: (List.indexedMap publicationView allPublications |> List.reverse)
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


publicationView : Int -> Publication -> Element msg
publicationView pubNumber publication =
    column
        [ paddingXY 0 30
        , spacing 15
        , Border.widthEach
            { defaultEach | top = 1 }
        ]
        [ newTabLink
            Style.linkStyling
            { url = publication.link
            , label =
                String.fromInt (pubNumber + 1)
                    ++ ". "
                    ++ publication.title
                    |> Style.subHeading
            }
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
            Woolfson DN*
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
    , { authors = "Stam MJ and Wood CW*"
      , title =
            """DE-STRESS: A user-friendly web application for the evaluation
            of protein designs
            """
      , journal = "Protein Engineering, Design and Selection"
      , link = "https://doi.org/10.1093/protein/gzab029"
      , preprintLink = Just "https://doi.org/10.1101/2021.04.28.441790"
      , volume = "34"
      , pages = "gzab029"
      , year = "2021"
      }
    , { authors =
            """O’Shea JM, Goutou A, Brydon J, Sethna CR, Wood CW, Greiss S*
            """
      , title =
            """Generation of photocaged nanobodies for in vivo applications
            using genetic code expansion and computationally guided protein engineering
            """
      , journal = "ChemBioChem"
      , link = "https://doi.org/10.1002/cbic.202200321"
      , preprintLink = Just "https://doi.org/10.1101/2021.04.16.440193"
      , volume = "_"
      , pages = "e202200321"
      , year = "2022"
      }
    , { authors = "Castorina LV, Petrenas R, Subr K and Wood CW*"
      , title =
            """PDBench: Evaluating Computational Methods for Protein Sequence Design"""
      , journal = "Bioinformatics"
      , link = "https://doi.org/10.1093/bioinformatics/btad027"
      , preprintLink = Just "https://arxiv.org/abs/2109.07925"
      , volume = "Accepted Manuscript"
      , pages = "btad027"
      , year = "2023"
      }
    , { authors =
            """Dawson WM*, Shelley KL, Fletcher JM, Scott DA, Lombardi L, Rhys GG,
            LaGambina TJ, Obst U, Burton AJ, Cross JA, Davies G, Martin FJO, Wiseman FJ,
            Brady RL, Tew D, Wood CW*, Woolfson DN*
            """
      , title =
            """Differential sensing with arrays of de novo designed peptide assemblies
            """
      , link = "https://doi.org/10.1038/s41467-023-36024-y"
      , preprintLink = Nothing
      , journal = "Nature Communications"
      , volume = "14"
      , pages = "383"
      , year = "2023"
      }
    , { authors =
            """Gurusaran M, Biemans JJ, Wood CW, Davies OR*
            """
      , title =
            """Molecular insights into LINC complex architecture through the crystal 
            structure of a luminal trimeric coiled-coil domain of SUN1
            """
      , link = "https://doi.org/10.3389/fcell.2023.1144277"
      , preprintLink = Nothing
      , journal = "Frontiers in Cell and Developmental Biology"
      , volume = "11"
      , pages = "-"
      , year = "2023"
      }
    , { authors =
            """Castorina LV, Ünal SM, Subr K, Wood CW*
            """
      , title =
            """TIMED-Design: Flexible and Accessible Protein Sequence Design
            with Convolutional Neural Networks
            """
      , link = "https://doi.org/10.1093/protein/gzae002"
      , preprintLink = Nothing
      , journal = "Protein Engineering, Design and Selection"
      , volume = "37"
      , pages = "gzae002"
      , year = "2024"
      }
    , { authors =
            """Stam MJ, Oyarzún DA, Laohakunakorn N, Wood CW*
            """
      , title =
            """Large scale analysis of predicted protein structures
            links model features to in vivo behaviour
            """
      , link = "https://doi.org/10.1101/2024.04.10.588835"
      , preprintLink = Nothing
      , journal = "Biorxiv"
      , volume = "-"
      , pages = "-"
      , year = "2024"
      }
    , { authors =
            """O'Shea JM*, Richardson A, Doerner PW, Wood CW*
            """
      , title =
            """Computational Design of Periplasmic Binding Protein Biosensors
            Guided by Molecular Dynamics
            """
      , link = "https://doi.org/10.1371/journal.pcbi.1012212"
      , preprintLink = Just "https://www.biorxiv.org/content/10.1101/2023.11.10.566541v1"
      , journal = "PLoS Computational Biology"
      , volume = "-"
      , pages = "-"
      , year = "2024"
      }
    , { authors =
            """Thornton EL, Paterson SM, Stam MJ, Wood CW, Laohakunakorn N, Regan L*
            """
      , title =
            """Applications of cell free protein synthesis in protein design"""
      , link = "https://doi.org/10.1002/pro.5148"
      , preprintLink = Nothing
      , journal = "Protein Science"
      , volume = "33"
      , pages = "e5148"
      , year = "2024"
      }
    , { authors =
            """MacAulay A, Klemencic E, Brewster R, Unal SM, Notari E, Wood CW, Jarvis A, Campopiano DJ
            """
      , title =
            """Installation of an organocatalyst into a protein scaffold creates an artificial Stetterase"""
      , link = "https://doi.org/10.1039/D4CC05182C"
      , preprintLink = Nothing
      , journal = "Chemical Communications"
      , volume = "-"
      , pages = "-"
      , year = "2024"
      }
    , { authors =
            """Shrimpton-Phoenix E*, Notari E, Kluonis T, Wood CW*"""
      , title =
            """drMD: Molecular Dynamics for Experimentalists"""
      , link = "https://doi.org/10.1016/j.jmb.2024.168918"
      , preprintLink = Just "https://doi.org/10.1101/2024.10.29.620839"
      , journal = "Journal of Molecular Biology"
      , volume = "-"
      , pages = "-"
      , year = "2024"
      }
    , { authors =
            """Notari E, Wood CW, Michael J"""
      , title =
            """Assessment of the Topology and Oligomerisation States of Coiled Coils Using Metadynamics with Conformational Restraints"""
      , link = "https://doi.org/10.1021/acs.jctc.4c01695"
      , preprintLink = Just "https://doi.org/10.26434/chemrxiv-2024-t02df"
      , journal = "Journal of Chemical Theory and Computation"
      , volume = "-"
      , pages = "-"
      , year = "2025"
      }
    , { authors =
            """Chronowska M, Stam MJ, Woolfson DN, Di Costanzo LF, Wood CW*
            """
      , title =
            """The Protein Design Archive (PDA): insights from 40 years of protein design"""
      , link = "https://www.nature.com/articles/s41587-025-02607-x"
      , preprintLink = Just "https://doi.org/10.1101/2024.09.05.611465"
      , journal = "Nature Biotechnology"
      , volume = "-"
      , pages = "-"
      , year = "2025"
      }
    ]
