module Main exposing (..)

{--------------------------------------- IMPORTS ---------------------------------------}

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

import Task

import Html exposing (Html)

import Dict exposing (..)
import IVVL exposing (..)


{--------------------------------------- VISUAL MODEL ---------------------------------------}

htmlBody : Model -> List (Html Msg)
htmlBody model = [ E.layout 
                    [E.width (E.px model.width) , E.height (E.px model.height)]
                    (
                    E.el [ E.width (E.px model.width) , E.height (E.px model.height) ]
                           <| E.row 
                            []
                            [ E.el [E.width (E.px 500)]
                              <| E.html (Widget.view model.widgetModel (testing model.vModel) )
                            , E.el [ E.width E.fill, E.centerY ]
                              <| column
                               [ E.height E.fill ]
                               [ simpleButton "Remove VectorID 1" (IVVL.RemoveVector2D 1 1)
                               , simpleButton "Scale VectorID 1 by 1.5" (IVVL.ScaleVector2D 1.5 1 1)
                               , simpleButton "Add Vector (2, 5)" (IVVL.AddVector2D (2, 5) 1)
                               , simpleButton "Add Dashed Vector (-2, 5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(-2, 5), lineType=IVVL.Dashed 1 } 1)
                               , simpleButton "Add Dotted Vector (-2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(-2, -5), lineType=IVVL.Dotted 1 } 1)
                               , simpleButton "Add Directional Dashed Vector (2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(2, -5), lineType=IVVL.Dotted 1, endType=Directional } 1)
                               ]
                            ]
                    )
                 ]

simpleButton : String -> (IVVL.Msg) -> Element Msg
simpleButton button_txt button_message =
    Input.button
        [ Background.color (E.rgb255 238 238 238)
        , E.focused
            [ Background.color (E.rgb255 238 23 238) ]
        ]
        { onPress = Just (Other button_message)
        , label = E.text button_txt
        }

{--------------------------------------- SETTINGS ---------------------------------------}

type Msg = Tick Float
         | WindowResize Int Int
         | Other IVVL.Msg


type alias Model =
    { time : Float
    , width : Int
    , height : Int 
    , widgetModel : Widget.Model 
    , vModel : IVVL.LibModel
    }
    
initialModel : Model
initialModel =
    { time = 0
    , width = 600
    , height = 1024 
    , widgetModel = Tuple.first testingW
    , vModel = IVVL.init
    }
    
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize width height ->
            ({ model | width = width, height = height }
            , Cmd.none)
        Tick t ->
            ({ model | time = t }, Cmd.none)
        Other messageForParent -> ( { model | vModel = Tuple.first (IVVL.update messageForParent model.vModel) }, Cmd.none)
    
{--------------------------------------- EMBEDS AND RENDERS ---------------------------------------}
    
testing : IVVL.LibModel -> List (Shape userMsg)
testing model = 
  [ List.map IVVL.renderGrid2D (Dict.values model.grids)
      |> group
  --, GraphicSVG.text (Debug.toString (Maybe.withDefault IVVL.defaultGrid2D (Dict.get 1 model.grids)).vectorObjects) |> filled red |> GraphicSVG.scale 0.25 |> move (-50, -40)
  --, [rectangle 30 15 |> filled blue, G.text "add (5,5)" |> filled white |> G.scale 0.2] |> group |> move (-90, 40) |> notifyTap (Other (IVVL.AddVector2D (5, 5) 1))
  ]
  
-- THIS IS WHERE YOU EDIT ASPECT RATIO
testingW : (Widget.Model, Cmd Widget.Msg)
testingW = Widget.init 150 150 "embed1"
    
{--------------------------------------- TOUCH WITH CAUTION ---------------------------------------}  

view : Model -> { title : String, body : List (Html Msg) } 
view model =
  { title = "My Elm UI + Widget App"
  , body = htmlBody model
  }   
 
{--------------------------------------- DO NOT TOUCH ---------------------------------------}

main : Program () Model Msg
main =
  Browser.document
    { init = \ _ -> (initialModel, Task.perform ( \ vp -> WindowResize (round vp.viewport.width) (round vp.viewport.height)) Dom.getViewport)
    , view = view
    , update = update
    , subscriptions = \ _ -> Browser.onResize WindowResize
    }



