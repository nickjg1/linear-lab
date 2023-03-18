module Sandbox exposing (..)

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
import Element.Input as Input exposing (..)
import Element.Font as Font exposing (..)

import Task

import Html exposing (Html)

import Dict exposing (..)
import IVVL exposing (..)
import Html exposing (..)
import Html.Attributes exposing (default)

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
htmlBody model = 
  [ E.layout 
    [ E.height (E.px 0) ]
    ( E.column
      [ E.width (E.px model.width) ]
      [ ( E.row 
          [ E.height (E.px 550), E.centerX, E.centerY ]
          [ widgetDisplay model "embed1" 500
          , E.column 
            [ E.padding 75 ]--E.width (E.px 200) ]
            [ E.el 
              [ E.centerX, padding 10 ] 
              ( E.text "Vectors" )
            , E.row
              [ E.centerX ]
              ( let
                  theVisualModel = getVisualModel "embed1" model.ivvlDict
                  theGrid = case Dict.get 1 theVisualModel.grids of
                              Nothing -> defaultGrid2D
                              Just x -> x

                  --numberOfVectors = Dict.size theGrid.vectorObjects

                  myVector = 
                    newVV2
                      |> endTypeVV2 Directional         

                  theVectors = Dict.toList theGrid.vectorObjects
                  allInputs = List.map (vectorXYInput model.vectorInputs "embed1" 1) (List.map (Tuple.first) theVectors)
                  final =
                    allInputs
                    ++
                    [simpleButton "+" (IVVL.AddVisVector2D myVector 1) "embed1"]
                in
                  final
              ) 
            ]
          ]
        )
      ]
    )
  ]

vectorXYInput : VectorInputs -> String -> Int -> Int -> Element Msg
vectorXYInput vi embedID gridKey key =
  E.column
  []
  ( let
      thisInput =
        case (Dict.get (embedID, gridKey, key) vi) of
          Nothing -> ("0", "0", True)
          Just val -> val

      xInput = (\(x, _, _) -> x) thisInput
      yInput = (\(_, y, _) -> y) thisInput
      feedback = (\(_, _, z) -> z) thisInput

      color =
        if (feedback == True)
          then Font.color (E.rgb 0 0 0)
          else Font.color (E.rgb 255 0 0)
    in
      [ Input.text
        [ E.height (E.px 45), E.width (E.px 45), Font.center, Font.size 16, color ] 
        { onChange = ParseVectorInput embedID gridKey key X
        , text = xInput
        , placeholder = Just (Input.placeholder [ E.centerX ] ( E.el [ E.centerX, E.centerY, Font.size 14 ] ( E.text "X" ) ) )
        , label = Input.labelHidden "An X input"
        }
      , Input.text
        [ E.height (E.px 45), E.width (E.px 45), Font.center, Font.size 16, color ] 
        { onChange = ParseVectorInput embedID gridKey key Y
        , text = yInput
        , placeholder = Just (Input.placeholder [ E.centerX ] ( E.el [ E.centerX, E.centerY, Font.size 14 ] ( E.text "Y" ) ) )
        , label = Input.labelHidden "A Y input"
        }
      ]
  )

simpleButton : String -> (IVVL.Msg) -> String -> Element Msg
simpleButton button_txt button_message id =
    Input.button
        [ Background.color (E.rgb255 238 238 238)
        , E.focused
            [ Background.color (E.rgb255 238 23 238) ]
        , E.width (px 20), E.height (px 20)
        ]
        { onPress = Just (IVVLMsg id button_message)
        , label = E.el [E.centerX, E.centerY] (E.text button_txt)
        }

widgetDisplay : Model -> String -> Int -> Element Msg
widgetDisplay model widgetId size = 
  E.el 
    [E.height (E.px size), E.width (E.px size)]
    <| E.html (Widget.view (getWidgetModel widgetId model.widgetDict) (testing (getVisualModel widgetId model.ivvlDict) widgetId) )

{--------------------------------------- SETTINGS ---------------------------------------}

type XY = X | Y
type alias VectorInputs = Dict (String, Int, Int) (String, String, Bool)

type Msg = Tick Float
         | WindowResize Int Int
         | Blank

         | ParseVectorInput String Int Int XY String

         | IVVLMsg String IVVL.Msg
         | IVVLMoveMsg String (Float, Float)

         | WidgetMsg String (Widget.Msg)

type alias Model =
  { time : Float
  , width : Int
  , height : Int 
  , widgetDict : Dict String (Widget.Model, Cmd Widget.Msg) 
  , ivvlDict : Dict String (IVVL.LibModel)

  , vectorInputs : VectorInputs
  }
    
