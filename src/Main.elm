module Main exposing (..)

{--------------------------------------- IMPORTS ---------------------------------------}

import IVVL as IVVL exposing (Msg)

import GraphicSVG as G exposing (..)
import GraphicSVG.Widget as Widget exposing (..) 
import GraphicSVG.EllieApp as EllieApp exposing (..)
import GraphicSVG.App as App exposing (..)

import Browser exposing (..)
import Browser.Events as Browser exposing (..)
import Browser.Dom as Dom exposing (..)

import Element as E exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input

import Task

-- Default library usage
import GraphicSVG.EllieApp exposing (GetKeyState)

import Dict exposing (Dict)

{--------------------------------------- VISUAL MODEL ---------------------------------------}

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
                               [ simpleButton "Add Vector (1, 1)" (IVVL.AddVector2D (1, 1) 1)
                               , simpleButton "Remove VectorID 1" (IVVL.RemoveVector2D 1 1)
                               , simpleButton "Add Vector (2, 5)" (IVVL.AddVector2D (2, 5) 1)
                               , simpleButton "Scale VectorID 1 by 1.5" (IVVL.ScaleVector2D 1.5 1 1)
                               ]
                            ]
                    )
                 ]

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
    , vModel : IVVL.Model
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
    
testing model = 
  [ List.map IVVL.renderGrid2D (Dict.values model.grids)
      |> group
  --, [rectangle 30 15 |> filled blue, G.text "add (5,5)" |> filled white |> G.scale 0.2] |> group |> move (-90, 40) |> notifyTap (Other (IVVL.AddVector2D (5, 5) 1))
  ]
  
-- THIS IS WHERE YOU EDIT ASPECT RATIO
testingW = Widget.init 300 300 "gsvgTop"
    
{--------------------------------------- TOUCH WITH CAUTION ---------------------------------------}  
  
view model =
  { title = "My Elm UI + Widget App"
  , body = htmlBody model
  }   
 
{--------------------------------------- DO NOT TOUCH ---------------------------------------}


       
main : Program () Model Msg
main =
  Browser.document
    { init = \ flags -> (initialModel, Task.perform ( \ vp -> WindowResize (round vp.viewport.width) (round vp.viewport.height)) Dom.getViewport)
    , view = view
    , update = update
    , subscriptions = \ model -> Browser.onResize WindowResize
    }



