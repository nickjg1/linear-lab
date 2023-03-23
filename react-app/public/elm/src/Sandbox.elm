module Sandbox exposing (..)

{--------------------------------------- IMPORTS ---------------------------------------}

import Time as Time

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
import Element.Border as Border exposing (..)

import Task

import Html exposing (Html)

import Dict exposing (..)
import IVVL exposing (..)
import Html exposing (..)
import Html.Attributes exposing (list)

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
    [ E.width E.fill, E.height E.fill
    , E.inFront (elementsMenu model)
    , E.inFront (zoomMenu model)
    ]
    ( widgetDisplay model [ E.width E.fill, E.height E.fill, E.pointer ] model.focusedEmbed
    )
  ]

zoomMenu : Model -> Element Msg
zoomMenu model =
  let
    dum = 5
  in
    E.column
      [ E.alignRight, E.alignBottom, E.moveUp 20, E.moveLeft 20]
      [ Input.button
          [ Border.width 1, E.width (E.px 30), E.height (E.px 30)
          ]
          { onPress = Just (IVVLMsg model.focusedEmbed (IVVL.ScaleGrid2D 1.5 1))
          , label = 
              E.el
                [ E.centerX ]
                ( E.text "+" )
          } 
      , Input.button
          [ Border.width 1, E.width (E.px 30), E.height (E.px 30)
          ]
          { onPress = Just (IVVLMsg model.focusedEmbed (IVVL.ScaleGrid2D 0.666 1))
          , label = 
              E.el
                [ E.centerX]
                ( E.text "-" )
          } 
      ]

elementsMenu : Model -> Element Msg
elementsMenu model =
  let
    visuals = Dict.toList model.visualElements
    targetedVisuals = 
      List.filter (\((e, _, _), _) -> (e == model.focusedEmbed)) visuals

    currentLibModel = getVisualModel model.focusedEmbed model.ivvlDict
    currentGrid = 
      case (Dict.get 1 currentLibModel.grids) of
        Nothing -> defaultGrid2D
        Just g -> g

    vecObjects = currentGrid.vectorObjects
    
    newTargetVisuals = 
      if (Dict.size vecObjects == List.length targetedVisuals)
        then targetedVisuals
        else 
          let
            vecObjectsList = Dict.toList vecObjects

            {-vecObjToVis = 
              (\(k, v) ->
                if Dict.get (k, _, _) vecObjectsList == Nothing  
                  then 5
                  else 5
              )-}

          in
            targetedVisuals

    convertToElement ( veIndex, ve ) =
      case ve of
        Vector vId _ _ -> 
          let
            vector = 
              case Dict.get vId currentGrid.vectorObjects of
                Nothing -> defaultVisVector2D
                Just vv -> vv
          in
            vectorElement model veIndex vector ve

    listOfElements = List.map convertToElement targetedVisuals
    

  in
    E.column
    [ E.width (E.fill |> maximum (round (toFloat model.width / 5))), E.height (E.fill), E.alignLeft, E.scrollbars, Background.color (E.rgb 0.7 0.5 1) ]
      ( E.el
          [ Font.size 40, E.centerX, paddingXY 0 20 ]
          ( E.text "Elements" )
        :: 
        listOfElements
        ++ 
        [creationMenu model]
      ) 

creationMenu : Model -> Element Msg
creationMenu model =
  E.column
    [ E.width E.fill, E.paddingXY 0 10 ]
    ( let
        optionButton = 
          (\title message ->
            E.el
              [ E.width E.fill ]
              ( Input.button
                  [ E.width (px 250), E.centerX, Border.width 1
                  , E.focused [ Background.color (E.rgb255 150 80 255) ]
                  ]
                  { onPress = message
                  , label = 
                      E.el
                        [ E.centerX, paddingXY 0 5 ]
                        ( E.text title )
                  }
              )
          )

        myVector =
          newVV2
              |> endTypeVV2 Directional
      in
        List.map2 
          optionButton 
          ["Add Vector", "Kill Vector", "Hire Vector", "Fire Vector"] 
          [ Just (AddElement (model.focusedEmbed, 1, 1) (IVVLMsg model.focusedEmbed (IVVL.AddVisVector2D myVector 1)))
          , Just Blank, Just Blank, Just Blank ]
    )

