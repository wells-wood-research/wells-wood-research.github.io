module Shared.Advert exposing (advert)

import Element exposing (..)
import Shared.Style as Style


advert : Element msg
advert =
    paragraph []
        [ text """Fancy automating experiments using state-of-the-art robotics?
            How about applying the newest methods in machine-learning to design
            completely novel proteins? If you're interested in joining us, """
        , Style.simpleLink
            { url = "mailto:chris.wood@ed.ac.uk"
            , label = "get in touch"
            }
        , text " to find out more about current opportunities."
        ]