initialModel : (Model, Cmd Msg)
initialModel =
  let

    preset = IVVL.init
    preset2 = { preset | grids = Dict.insert 1 
                                 ( newG2
                                   |> IVVL.addVectorG2 
                                     ( newVV2
                                       |> setVV2 (1, 1)
                                       |> endTypeVV2 Directional
                                     ) 
                                 )
                                 preset.grids
              }

    preVModel = 
      Dict.fromList [ ("embed1", preset2)
                    , ("embed2", IVVL.init)
                    ]

    model =  
      { time = 0
      , width = 600
      , height = 1024 
      , widgetDict = visualWidgets
      , ivvlDict = preVModel
      , vectorInputs = Dict.fromList [(("embed1", 1, 1), ("1", "1", True))]
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
        ( { model | width = width, height = height }, Cmd.none)
    Tick t ->
        ( { model | time = t }, Cmd.none )


    ParseVectorInput embedKey gKey vKey xy input ->
      let
        parseInput = String.toFloat input

        invisibilityCheck =
          case (Dict.get (embedKey, gKey, vKey) model.vectorInputs) of
            Nothing -> Dict.insert (embedKey, gKey, vKey) ("0", "0", True) model.vectorInputs
            Just _ -> model.vectorInputs

        updatedVectorInputs = 
          Dict.update 
          (embedKey, gKey, vKey)
          ( case xy of
              X -> Maybe.map (\(_, y, p) -> (input, y, p))
              Y -> Maybe.map (\(x, _, p) -> (x, input, p))
          )
          invisibilityCheck

        finalVectorInputs = 
          Dict.update 
          (embedKey, gKey, vKey)
          ( case parseInput of
              Nothing -> Maybe.map (\(x, y, _) -> (x, y, False))
              Just _ -> Maybe.map (\(x, y, _) -> (x, y, True))
          )
          updatedVectorInputs

        theModel = getVisualModel embedKey model.ivvlDict
        theGrid = 
          case (Dict.get gKey (theModel.grids) ) of
            Nothing -> defaultGrid2D
            Just x -> x

        currentVisVectorValue =
          case (Dict.get vKey (theGrid.vectorObjects) ) of
            Nothing -> defaultVisVector2D
            Just x -> x

        newVectorValue =
          case parseInput of
            Nothing -> currentVisVectorValue.vector
            Just val ->
              case xy of
                X -> (val, second currentVisVectorValue.vector)
                Y -> (first currentVisVectorValue.vector, val)        

        newVisVectorValue = { currentVisVectorValue | vector = newVectorValue }
        
        newVectorObjects = Dict.insert vKey newVisVectorValue theGrid.vectorObjects

        newGrid = { theGrid | vectorObjects = newVectorObjects }

        newGridDict = Dict.insert gKey newGrid theModel.grids

        newIVVLModel = { theModel | grids = newGridDict }

        newIVVLModelDict = Dict.insert embedKey newIVVLModel model.ivvlDict
      in
        ( { model | ivvlDict = newIVVLModelDict, vectorInputs = finalVectorInputs }, Cmd.none )

    IVVLMsg k messageForParent ->
      let
        originalDict = model.ivvlDict
        updatedDict = Dict.update k ( Maybe.map (\value -> Tuple.first (IVVL.update messageForParent value)) ) originalDict 
      in
        ( { model | ivvlDict = updatedDict }, Cmd.none )
    
    IVVLMoveMsg k (x, y) -> 
      let
        originalDict = model.ivvlDict
        updatedDict = Dict.update k (Maybe.map (\value -> Tuple.first (IVVL.update (IVVL.HoldMove (x, y)) value))) originalDict
      in
        ( { model | ivvlDict = updatedDict }, Cmd.none )

    WidgetMsg k wMsg -> 
      let
        (newWState, wCmd) = Widget.update wMsg (getWidgetModel k model.widgetDict)

        newWidgetModel = Dict.update k (Maybe.map (\_ -> (newWState, wCmd))) model.widgetDict
      in
        ( { model | widgetDict = newWidgetModel}, Cmd.map (WidgetMsg k) wCmd)

    Blank -> ( model, Cmd.none )
    
{--------------------------------------- EMBEDS AND RENDERS ---------------------------------------}
    
testing : IVVL.LibModel -> String -> List (Shape Msg)
testing model k = 
  [ finalRender model (IVVLMoveMsg k) (IVVLMsg k (ReleaseMove))
  ]
  
-- THIS IS WHERE YOU EDIT ASPECT RATIO
visualWidgets : Dict String (Widget.Model, Cmd Widget.Msg)
visualWidgets = Dict.fromList [ ("embed1", Widget.init 500 500 "embed1")]
    
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