vectorElement : Model -> VisualElementIndex -> VisVector2D -> VisualElement -> Element Msg
vectorElement model (eKey, gKey, veKey) vv (Vector vId (vX, vY) pass) = 
  let
    veIndex = (eKey, gKey, veKey)
    visualElement = (Vector vId (vX, vY) pass)

    passClr =
      if pass
        then rgb255 0 0 0
        else rgb255 255 0 0
  in
    E.row
      [ E.centerX, Background.color (E.rgb 1 0.5 1) ]
      [ E.el
        [ E.paddingXY 10 0 ]
        ( Input.button
            ( [ Background.color (E.rgb255 238 238 238)
              , E.focused
                  [ Background.color (E.rgb255 238 23 238) ]
              , E.width (px 20), E.height (px 20)
              ]
            ) 
            { onPress = Just Blank
            , label = E.el [E.centerX, E.centerY] (E.text "X")
            } 
        )
      , E.el
          [ Font.size 24, E.paddingXY 8 0 ]
          ( E.text "vector")
      , E.el
          [ Font.size 32, E.paddingXY 8 0 ]
          ( E.text (String.fromInt vId))
      , E.el
          [ E.paddingXY 8 0 ]
          ( E.text "=")
      , E.el
          [ E.height E.fill, E.centerY, E.paddingXY 8 0, Font.size 70, Font.hairline ]
          ( E.text "[")
      , E.column
        [ ]
        [ E.el
            [ E.paddingXY 0 2 ]
            ( Input.text
              [ E.width (E.px 45), E.height (E.px 45), Font.center, Font.size 13, Font.center, Font.color passClr ] 
              { onChange = \value -> ParseVectorInput veIndex vId X value
              , text = vX
              , placeholder = Just (Input.placeholder [ E.centerX ] ( E.el [ E.centerX, E.centerY, Font.size 16 ] ( E.text "X" ) ) )
              , label = Input.labelHidden "An X vector input"
              }
            )
        , E.el
            [ E.paddingXY 0 2 ]
            ( Input.text
              [ E.width (E.px 45), E.height (E.px 45), Font.center, Font.size 13, Font.center, Font.color passClr ]
              { onChange = \value -> ParseVectorInput veIndex vId Y value
              , text = vY
              , placeholder = Just (Input.placeholder [ E.centerX ] ( E.el [ E.centerX, E.centerY, Font.size 16 ] ( E.text "X" ) ) )
              , label = Input.labelHidden "A Y vector input"
              }
            )
        ]
      , E.el
          [ E.height E.fill, E.centerY, E.paddingXY 8 0, Font.size 70, Font.hairline ]
          ( E.text "]")
      ]

widgetDisplay : Model -> List (E.Attribute Msg) -> String -> Element Msg
widgetDisplay model style widgetId = 
  E.el 
    style
    <| E.html (Widget.view (getWidgetModel widgetId model.widgetDict) (renderIVVL (getVisualModel widgetId model.ivvlDict) widgetId) )

{--------------------------------------- SETTINGS ---------------------------------------}

type XY = X | Y

type alias VisualElementIndex = (String, Int, Int) -- EmbedId, GridId, VisualElementId
type VisualElement = Vector Int (String, String) Bool -- VectorId, VectorInputString, Pass

type Msg = Tick Float
         | WindowResize Int Int
         | Blank

         | AddElement VisualElementIndex Msg
         | ParseVectorInput VisualElementIndex Int XY String

         | IVVLMsg String IVVL.Msg
         | IVVLMoveMsg String (Float, Float)

         | WidgetMsg String (Widget.Msg)

