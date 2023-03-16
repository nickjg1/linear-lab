module LayoutPrototype exposing (..)

----- Imports -----

import IVVL as IVVL exposing (Msg)

import GraphicSVG exposing (..)
import GraphicSVG.Widget as Widget exposing (..)
import GraphicSVG.App exposing (..)

import Browser exposing (..)
import Browser.Events as Browser exposing (..)
import Browser.Dom as Dom exposing (..)

import Element as E exposing (..)
import Element exposing (Element)
import Element.Background as Background
import Element.Input as Input
import Element.Font as Font

-- import Task

import Html exposing (Html)

-- import Dict exposing (..)
-- import IVVL exposing (..)
-- import Html exposing (..)


----- Type declarations -----

type alias Model =
    { time : Float
    , width : Int
    , height : Int
    }

type Msg
    = WindowResize Int Int -- update the size of the window
    | Tick Float


----- Biolerplate and Controllers -----

main : Program () Model Msg
main =
  Browser.document
    { init = \ _ -> initialModel
    , view = view
    , update = update
    , subscriptions = \ _ -> Browser.onResize WindowResize
    }


view : Model -> Browser.Document Msg
view model =
  { title = "Layout Prototype"
  , body = document model
  }   

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize width height ->
            ({ model | width = width, height = height }
            , Cmd.none)
        Tick t ->
            ({ model | time = t }, Cmd.none)


----- Initialization -----

initialModel : ( Model, Cmd Msg )
initialModel = (
    { time = 0
    , width = 600 -- TODO: Get actual width/height of browser on load
    , height = 1024
    } , Cmd.none )


----- Document Body -----

document : Model -> List (Html msg)
document model = [ E.layout []
    <| E.el []
        <| E.column [] [
            E.textColumn [] [
                paragraph [] [ h1 <| E.text "Words" ]
              , paragraph [] [ p  <| E.text "more words? Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test " ]
            ]
        ]
    ]



h1 = E.el [ Font.color (Element.rgb 0.2 0.2 0.4)
          , Font.size 36
          , Font.family
              [ Font.typeface "Open Sans"
              , Font.sansSerif
              ]
          , Font.center
          , Font.heavy
          ]

p = E.el [ Font.color (Element.rgb 0.4 0.4 0.6)
          , Font.size 12
          , Font.family
              [ Font.typeface "Open Sans"
              , Font.sansSerif
              ]
          ]