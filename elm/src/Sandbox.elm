module Sandbox exposing (third)

{--------------------------------------- IMPORTS ---------------------------------------}

import Time as Time

import IVVL as IVVL exposing (Msg)

import GraphicSVG exposing (..)
import GraphicSVG.Widget as Widget exposing (..)
import GraphicSVG.App exposing (..)

import Browser exposing (..)
import Browser.Events as BEvents exposing (..)
import Browser.Dom as Dom exposing (..)

import Element as E exposing (..)
import Element exposing (Element)
import Element.Background as Background
import Element.Input as Input exposing (..)
import Element.Font as Font exposing (..)
import Element.Border as Border exposing (..)
import Element.Cursor as Cursor exposing (..)
import Element.Events as EEvents exposing (..)

import Json.Decode as Decode exposing (..)
import Hex as Hex

import Task

import Html exposing (..)
import Html.Events as HEvents exposing (..)
import Html.Attributes as Attributes exposing (..)

import Dict exposing (..)
import IVVL exposing (..)

import ElmSVG.Icons as Icon exposing (..)
import Svg as Svg exposing (..)
 
{------------------------------------------------------------------------------
                             _    _ _______ __  __ _      
                            | |  | |__   __|  \/  | |     
                            | |__| |  | |  | \  / | |     
                            |  __  |  | |  | |\/| | |      
                            | |  | |  | |  | |  | | |____ 
                            |_|  |_|  |_|  |_|  |_|______|
 ------------------------------------------------------------------------------}

{--------------------------------------- Final ---------------------------------------}

htmlOutput : Model -> List (Html Msg)
htmlOutput model = 
  let
    decodeScrollEvent = 
      Decode.field "deltaY" Decode.float
  in
    [ E.layout 
        [ E.width E.fill, E.height E.fill
        , E.inFront (elementsMenu model)
        , E.inFront (zoomMenu model)
        , EEvents.onMouseUp ResizeElementMenuUp
        ]
        ( E.row
            [ E.width E.fill, E.height E.fill ]
            [ widgetDisplay model 
                [ E.width E.fill, E.height E.fill, Cursor.move
                , htmlAttribute 
                  ( HEvents.on "wheel" (Decode.map (Scroll) decodeScrollEvent)
                  )
                ] 
                model.focusedEmbed
            ]
        )
    ]

{--------------------------------------- MENUS ---------------------------------------}

