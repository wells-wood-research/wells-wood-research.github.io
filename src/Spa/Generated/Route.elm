module Spa.Generated.Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Top
    | News
    | NotFound
    | People
    | Publications
    | Tools


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routes


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map News (Parser.s "news")
        , Parser.map NotFound (Parser.s "not-found")
        , Parser.map People (Parser.s "people")
        , Parser.map Publications (Parser.s "publications")
        , Parser.map Tools (Parser.s "tools")
        ]


toString : Route -> String
toString route =
    let
        segments : List String
        segments =
            case route of
                Top ->
                    []
                
                News ->
                    [ "news" ]
                
                NotFound ->
                    [ "not-found" ]
                
                People ->
                    [ "people" ]
                
                Publications ->
                    [ "publications" ]
                
                Tools ->
                    [ "tools" ]
    in
    segments
        |> String.join "/"
        |> String.append "/"