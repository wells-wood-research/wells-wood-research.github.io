module Shared.Style exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font


colours =
    { black = rgb 0 0 0
    , white = rgb 1 1 1
    , lightGrey = rgb 0.7 0.7 0.7
    , grey = rgb 0.5 0.5 0.5
    , darkGrey = rgb 0.3 0.3 0.3
    }


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