zoomMenu : Model -> Element Msg
zoomMenu model =
  E.column
    [ E.alignRight, E.alignBottom, E.moveUp 20, E.moveLeft 20, E.spacingXY 0 10 ]
    [ Input.button
        [ E.width (E.px 45), E.height (E.px 45), Border.rounded 5, Border.width 5, Border.color (getColor "offWhite" colorDict)
        , Background.color (getColor "offWhite" colorDict)
        ]
        { onPress = Just (IVVLMsg model.focusedEmbed (IVVL.ScaleG2 1.5 model.focusedGrid))
        , label = 
            E.el
              [ E.centerX, getFont "Assistant", Font.color (getColor "offBlack" colorDict), Font.size 40, Font.bold, E.moveUp 3 ]
              ( E.text "+" )
        } 
    , Input.button
        [ E.width (E.px 45), E.height (E.px 45), Border.rounded 5, Border.width 5, Border.color (getColor "offWhite" colorDict)
        , Background.color (getColor "offBlack" colorDict)
        ]
        { onPress = Just (IVVLMsg model.focusedEmbed (IVVL.ScaleG2 0.666 model.focusedGrid))
        , label = 
            E.el
              [ E.centerX, getFont "Assistant", Font.color (getColor "offWhite" colorDict), Font.size 40, Font.bold, E.moveUp 7 ]
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
      case (Dict.get model.focusedGrid currentLibModel.grids) of
        Nothing -> defaultGrid2D
        Just g -> g

    convertToElement ( veIndex, ve ) =
      case ve of
        Vector vID _ _ -> 
          let
            vector = 
              case Dict.get vID currentGrid.vectorObjects of
                Nothing -> defaultVisVector2D
                Just vv -> vv
          in
            vectorElement model veIndex vector ve
        VectorSum vID _ _ -> 
          let
            vector =
              case Dict.get vID currentGrid.vectorObjects of
                Nothing -> defaultVisVector2D
                Just vv -> vv
          in
            vectorSumElement model veIndex vector ve
        VectorDifference vID _ _ ->
          let
            vector =
              case Dict.get vID currentGrid.vectorObjects of
                Nothing -> defaultVisVector2D
                Just vv -> vv
          in
            vectorDifferenceElement model veIndex vector ve

    listOfElements = List.map convertToElement targetedVisuals
    
  in
    E.row
      [ E.width ((E.px model.elementMenuWidth) |> E.maximum model.elementMenuWidthMax), E.height (E.fill)
      , E.alignLeft, Background.color (getColor "background" model.elementColorDict)
      , E.inFront
          ( E.el
              [ E.rotate (pi/2), E.centerY, E.moveRight (toFloat model.elementMenuWidth - 19), EEvents.onMouseDown ResizeElementMenuDown, Cursor.ewResize ]
              ( E.html 
                ( Icon.drag
                    [ Attributes.attribute "fill" (colorToHex (getColor "elementText" model.elementColorDict))
                    , Attributes.attribute "width" "40px"
                    , Attributes.attribute "height" "40px"
                    ]
                )  
              ) 
          )
      , E.behindContent
          ( E.el
              [ E.height E.fill, E.width (E.px 10), E.moveRight (toFloat model.elementMenuWidth) ]
              ( E.el
                  [ E.height E.fill, E.width (E.px 2), Background.color (getColor "elementText" model.elementColorDict)
                  , E.behindContent 
                      ( E.el 
                          [ E.height E.fill, E.width (E.px 2), Border.glow (getColor "background" model.elementColorDict) 55 ]
                          ( E.none )
                      )
                  , E.inFront
                      ( E.none
                      )
                  ]
                  ( E.none )
              )
          )
      ]
      [ E.row
          [ E.scrollbarX, E.centerX, E.width E.fill, E.height E.fill, E.spacingXY 0 10 ] 
          [ E.column
            [ E.centerX, E.width E.fill, E.height E.fill, E.spacingXY 0 10 ]
            [ E.el 
                [ Font.size 40, Font.bold, E.paddingEach { top = 40, right = 0, bottom = 30, left = 30 }
                , getFont "Inconsolata", Font.color (getColor "elementText" model.elementColorDict)
                ] 
                ( E.text "ELEMENTS" )
            , E.el
                [ E.width ( E.px (round (toFloat model.elementMenuWidth/5*4)) |> E.minimum (250) ), E.height (E.px 2), E.centerX
                , Background.color (getColor "elementText" model.elementColorDict)
                ]
                ( E.text "" )
            , E.column
                [ E.width E.shrink, E.height E.fill, E.scrollbarY, E.centerX, E.spacingXY 0 20 ]
                ( listOfElements )
            , E.el
                [ E.width ( E.px (round (toFloat model.elementMenuWidth/5*4)) |> E.minimum (250) ), E.height (E.px 2), E.centerX
                , Background.color (getColor "elementText" model.elementColorDict)
                ]
                ( E.text "" )
            , creationMenu model
            ]
          ]
      
      ]

{--------------------------------------- SUB-MENUS ---------------------------------------}

creationMenu : Model -> Element Msg
creationMenu model =
  let
    optionButton = 
      (\title message ->
        E.row
          [ E.width E.fill ]
          [ E.el
            [ E.width E.fill ]
            ( Input.button
              [ E.width (px 200), E.height (px 50), E.centerX, Border.width 1, Border.rounded 10
              -- , E.focused [ Background.color (getColor "buttonBackground" model.elementColorDict) ]
              , Background.color (getColor "buttonBackground" model.elementColorDict)
              ]
              { onPress = message
              , label = 
                  E.el
                    [ E.centerX, paddingXY 0 5, getFont "Assistant", Font.bold, Font.size 20 ]
                    ( E.text title )
              }
            )
          ]
      )

    myVector =
      newVV2
        |> endTypeVV2 Directional
        |> colorVV2 (getColor "defaultVector" model.elementColorDict)  
        |> lineTypeVV2 (Solid 4)
  in
    E.column
      [ E.width E.fill, E.paddingXY 0 20 ]
      [ E.column
        [ E.width E.fill, E.paddingXY 20 0, E.spacingXY 0 10 ]
        [ E.row
          [ E.centerX, E.spacingXY 10 0 ]
          ( List.map2 optionButton 
              ["⁺↗ Add Vector"]--, "ˣ↗ Scale Vector"]
              [ Just (AddElement VectorType (IVVLMsg model.focusedEmbed (IVVL.AddVVectorG2 myVector model.focusedGrid)))
              , Nothing
              ]
          )
        , E.row
          [ E.centerX, E.spacingXY 10 0 ]
          ( List.map2 optionButton 
              ["↖⁺↗ Vector Sum" , "↖⁻↗ Vector Difference"] 
              [ Just (AddElement VectorSumType (IVVLMsg model.focusedEmbed (IVVL.AddVVectorG2 myVector model.focusedGrid)))
              , Just (AddElement VectorDifferenceType (IVVLMsg model.focusedEmbed (IVVL.AddVVectorG2 myVector model.focusedGrid))) ]
          )
        ]
      ]

{--------------------------------------- ELEMENTS ---------------------------------------}

elementHeader : Model -> Element Msg
elementHeader model = E.none

vectorElement : Model -> VisualElementIndex -> VisVector2D -> VisualElement -> Element Msg
vectorElement model (eID, gID, veID) vv2 ve = 
  case ve of
    Vector vID (iX, iY) pass ->
      let
        veIndex = (eID, gID, veID)
        passClr =
          if pass
            then (getColor "elementText" model.elementColorDict)
            else rgb255 255 120 120

        visualElement = (Vector vID (iX, iY) pass)
      in
        ( E.row
            [ E.centerX, E.spacingXY 10 0, E.paddingXY 5 0, rounded 10 ]
            [ E.el
                []
                ( Input.button
                    ( [ E.width (px 20), E.height (px 20)
                      , Background.color (E.rgba 0 0 0 0)
                      , E.inFront
                          ( E.html 
                            ( Icon.trash
                                [ Attributes.attribute "fill" (colorToHex (getColor "elementText" model.elementColorDict))
                                , Attributes.attribute "width" "20px"
                                , Attributes.attribute "height" "20px"
                                ]
                            ) 
                          )
                      ]
                    ) 
                    { onPress = Just (RemoveElement veIndex (IVVLMsg model.focusedEmbed (IVVL.RemoveVVectorG2 vID model.focusedGrid)))
                    , label = E.none
                    } 
                )
            , E.el
                [ Font.size 24, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                ( E.text "vector" )
            , E.el
                [ Font.size 32, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                ( E.text (String.fromInt veID) )
            , E.el
                [ Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                ( E.text "=" )
            , E.el
                [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
                , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
                , E.moveRight 5, E.moveDown 25
                ]
                ( E.text "[" )
            , E.column
                [ ]
                [ E.el
                    [ E.paddingXY 0 2 ]
                    ( Input.text
                        [ E.width (E.px 50), E.height (E.px 50)
                        , Font.center, Font.size 13, Font.center, Font.color passClr, getFont "Assistant"
                        , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                        , Background.color (getColor "offBlack" colorDict) 
                        , E.moveDown 3
                        ]
                        { onChange = \value -> ParseVectorInput veIndex vID X value
                        , text = iX
                        , placeholder = Nothing
                        , label = Input.labelHidden "An X vector input"
                        }
                    )
                , E.el
                    [ E.paddingXY 0 2 ]
                    ( Input.text
                        [ E.width (E.px 50), E.height (E.px 50), Font.center, Font.size 13, Font.center, Font.color passClr
                        , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant"
                        , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                        , Background.color (getColor "offBlack" colorDict) 
                        , E.moveDown 3
                        ]
                        { onChange = \value -> ParseVectorInput veIndex vID Y value
                        , text = iY
                        , placeholder = Nothing
                        , label = Input.labelHidden "A Y vector input"
                        }
                    )
                ]
            , E.el
                [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
                , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
                , E.moveLeft 5, E.moveDown 25
                ]
                ( E.text "]")
            ]
        )
    _ -> ( E.text "broken" )

vectorSumElement : Model -> VisualElementIndex -> VisVector2D -> VisualElement -> Element Msg
vectorSumElement model (eID, gID, veID) vv2 ve = 
  case ve of
    VectorSum vID (iV1, iV2) pass ->
      let
        veIndex = (eID, gID, veID)
        passClr =
          if pass
            then (getColor "elementText" model.elementColorDict)
            else rgb255 255 0 0

        visualElement = (Vector vID (iV1, iV2) pass)
        theModel = getVisualModel model.focusedEmbed model.ivvlDict
        theGrid = 
          case (Dict.get model.focusedGrid theModel.grids) of
            Just x -> x
            _ -> defaultGrid2D

        theVector =
          case (Dict.get vID theGrid.vectorObjects) of
            Just x -> x
            _ -> defaultVisVector2D
      in
        ( E.row
          [ E.centerX, E.spacingXY 10 0, E.paddingXY 5 0, rounded 10 ]
          [ E.el
              []
              ( Input.button
                  ( [ E.width (px 20), E.height (px 20)
                    , Background.color (E.rgba 0 0 0 0)
                    , E.inFront
                        ( E.html 
                          ( Icon.trash
                              [ Attributes.attribute "fill" (colorToHex (getColor "elementText" model.elementColorDict))
                              , Attributes.attribute "width" "20px"
                              , Attributes.attribute "height" "20px"
                              ]
                          ) 
                        )
                    ]
                  ) 
                  { onPress = Just (RemoveElement veIndex (IVVLMsg model.focusedEmbed (IVVL.RemoveVVectorG2 vID model.focusedGrid)))
                  , label = E.none
                  } 
              )
          , E.el
              [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "vectorSum" )
          , E.el
              [ Font.size 24, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text (String.fromInt veID) )
          , E.el
                  [ ]
                  ( Input.text
                      [ E.width (E.px 45), E.height (E.px 45)
                      , Font.center, Font.size 15, Font.center, Font.color passClr, getFont "Assistant"
                      , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                      , Background.color (getColor "offBlack" colorDict) 
                      , E.moveDown 1 ] 
                      { onChange = \value -> ParseVectorSumInput veIndex vID X value
                      , text = iV1
                      , placeholder = Nothing
                      , label = Input.labelHidden "A vectorID input"
                      }
                  )
          , E.el
              [ Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "+" )
          , E.el
                  [ E.paddingXY 0 2 ]
                  ( Input.text
                      [ E.width (E.px 45), E.height (E.px 45)
                      , Font.center, Font.size 15, Font.center, Font.color passClr, getFont "Assistant"
                      , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                      , Background.color (getColor "offBlack" colorDict) 
                      , E.moveDown 1 ] 
                      { onChange = \value -> ParseVectorSumInput veIndex vID Y value
                      , text = iV2
                      , placeholder = Nothing
                      , label = Input.labelHidden "A vectorID input"
                      }
                  )
          , E.el
              [ Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "=" )
          , E.el
              [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
              , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
              , E.moveRight 5, E.moveUp 3
              ]
              ( E.text "[" )
          , E.column
              [ E.spacingXY 0 10 ]
              [ E.el
                  [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                  ( E.text (String.fromFloat (firstV2 theVector.vector)) )
              , E.el
                  [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                  ( E.text (String.fromFloat (secondV2 theVector.vector)) )
              ]
          , E.el
              [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
              , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
              , E.moveLeft 5, E.moveUp 3
              ]
              ( E.text "]")
          ]
        )
    _ -> ( E.text "broken" )

vectorDifferenceElement : Model -> VisualElementIndex -> VisVector2D -> VisualElement -> Element Msg
vectorDifferenceElement model (eID, gID, veID) vv2 ve = 
  case ve of
    VectorDifference vID (iV1, iV2) pass ->
      let
        veIndex = (eID, gID, veID)
        passClr =
          if pass
            then (getColor "elementText" model.elementColorDict)
            else rgb255 255 0 0

        visualElement = (Vector vID (iV1, iV2) pass)
        theModel = getVisualModel model.focusedEmbed model.ivvlDict
        theGrid = 
          case (Dict.get model.focusedGrid theModel.grids) of
            Just x -> x
            _ -> defaultGrid2D

        theVector =
          case (Dict.get vID theGrid.vectorObjects) of
            Just x -> x
            _ -> defaultVisVector2D
      in
        ( E.row
          [ E.centerX, E.spacingXY 10 0, E.paddingXY 5 0, rounded 10 ]
          [ E.el
              []
              ( Input.button
                  ( [ E.width (px 20), E.height (px 20)
                    , Background.color (E.rgba 0 0 0 0)
                    , E.inFront
                        ( E.html 
                          ( Icon.trash
                              [ Attributes.attribute "fill" (colorToHex (getColor "elementText" model.elementColorDict))
                              , Attributes.attribute "width" "20px"
                              , Attributes.attribute "height" "20px"
                              ]
                          ) 
                        )
                    ]
                  ) 
                  { onPress = Just (RemoveElement veIndex (IVVLMsg model.focusedEmbed (IVVL.RemoveVVectorG2 vID model.focusedGrid)))
                  , label = E.none
                  } 
              )
          , E.el
              [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "vectorDiff" )
          , E.el
              [ Font.size 24, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text (String.fromInt veID) )
          , E.el
                  [ ]
                  ( Input.text
                      [ E.width (E.px 45), E.height (E.px 45)
                      , Font.center, Font.size 15, Font.center, Font.color passClr, getFont "Assistant"
                      , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                      , Background.color (getColor "offBlack" colorDict) 
                      , E.moveDown 1 ] 
                      { onChange = \value -> ParseVectorDifferenceInput veIndex vID X value
                      , text = iV1
                      , placeholder = Nothing
                      , label = Input.labelHidden "A vectorID input"
                      }
                  )
          , E.el
              [ Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "-" )
          , E.el
                  [ E.paddingXY 0 2 ]
                  ( Input.text
                      [ E.width (E.px 45), E.height (E.px 45)
                      , Font.center, Font.size 15, Font.center, Font.color passClr, getFont "Assistant"
                      , Border.rounded 10, Border.width 2, Border.color (getColor "offWhite" colorDict)
                      , Background.color (getColor "offBlack" colorDict) 
                      , E.moveDown 1 ] 
                      { onChange = \value -> ParseVectorDifferenceInput veIndex vID Y value
                      , text = iV2
                      , placeholder = Nothing
                      , label = Input.labelHidden "A vectorID input"
                      }
                  )
          , E.el
              [ Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
              ( E.text "=" )
          , E.el
              [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
              , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
              , E.moveRight 5, E.moveUp 3
              ]
              ( E.text "[" )
          , E.column
              [ E.spacingXY 0 10 ]
              [ E.el
                  [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                  ( E.text (String.fromFloat (firstV2 theVector.vector)) )
              , E.el
                  [ Font.size 18, Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" ]
                  ( E.text (String.fromFloat (secondV2 theVector.vector)) )
              ]
          , E.el
              [ E.height E.fill, E.centerY, Font.size 50, Font.hairline
              , Font.color (getColor "elementText" model.elementColorDict), getFont "Assistant" 
              , E.moveLeft 5, E.moveUp 3
              ]
              ( E.text "]")
          ]
        )
    _ -> ( E.text "broken" )

{--------------------------------------- WIDGET DISPLAY ---------------------------------------}

widgetDisplay : Model -> List (E.Attribute Msg) -> String -> Element Msg
widgetDisplay model style widgetId = 
  E.el 
    style
    ( E.html 
      (Widget.view (getWidgetModel widgetId model.widgetDict) (renderIVVL (getVisualModel widgetId model.ivvlDict) widgetId) )
    )

{--------------------------------------- MESSAGES ---------------------------------------}

type XY = X | Y

type alias VisualElementIndex = (String, Int, Int) -- EmbedId, GridId, VisualElementId
type VisualElement = Vector Int (String, String) Bool -- VectorId, VectorInputString, Pass
                   | VectorSum Int (String, String) Bool -- VectorId, VectorInputString, Pass
                   | VectorDifference Int (String, String) Bool -- VectorId, VectorInputString, Pass

type ElementType = VectorType
                 | VectorSumType
                 | VectorDifferenceType

type Msg = Tick Time.Posix
         | WindowResize Int Int
         | MouseMove Int Int
         | Scroll Float
         | Blank

         | ResizeElementMenuDown
         | ResizeElementMenuUp

         | AddElement ElementType Msg
         | RemoveElement VisualElementIndex Msg
         | ParseVectorInput VisualElementIndex Int XY String
         | ParseVectorSumInput VisualElementIndex Int XY String
         | ParseVectorDifferenceInput VisualElementIndex Int XY String

         | UpdateContinuous

         | IVVLMsg String IVVL.Msg
         | IVVLMoveMsg String (Float, Float)

         | WidgetMsg String (Widget.Msg)
    
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    WindowResize width height ->
      let
        newWidgetDict = Dict.map (\k _ -> Widget.init (toFloat width) (toFloat height) k) model.ivvlDict
        newWidgetCommands = (List.map (\(k,v) -> Cmd.map (WidgetMsg k) (Tuple.second v)) (Dict.toList newWidgetDict))
        newElementWindowMax = round (toFloat width / 2)
        newElementWindowMin = round (toFloat width / 16)
        newElementWindowWidth = round ((toFloat width / toFloat model.width) * toFloat model.elementMenuWidth)
        newElementWindowState = (newElementWindowWidth, (0,0), False)
      in
        ( { model 
            | width = width
            , height = height
            , widgetDict = newWidgetDict
            , elementMenuWidthMax = newElementWindowMax
            , elementMenuWidthMin = newElementWindowMin
            , elementMenuWidth = newElementWindowWidth
            , elementMenuState = newElementWindowState 
          }
          , Cmd.batch newWidgetCommands
        )
    Tick _ -> ( model, Task.perform (\_-> UpdateContinuous) Time.now )
    MouseMove x y -> ( { model | mouseX = x, mouseY = y }, Cmd.none )

    Scroll value -> 
      let 
        newValue =
          if value > 0
            then (2/3)
            else (3/2)
      in
        ( model, Task.perform (\_-> (IVVLMsg model.focusedEmbed (IVVL.ScaleG2 newValue model.focusedGrid))) Time.now ) 

    ResizeElementMenuDown -> 
      let
        cursorPosition = (model.mouseX, model.mouseY)

        isStart = 
          case model.elementMenuState of
            (_, _, a) -> a

        newState = 
          case model.elementMenuState of
            (a, _, False) -> (a, cursorPosition, True)
            _ -> model.elementMenuState

        initialWidth =
          case model.elementMenuState of
            (a, _, _) -> a

        offset =
          case model.elementMenuState of
            (_, (x, _), _) -> x - Tuple.first cursorPosition

        newWidth =
          case List.minimum [initialWidth - offset, model.elementMenuWidthMax ] of
            Nothing -> model.elementMenuWidthMax
            Just val -> val

        restrictedWidth =
          if (newWidth >= model.elementMenuWidthMax)
            then model.elementMenuWidthMax
            else if (newWidth <= model.elementMenuWidthMin)
              then model.elementMenuWidthMin
              else newWidth
      in
        if isStart
          then ( { model | elementMenuWidth = restrictedWidth, elementMenuState = newState }, Cmd.none)
          else ( { model | elementMenuState = newState }, Cmd.none)
    
    ResizeElementMenuUp -> 
      let
        newElementMenuState = (model.elementMenuWidth, (0,0), False)
      in
        case model.elementMenuState of
          (_, _, False) -> (model, Cmd.none)
          _ -> ( { model | elementMenuState = newElementMenuState}, Cmd.none)

    AddElement elementType message ->
      let
        gID = model.focusedGrid 
        eID = model.focusedEmbed
        currentVisual = getVisualModel eID model.ivvlDict
        currentGrid = 
          case Dict.get gID currentVisual.grids of
            Nothing -> defaultGrid2D
            Just a -> a

        newModel = 
          case message of
            IVVLMsg _ (IVVL.AddVVectorG2 _ _) -> 
              let
                nextVID = IVVL.getNextVectorObjectKey currentGrid.vectorObjects
                newEKey = getNextVisualElementIndex model.visualElements model.focusedEmbed gID

                ve = 
                  case elementType of
                    VectorType -> Vector nextVID ("0", "0") True
                    VectorSumType -> VectorSum nextVID ("", "") False
                    VectorDifferenceType -> VectorDifference nextVID ("", "") False

                newVisualElements = Dict.insert newEKey ve model.visualElements
              in
                { model | visualElements = newVisualElements }
            _ -> model
      in
        ( newModel, Task.perform (\_-> message) Time.now )

    RemoveElement (eID, gID, veID) message ->
      let
        newModel =
          case message of
            IVVLMsg _ (IVVL.RemoveVVectorG2 _ _) ->
              let
                vID = 
                  case (Dict.get (eID, gID, veID) model.visualElements) of
                    Just (Vector vID2 _ _) -> vID2
                    Just (VectorSum vID2 _ _) -> vID2
                    Just (VectorDifference vID2 _ _) -> vID2
                    Nothing -> 0
                removedVisualElements = Dict.remove (eID, gID, veID) model.visualElements

                filteredVisualElements =
                  Dict.filter
                    (\_ ve ->
                      case ve of
                        Vector vevID _ _ ->
                          if (vevID > vID)
                            then True
                            else False
                        VectorSum vevID _ _ ->
                          if (vevID > vID)
                            then True
                            else False
                        VectorDifference vevID _ _ ->
                          if (vevID > vID)
                            then True
                            else False
                        --_ -> False
                    ) removedVisualElements

                shiftedVisualElements =
                  Dict.fromList
                    ( List.map 
                        (\((a,b,c), ve) ->
                          case ve of
                            Vector vevID d e ->
                              ((a,b,(c - 1)), (Vector (vevID - 1) d e))
                            VectorSum vevID d e -> ((a,b, (c - 1)), (VectorSum (vevID - 1) d e) )
                            VectorDifference vevID d e -> ((a,b, (c - 1)), (VectorSum (vevID - 1) d e) )
                        )
                        (Dict.toList filteredVisualElements)
                    )

                updatedVisualElements = Dict.union shiftedVisualElements removedVisualElements

                finalVisualElements = 
                  if (Dict.size model.visualElements == Dict.size removedVisualElements)
                    then model.visualElements
                    else Dict.remove (eID, gID, (Dict.size model.visualElements)) updatedVisualElements
              in
                { model | visualElements = finalVisualElements }
            _ -> model
      in
        ( newModel, Task.perform (\_-> message) Time.now )

    ParseVectorInput (eID, gID, veID) vID xy input ->
      let
        veIndex = (eID, gID, veID)
        vElement = 
          case (Dict.get veIndex model.visualElements) of
            Nothing -> Vector vID ("0", "0") True
            Just a -> a

        parseInputXY = String.toFloat input
        parseInputOther = 
          case xy of
            X -> 
              (\ve ->
                case ve of 
                  Vector _ (_, input2) _ -> (String.toFloat input2) 
                  _ -> Nothing
              ) vElement
            Y -> 
              (\ve ->
                case ve of
                  Vector _ (input1, _) _ -> (String.toFloat input1)
                  _ -> Nothing
              ) vElement

        invisibilityCheck =
          case ( Dict.get veIndex model.visualElements ) of
            Nothing -> Dict.insert veIndex (Vector vID ("0","0") True) model.visualElements
            Just _ -> model.visualElements

        updatedVectorInputs = 
          Dict.update 
          veIndex
          ( case xy of
              X -> 
                Maybe.map
                  (\ve ->
                    case ve of 
                      Vector v (_, y) p -> Vector v (input,y) p
                      _ -> Vector -1 ("err", "err") False
                  ) 
              
              Y -> 
                Maybe.map 
                  (\ve ->
                    case ve of 
                      Vector v (x, _) p -> Vector v (x,input) p
                      _ -> Vector -1 ("err", "err") False
                  ) 
          )
          invisibilityCheck

        finalVectorInputs = 
          Dict.update 
          veIndex
          ( if ( parseInputXY == Nothing || parseInputOther == Nothing )
              then 
                Maybe.map 
                  (\ve ->
                    case ve of
                      Vector v (x,y) _ -> Vector v (x,y) False
                      _ -> Vector -1 ("err", "err") False
                  )
              else 
                Maybe.map
                (\ve ->
                  case ve of
                    Vector v (x,y) _ -> Vector v (x,y) True
                    _ -> Vector -1 ("err", "err") False
                )
          )
          updatedVectorInputs

        theModel = getVisualModel eID model.ivvlDict
        theGrid = 
          case (Dict.get gID (theModel.grids) ) of
            Nothing -> defaultGrid2D
            Just x -> x

        currentVisVectorValue =
          case (Dict.get vID (theGrid.vectorObjects) ) of
            Nothing -> defaultVisVector2D
            Just x -> x

        newVectorValue =
          if ( parseInputXY == Nothing || parseInputOther == Nothing )
            then currentVisVectorValue.vector
            else 
              case xy of
                X -> (Maybe.withDefault 0 parseInputXY, Maybe.withDefault 0 parseInputOther)
                Y -> (Maybe.withDefault 0 parseInputOther, Maybe.withDefault 0 parseInputXY)        

        newVisVectorValue = { currentVisVectorValue | vector = newVectorValue }
        newVectorObjects = Dict.insert vID newVisVectorValue theGrid.vectorObjects
        newGrid = { theGrid | vectorObjects = newVectorObjects }
        newGridDict = Dict.insert gID newGrid theModel.grids
        newIVVLModel = { theModel | grids = newGridDict }
        newIVVLModelDict = Dict.insert eID newIVVLModel model.ivvlDict
      in
        ( { model | ivvlDict = newIVVLModelDict, visualElements = finalVectorInputs }, Cmd.none )

    ParseVectorSumInput (eID, gID, veID) vID xy input ->
      let
        veIndex = (eID, gID, veID)
        vElement = 
          case (Dict.get veIndex model.visualElements) of
            Nothing -> VectorSum vID ("", "") False
            Just a -> a

        parseInputXY = String.toInt input
        parseInputOther = 
          case xy of
            X -> 
              (\ve ->
                case ve of 
                  VectorSum _ (_, input2) _ -> (String.toInt input2) 
                  _ -> Nothing
              ) vElement
            Y -> 
              (\ve ->
                case ve of
                  VectorSum _ (input1, _) _ -> (String.toInt input1)
                  _ -> Nothing
              ) vElement

        testInputXY = 
          case parseInputXY of
            Nothing -> Nothing
            Just value -> 
              case (Dict.get (eID, gID, value) model.visualElements) of
                Just (Vector vID2 _ _) -> Just vID2
                Just (VectorSum vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorDifference vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                _ -> Nothing
        testInputOther =
          case parseInputOther of
            Nothing -> Nothing
            Just value ->
              case (Dict.get (eID, gID, value) model.visualElements) of
                Just (Vector vID2 _ _) -> 
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorSum vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorDifference vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                _ -> Nothing

        invisibilityCheck =
          case ( Dict.get veIndex model.visualElements ) of
            Nothing -> Dict.insert veIndex (VectorSum vID ("", "") False) model.visualElements
            Just _ -> model.visualElements

        updatedVectorInputs = 
          Dict.update 
          veIndex
          ( case xy of
              X -> 
                Maybe.map
                  (\ve ->
                    case ve of 
                      VectorSum v (_, y) p -> VectorSum v (input,y) p
                      _ -> VectorSum -1 ("err", "err") False
                  ) 
              
              Y -> 
                Maybe.map 
                  (\ve ->
                    case ve of 
                      VectorSum v (x, _) p -> VectorSum v (x,input) p
                      _ -> VectorSum -1 ("err", "err") False
                  ) 
          )
          invisibilityCheck

        finalVectorInputs = 
          Dict.update 
          veIndex
          ( if ( testInputXY == Nothing || testInputOther == Nothing )
              then 
                Maybe.map 
                  (\ve ->
                    case ve of
                      VectorSum v (x,y) _ -> VectorSum v (x,y) False
                      _ -> VectorSum -1 ("err", "err") False
                  )
              else 
                Maybe.map
                (\ve ->
                  case ve of
                    VectorSum v (x,y) _ -> VectorSum v (x,y) True
                    _ -> VectorSum -1 ("err", "err") False
                )
          )
          updatedVectorInputs

        theModel = getVisualModel eID model.ivvlDict
        theGrid = 
          case (Dict.get gID (theModel.grids) ) of
            Nothing -> defaultGrid2D
            Just x -> x

        currentVisVectorValue =
          case (Dict.get vID (theGrid.vectorObjects) ) of
            Nothing -> defaultVisVector2D
            Just x -> x


        accessVector =
          (\vID2 ->
            case (Dict.get vID2 theGrid.vectorObjects) of
              Just v -> v
              Nothing -> defaultVisVector2D
          )

        vectorXY = 
          case (Maybe.map accessVector testInputXY) of
            Nothing -> defaultVisVector2D
            Just y -> y
        vectorOther = 
          case (Maybe.map accessVector testInputOther) of
            Nothing -> defaultVisVector2D
            Just y -> y


        newVectorValue =
          if ( parseInputXY == Nothing || parseInputOther == Nothing )
            then currentVisVectorValue.vector
            else addV2 vectorOther.vector vectorXY.vector

        newVisVectorValue = { currentVisVectorValue | vector = newVectorValue }
        newVectorObjects = Dict.insert vID newVisVectorValue theGrid.vectorObjects
        newGrid = { theGrid | vectorObjects = newVectorObjects }
        newGridDict = Dict.insert gID newGrid theModel.grids
        newIVVLModel = { theModel | grids = newGridDict }
        newIVVLModelDict = Dict.insert eID newIVVLModel model.ivvlDict
      in
        ( { model | ivvlDict = newIVVLModelDict, visualElements = finalVectorInputs }, Cmd.none )

    ParseVectorDifferenceInput (eID, gID, veID) vID xy input ->
      let
        veIndex = (eID, gID, veID)
        vElement = 
          case (Dict.get veIndex model.visualElements) of
            Nothing -> VectorDifference vID ("", "") False
            Just a -> a

        parseInputXY = String.toInt input
        parseInputOther = 
          case xy of
            X -> 
              (\ve ->
                case ve of 
                  VectorDifference _ (_, input2) _ -> (String.toInt input2) 
                  _ -> Nothing
              ) vElement
            Y -> 
              (\ve ->
                case ve of
                  VectorDifference _ (input1, _) _ -> (String.toInt input1)
                  _ -> Nothing
              ) vElement

        testInputXY = 
          case parseInputXY of
            Nothing -> Nothing
            Just value -> 
              case (Dict.get (eID, gID, value) model.visualElements) of
                Just (Vector vID2 _ _) -> Just vID2
                Just (VectorSum vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorDifference vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                _ -> Nothing
        testInputOther =
          case parseInputOther of
            Nothing -> Nothing
            Just value ->
              case (Dict.get (eID, gID, value) model.visualElements) of
                Just (Vector vID2 _ _) -> 
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorSum vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                Just (VectorDifference vID2 _ _) ->
                  if (vID2 == veID)
                    then Nothing
                    else Just vID2
                _ -> Nothing

        invisibilityCheck =
          case ( Dict.get veIndex model.visualElements ) of
            Nothing -> Dict.insert veIndex (VectorDifference vID ("", "") False) model.visualElements
            Just _ -> model.visualElements

        updatedVectorInputs = 
          Dict.update 
          veIndex
          ( case xy of
              X -> 
                Maybe.map
                  (\ve ->
                    case ve of 
                      VectorDifference v (_, y) p -> VectorDifference v (input,y) p
                      _ -> VectorDifference -1 ("err", "err") False
                  ) 
              
              Y -> 
                Maybe.map 
                  (\ve ->
                    case ve of 
                      VectorDifference v (x, _) p -> VectorDifference v (x,input) p
                      _ -> VectorDifference -1 ("err", "err") False
                  ) 
          )
          invisibilityCheck

        finalVectorInputs = 
          Dict.update 
          veIndex
          ( if ( testInputXY == Nothing || testInputOther == Nothing )
              then 
                Maybe.map 
                  (\ve ->
                    case ve of
                      VectorDifference v (x,y) _ -> VectorDifference v (x,y) False
                      _ -> VectorDifference -1 ("err", "err") False
                  )
              else 
                Maybe.map
                (\ve ->
                  case ve of
                    VectorDifference v (x,y) _ -> VectorDifference v (x,y) True
                    _ -> VectorDifference -1 ("err", "err") False
                )
          )
          updatedVectorInputs

        theModel = getVisualModel eID model.ivvlDict
        theGrid = 
          case (Dict.get gID (theModel.grids) ) of
            Nothing -> defaultGrid2D
            Just x -> x

        currentVisVectorValue =
          case (Dict.get vID (theGrid.vectorObjects) ) of
            Nothing -> defaultVisVector2D
            Just x -> x


        accessVector =
          (\vID2 ->
            case (Dict.get vID2 theGrid.vectorObjects) of
              Just v -> v
              Nothing -> defaultVisVector2D
          )

        vectorXY = 
          case (Maybe.map accessVector testInputXY) of
            Nothing -> defaultVisVector2D
            Just y -> y
        vectorOther = 
          case (Maybe.map accessVector testInputOther) of
            Nothing -> defaultVisVector2D
            Just y -> y


        newVectorValue =
          if ( parseInputXY == Nothing || parseInputOther == Nothing )
            then currentVisVectorValue.vector
            else subtractV2 vectorXY.vector vectorOther.vector

        newVisVectorValue = { currentVisVectorValue | vector = newVectorValue }
        newVectorObjects = Dict.insert vID newVisVectorValue theGrid.vectorObjects
        newGrid = { theGrid | vectorObjects = newVectorObjects }
        newGridDict = Dict.insert gID newGrid theModel.grids
        newIVVLModel = { theModel | grids = newGridDict }
        newIVVLModelDict = Dict.insert eID newIVVLModel model.ivvlDict
      in
        ( { model | ivvlDict = newIVVLModelDict, visualElements = finalVectorInputs }, Cmd.none )

    UpdateContinuous ->
      let
        vectorSumsToTest = 
          Dict.filter 
            (\(eID, gID, _) value ->
              if (eID == model.focusedEmbed && gID == model.focusedGrid)
                then
                  case value of
                    VectorSum _ _ _ -> True
                    _ -> False
                else False
            )
            model.visualElements
        
        vectorDifferencesToTest = 
          Dict.filter 
            (\(eID, gID, _) value ->
              if (eID == model.focusedEmbed && gID == model.focusedGrid)
                then
                  case value of
                    VectorDifference _ _ _ -> True
                    _ -> False
                else False
            )
            model.visualElements

        vectorSumsList = Dict.toList vectorSumsToTest
        vectorDifferenceList = Dict.toList vectorDifferencesToTest

        firstParam = List.map Tuple.first vectorSumsList
        firstParamDiff = List.map Tuple.first vectorDifferenceList

        secondParam = 
          List.map (\(_,_,z) -> z) firstParam
        secondParamDiff = 
          List.map (\(_,_,z) -> z) firstParamDiff
        
        thirdParam = List.repeat (List.length firstParam) X
        thirdParamDiff = List.repeat (List.length secondParam) X

        fourthParam = 
          List.map 
            (\key -> 
              case (Dict.get key model.visualElements) of
                Just (VectorSum _ (a, b) _) -> a
                _ -> "err"
            )
            firstParam
        fourthParamDiff = 
          List.map 
            (\key -> 
              case (Dict.get key model.visualElements) of
                Just (VectorDifference _ (a, b) _) -> a
                _ -> "err"
            )
            firstParamDiff

        resizeMessage =
          case model.elementMenuState of
            (_, _, True) -> ResizeElementMenuDown
            _ -> Blank

        listOfMessages = 
          List.map4 (ParseVectorSumInput) firstParam secondParam thirdParam fourthParam
          ++ (List.map4 (ParseVectorDifferenceInput) firstParamDiff secondParamDiff thirdParamDiff fourthParamDiff)
          ++ [resizeMessage]
        finalBatch = List.map ( \message -> Task.perform (\_-> message) Time.now ) listOfMessages

      in 
        ( model, Cmd.batch finalBatch )

    IVVLMsg k messageForParent ->
      let
        originalDict = model.ivvlDict
        updatedDict = Dict.update k ( Maybe.map (\value -> Tuple.first (IVVL.updateLibModel messageForParent value)) ) originalDict 
      in
        ( { model | ivvlDict = updatedDict }, Cmd.none)
    
    IVVLMoveMsg k (x, y) -> 
      let
        originalDict = model.ivvlDict
        updatedDict = Dict.update k (Maybe.map (\value -> Tuple.first (IVVL.updateLibModel (IVVL.HoldMove (x, y)) value))) originalDict
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

getColor : String -> Dict String E.Color -> E.Color
getColor key dict =
  case ( Dict.get key dict )  of
    Nothing -> E.rgb255 25 25 25
    Just col -> col 

setColor : String -> String -> Dict String E.Color -> Dict String E.Color
setColor colourID key dict =
  Dict.update key (\_ -> Dict.get colourID colorDict) dict

getFont : String -> E.Attribute Msg
getFont key =
  case (Dict.get key fontDict)  of
    Nothing -> 
      Font.family
        [ Font.external
          { name = "Comic Neue"
          , url = "https://fonts.googleapis.com/css?family=Comic+Neue"
          }
        ]
    Just font -> font 

renderIVVL : IVVL.LibModel -> String -> List (Shape Msg)
renderIVVL model k = 
  [ IVVL.renderLibModel model (IVVLMoveMsg k) (IVVLMsg k (ReleaseMove)) ]

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
        Nothing -> IVVL.defaultLibModel
  in
    final

colorToHex : E.Color -> String
colorToHex eCol =
  let
    colors = toRgb eCol
    red = Hex.toString (round (colors.red * 255))
    blue = Hex.toString (round (colors.blue * 255))
    green = Hex.toString (round (colors.green * 255))
    together = String.concat ["#", red, green, blue] 
  in 
    together

{--------------------------------------- HELPERS ---------------------------------------}

colorDict : Dict String E.Color
colorDict = 
      Dict.fromList
        [ ("primaryDark", E.rgb255 50 47 86)
        , ("primaryLight", E.rgb255 0 120 255)
        , ("secondaryLight", E.rgb255 0 231 144)
        , ("offBlack", E.rgb255 21 15 30)
        , ("secondaryDark", E.rgb255 47 82 92)
        , ("highlight", E.rgb255 238 105 234)
        , ("secondaryHighlight", E.rgb255 251 216 119)
        , ("offWhite", E.rgb255 255 250 236)
        ]

fontDict : Dict String (E.Attribute msg)
fontDict =
  Dict.fromList
    [ ("Inconsolata", 
        Font.family
          [ Font.external
            { name = "Inconsolata"
            , url = "https://fonts.googleapis.com/css?family=Inconsolata"
            }
          ]
      )
    , ("Assistant", 
        Font.family
          [ Font.external
            { name = "Assistant"
            , url = "https://fonts.googleapis.com/css?family=Assistant"
            }
          ]
      )
    ]

{--------------------------------------- MODEL ---------------------------------------}

type alias Model =
  { width : Int
  , height : Int 
  , widgetDict : Dict String (Widget.Model, Cmd Widget.Msg) 
  , ivvlDict : Dict String (IVVL.LibModel)
  , visualElements : Dict VisualElementIndex VisualElement

  , focusedEmbed : String
  , focusedGrid : Int

  , elementMenuWidth : Int
  , elementMenuWidthMax : Int
  , elementMenuWidthMin : Int
  , elementMenuState : (Int, (Int, Int), Bool) -- SizeBefore, CursorPosStart, isDragging

  , elementColorDict : Dict String E.Color
  
  , mouseX : Int
  , mouseY : Int
  }
    
initialModel : (Model, Cmd Msg)
initialModel =
  let
    preset = IVVL.defaultLibModel
    preset2 = { preset 
              | grids = 
                  Dict.insert 1 
                    ( newG2
                      |> IVVL.addVVectorG2 
                        ( newVV2
                          |> setVV2 (1, 1)
                          |> endTypeVV2 Directional
                          |> colorVV2 (getColor "defaultVector" eColorDict)
                          |> lineTypeVV2 (Solid 4)
                        ) 
                      |> xAxisColorG2 (getColor "axes" eColorDict)
                      |> yAxisColorG2 (getColor "axes" eColorDict)
                      |> gridlinesColorG2 (getColor "axes" eColorDict)
                    )
                    preset.grids
              , backgroundColor = elementToGSVGColor (getColor "background" eColorDict)
              }

    preVModel = 
      Dict.fromList [ ("embed1", preset2)
                    ]

    visualWidgets = Dict.fromList [ ("embed1", Widget.init 1920 1080 "embed1") ]

    eColorDict =
      Dict.fromList
        [ ("elementText", getColor "offWhite" colorDict)
        , ("background", getColor "offBlack" colorDict)
        , ("defaultVector", E.rgb255 50 210 255)
        , ("buttonBackground", getColor "offWhite" colorDict)
        , ("axes", getColor "offWhite" colorDict)
        , ("inputBackground", E.rgb255 73 65 85)
        ]

    model =  
      { width = 1920
      , height =  1080
      , widgetDict = visualWidgets
      , ivvlDict = preVModel
      , visualElements = Dict.fromList [(("embed1", 1, 1), Vector 1 ("1", "1") True)]

      , focusedEmbed = "embed1"
      , focusedGrid = 1

      , elementMenuWidth = round (1920/4)
      , elementMenuWidthMax = round (1920/2)
      , elementMenuWidthMin = round (1920/16)
      , elementMenuState = (round(1920/4), (0,0), False)
      , elementColorDict = eColorDict

      , mouseX = 0
      , mouseY = 0
      }

    widgetCommands = (List.map (\(k,v) -> Cmd.map (WidgetMsg k) (Tuple.second v)) (Dict.toList visualWidgets))
    viewPortCommand = Task.perform ( \ vp -> WindowResize (round vp.viewport.width) (round vp.viewport.height)) Dom.getViewport
    finalCmd = Cmd.batch (widgetCommands ++ [viewPortCommand])
  in
    ( model, finalCmd )

{--------------------------------------- BOILERPLATE ---------------------------------------}  

view : Model -> { title : String, body : List (Html Msg) } 
view model =
  { title = "Sandbox"
  , body = htmlOutput model
  }   

main : Program () Model Msg
main =
  Browser.document
    { init = \ _ -> initialModel
    , view = view
    , update = update
    , subscriptions = 
        \ _ -> 
          Sub.batch 
            [ BEvents.onResize WindowResize
            , BEvents.onAnimationFrame Tick
            , BEvents.onMouseMove <| 
                Decode.map2 MouseMove 
                  (Decode.field "pageX" Decode.int)
                  (Decode.field "pageY" Decode.int)
            ]
    }