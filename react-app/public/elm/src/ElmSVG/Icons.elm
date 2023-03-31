module ElmSVG.Icons exposing (..)

import Svg
import VirtualDom exposing (Attribute, attribute)


drag : List (Attribute msg) -> Svg.Svg msg
drag attrs = Svg.node "svg" ([attribute "fill" "#000000", attribute "width" "800px", attribute "height" "800px", attribute "viewBox" "0 0 32 32", attribute "id" "icon", attribute "xmlns" "http://www.w3.org/2000/svg"] ++ attrs) [ Svg.node "defs" ([]) [ Svg.node "style" ([]) [ Svg.text(".cls-1{fill:none;}")]], Svg.node "title" ([]) [ Svg.text("drag--vertical")], Svg.node "polygon" ([attribute "points" "4 20 15 20 15 26.17 12.41 23.59 11 25 16 30 21 25 19.59 23.59 17 26.17 17 20 28 20 28 18 4 18 4 20"]) [], Svg.node "polygon" ([attribute "points" "11 7 12.41 8.41 15 5.83 15 12 4 12 4 14 28 14 28 12 17 12 17 5.83 19.59 8.41 21 7 16 2 11 7"]) [], Svg.node "rect" ([attribute "id" "_Transparent_Rectangle_", attribute "data-name" "&lt;Transparent Rectangle&gt;", attribute "class" "cls-1", attribute "width" "32", attribute "height" "32"]) []]