type alias Model =
  { time : Float
  , width : Int
  , height : Int 
  , widgetDict : Dict String (Widget.Model, Cmd Widget.Msg) 
  , ivvlDict : Dict String (IVVL.LibModel)

  , visualElements : Dict VisualElementIndex VisualElement

  , focusedEmbed : String
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
                                    --|> scaleG2
                                    
                                 )
                                 preset.grids
              }

    preVModel = 
      Dict.fromList [ ("embed1", preset2)
                    , ("embed2", preset)
                    ]

    visualWidgets = Dict.fromList [ ("embed1", Widget.init 1920 1080 "embed1") ]

    model =  
      { time = 0
      , width = 1920
      , height =  1080
      , widgetDict = visualWidgets
      , ivvlDict = preVModel
      , visualElements = Dict.fromList [(("embed1", 1, 1), Vector 1 ("1", "1") True)]
      , focusedEmbed = "embed1"
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
        let
          newWidgetDict = Dict.map (\k _ -> Widget.init (toFloat width) (toFloat height) k) model.ivvlDict
          newWidgetCommands = (List.map (\(k,v) -> Cmd.map (WidgetMsg k) (Tuple.second v)) (Dict.toList newWidgetDict))
        in
          ( { model | width = width, height = height, widgetDict = newWidgetDict }, Cmd.batch newWidgetCommands)
    Tick t ->
        ( { model | time = t }, Cmd.none )

    AddElement (eIndex, gIndex, veIndex) message ->
      let
        currentVisual = getVisualModel eIndex model.ivvlDict
        currentGrid = 
          case Dict.get gIndex currentVisual.grids of
            Nothing -> defaultGrid2D
            Just a -> a

        newModel = 
          case message of
            IVVLMsg _ (IVVL.AddVisVector2D _ _) -> 
              let
                nextVID = IVVL.getNextKey currentGrid.vectorObjects
                newEKey = getNextVisualElementIndex model.visualElements model.focusedEmbed gIndex

                newVisualElements = Dict.insert newEKey (Vector nextVID ("0", "0") True) model.visualElements
              in
                { model | visualElements = newVisualElements }
            _ -> model

        
      in
        ( newModel, Task.perform (\_-> message) Time.now)

    ParseVectorInput (eKey, gKey, veKey) vKey xy input ->
      let
        veIndex = (eKey, gKey, veKey)

        parseInput = String.toFloat input

        invisibilityCheck =
          case ( Dict.get veIndex model.visualElements ) of
            Nothing -> Dict.insert veIndex (Vector vKey ("0","0") True) model.visualElements
            Just _ -> model.visualElements

        updatedVectorInputs = 
          Dict.update 
          veIndex
          ( case xy of
              X -> Maybe.map (\(Vector v (x,y) p) -> Vector v (input,y) p)
              Y -> Maybe.map (\(Vector v (x,y) p) -> Vector v (x,input) p)
          )
          invisibilityCheck

        finalVectorInputs = 
          Dict.update 
          veIndex
          ( case parseInput of
              Nothing -> Maybe.map (\(Vector v (x,y) _) -> Vector v (x,y) False)
              Just _ -> Maybe.map (\(Vector v (x,y) _) -> Vector v (x,y) True)
          )
          updatedVectorInputs

        theModel = getVisualModel eKey model.ivvlDict
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

        newIVVLModelDict = Dict.insert eKey newIVVLModel model.ivvlDict
      in
        ( { model | ivvlDict = newIVVLModelDict, visualElements = finalVectorInputs }, Cmd.none )

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
    
{--------------------------------------- HELPERS ---------------------------------------}

getNextVisualElementIndex : Dict VisualElementIndex a -> String -> Int -> VisualElementIndex --Create next visual element index given the embedId and gridId
getNextVisualElementIndex theDict embedId gridId =
  let
    filteredDict = 
      Dict.filter 
        (\(eId, gId, _) _ -> eId == embedId && gId == gridId)
        theDict

    maxKeys =
      case (List.maximum (List.map third (Dict.keys filteredDict))) of
        Nothing -> 0
        Just x -> x

  in
    (embedId, gridId, maxKeys+1)

third : (a, b, c) -> c
third (a, b, c) = c


{--------------------------------------- EMBEDS AND RENDERS ---------------------------------------}
    
renderIVVL : IVVL.LibModel -> String -> List (Shape Msg)
renderIVVL model k = 
  [ finalRender model (IVVLMoveMsg k) (IVVLMsg k (ReleaseMove)) ]
    
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


