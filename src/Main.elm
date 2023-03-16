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
import Html exposing (..)

{--------------------------------------- HELPER ---------------------------------------}

failureWidget : (Widget.Model, Cmd Widget.Msg)
failureWidget = Widget.init 150 150 "failure"

getWidgetModel : comparable -> Dict comparable (Widget.Model, Cmd Widget.Msg) -> Widget.Model
getWidgetModel index dict =
  let
    maybe = Dict.get index dict
    final = 
      case maybe of
          Just m -> m
          Nothing -> failureWidget
  in
    Tuple.first final

getVisualModel : comparable -> Dict comparable (IVVL.LibModel) -> IVVL.LibModel
getVisualModel index dict =
  let
    maybe = Dict.get index dict
    final =
      case maybe of
        Just m -> m
        Nothing -> IVVL.init
  in
    final


{--------------------------------------- VISUAL MODEL ---------------------------------------}

htmlBody : Model -> List (Html Msg)
htmlBody model = [ E.layout [E.height (E.px 0)]
                    ( E.el []
                      <| E.column [E.width (E.px model.width)]
                      [ ( E.el [E.height (E.px 550), E.centerX, E.centerY]
                            <| E.row []
                              [ E.el [E.width (E.px 500)]
                                <| E.html (Widget.view (getWidgetModel "embed1" model.widgetModel) (testing (getVisualModel "embed1" model.vModel) "embed1") )
                              , E.el []
                                <| column [ ]
                                [ simpleButton "Remove VectorID 1" (IVVL.RemoveVector2D 1 1) "embed1"
                                , simpleButton "Scale VectorID 1 by 1.5" (IVVL.ScaleVector2D 1.5 1 1) "embed1"
                                , simpleButton "Add Vector (2, 5)" (IVVL.AddVector2D (2, 5) 1) "embed1"
                                , simpleButton "Add Dashed Vector (-2, 5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(-2, 5), lineType=IVVL.Dashed 1 } 1) "embed1"
                                , simpleButton "Add Dotted Vector (-2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(-2, -5), lineType=IVVL.Dotted 1 } 1) "embed1"
                                , simpleButton "Add Directional Dashed Vector (2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(2, -5), lineType=IVVL.Dotted 1, endType=Directional } 1) "embed1"
                                , simpleButton "Add Grid" (IVVL.AddGrid2D defaultGrid2D) "embed1"
                                , simpleButton "Zoom into Grid 1 by 2" (IVVL.ScaleGrid2D 2 1) "embed1"
                                , simpleButton "Zoom into ALL Grids by 2" (IVVL.ScaleGrid2DAll 2) "embed1"
                                , simpleButton "Zoom out of Grid 1 by 2" (IVVL.ScaleGrid2D 0.5 1) "embed1"
                                , simpleButton "Zoom out of ALL Grids by 2" (IVVL.ScaleGrid2DAll 0.5) "embed1"
                                ]
                              ]
                          )
                      , ( E.el [E.height (E.px 500), E.centerX, E.centerY]
                            <| E.row 
                              []
                              [ E.el [E.width (E.px 500)]
                                <| E.html (Widget.view (getWidgetModel "embed2" model.widgetModel) (testing (getVisualModel "embed2" model.vModel) "embed2") )
                              , E.el [ E.width E.fill, E.centerY ]
                                <| column
                                [ E.height E.fill ]
                                [ simpleButton "Remove VectorID 1" (IVVL.RemoveVector2D 1 1) "embed2"
                                , simpleButton "Scale VectorID 1 by 1.5" (IVVL.ScaleVector2D 1.5 1 1) "embed2"
                                , simpleButton "Add Vector (2, 5)" (IVVL.AddVector2D (2, 5) 1) "embed2"
                                , simpleButton "Add Dashed Vector (-2, 5)" (IVVL.AddVisVector2D IVVL.myVec 1) "embed2"
                                , simpleButton "Add Dotted Vector (-2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(-2, -5), lineType=IVVL.Dotted 1 } 1) "embed2"
                                , simpleButton "Add Directional Dashed Vector (2, -5)" (IVVL.AddVisVector2D { defaultVisVector2D | vector=(2, -5), lineType=IVVL.Dotted 1, endType=Directional } 1) "embed2"
                                , simpleButton "Add Grid" (IVVL.AddGrid2D defaultGrid2D) "embed2"
                                , simpleButton "Zoom into Grid 1 by 2" (IVVL.ScaleGrid2D 2 1) "embed2"
                                , simpleButton "Zoom into ALL Grids by 2" (IVVL.ScaleGrid2DAll 2) "embed2"
                                , simpleButton "Zoom out of Grid 1 by 2" (IVVL.ScaleGrid2D 0.5 1) "embed2"
                                , simpleButton "Zoom out of ALL Grids by 2" (IVVL.ScaleGrid2DAll 0.5) "embed2"
                                ]
                              ]
                          )
                      ]
                    )
                 ]

simpleButton : String -> (IVVL.Msg) -> String -> Element Msg
simpleButton button_txt button_message id =
    Input.button
        [ Background.color (E.rgb255 238 238 238)
        , E.focused
            [ Background.color (E.rgb255 238 23 238) ]
        ]
        { onPress = Just (Other id button_message)
        , label = E.text button_txt
        }

{--------------------------------------- SETTINGS ---------------------------------------}

type Msg = Tick Float
         | WindowResize Int Int
         | Other String IVVL.Msg

         | OtherMove String (Float, Float)

         | WidgetMsg String (Widget.Msg)


type alias Model =
    { time : Float
    , width : Int
    , height : Int 
    , widgetModel : Dict String (Widget.Model, Cmd Widget.Msg) 
    , vModel : Dict String (IVVL.LibModel)
    }
    
initialModel : (Model, Cmd Msg)
initialModel =
  let
    preVModel = Dict.fromList [ ("embed1", IVVL.init)
                              , ("embed2", IVVL.init)
                              ]

    model =  { time = 0
             , width = 600
             , height = 1024 
             , widgetModel = visualWidgets
             , vModel = preVModel
             }

    widgetCommands = (List.map (\(k,v) -> Cmd.map (WidgetMsg k) (Tuple.second v)) (Dict.toList visualWidgets))
    viewPortCommand = Task.perform ( \ vp -> WindowResize (round vp.viewport.width) (round vp.viewport.height)) Dom.getViewport
    finalCmd = Cmd.batch (widgetCommands ++ [viewPortCommand])
  in
  ( model, finalCmd )
    
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize width height ->
            ({ model | width = width, height = height }
            , Cmd.none)
        Tick t ->
            ({ model | time = t }, Cmd.none)


        Other k messageForParent -> (
          let
            originalDict = model.vModel
            updatedDict = Dict.update k ( Maybe.map (\value -> Tuple.first (IVVL.update messageForParent value)) ) originalDict 
          in
            { model | vModel = updatedDict}, Cmd.none )
        
        OtherMove k (x, y) -> 
          let
            originalDict = model.vModel
            updatedDict = Dict.update k (Maybe.map (\value -> Tuple.first (IVVL.update (IVVL.HoldMove (x, y)) value))) originalDict
          in
            ( {model | vModel = updatedDict}, Cmd.none)

        WidgetMsg k wMsg -> 
          let
            (newWState, wCmd) = Widget.update wMsg (getWidgetModel k model.widgetModel)

            newWidgetModel = Dict.update k (Maybe.map (\_ -> (newWState, wCmd))) model.widgetModel
          in
            ( { model | widgetModel = newWidgetModel}, Cmd.map (WidgetMsg k) wCmd)
    
{--------------------------------------- EMBEDS AND RENDERS ---------------------------------------}
    
testing : IVVL.LibModel -> String -> List (Shape Msg)
testing model k = 
  [ finalRender model (OtherMove k) (Other k (ReleaseMove))
  ]
  
-- THIS IS WHERE YOU EDIT ASPECT RATIO
visualWidgets : Dict String (Widget.Model, Cmd Widget.Msg)
visualWidgets = Dict.fromList [ ("embed1", Widget.init 500 500 "embed1")
                              , ("embed2", Widget.init 500 500 "embed2")]
    
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
    { init = \ _ -> initialModel
    , view = view
    , update = update
    , subscriptions = \ _ -> Browser.onResize WindowResize
    }



