module IVVL exposing 
  ( {- Types -}
    Coordinate2D, Vector2D, Matrix2D, LineType(..), EndType(..), VisVector2D, Grid2D, LibModel

    {- Rendering and Utilities -}
  , renderLibModel, updateLibModel, Msg(..), getNextVectorObjectKey

    {- Vector2D Transformations -}
  , newV2,          addV2,        subtractV2,      scalarV2,  dotV2,  firstV2, secondV2

    {- Matrix2D Transformations -}
  , newM2,          addM2,        subtractM2,      scalarM2,  dotM2

    {- VisVector2D Transformations -}                                        
  , newVV2, setVV2, addVV2,       subtractVV2,     scalarVV2, dotVV2, lineTypeVV2, endTypeVV2

    {- Grid2D Transformations -}
  , newG2,          addVVectorG2, removeVVectorG2, scaleVVectorG2

    {- Defaults -}
  , defaultCoordinate2D, defaultVector2D, defaultMatrix2D, identityMatrix2D
  , defaultLineType, defaultEndType, defaultVisVector2D , defaultGrid2D, defaultLibModel
  
    {- Maybe Conversions =D -}
  , justToVector2D, justToMatrix2D
  )

{--------------------------------------- IMPORTS ---------------------------------------}

import GraphicSVG exposing (..)
import GraphicSVG.Widget exposing (..)
import GraphicSVG.App exposing (..)

import Dict exposing (Dict)

{--------------------------------------- COORDINATES AND VECTORS ---------------------------------------}

type alias Coordinate2D = (Float, Float)
type alias Vector2D = Coordinate2D

newV2 : Vector2D
newV2 = defaultVector2D

-- Adds two Vector2Ds
addV2 : Vector2D -> Vector2D -> Vector2D
addV2 v1 v2 =
  (firstV2 v1 + firstV2 v2, secondV2 v1 + secondV2 v2)

-- Subtracts two Vector2Ds
subtractV2 : Vector2D -> Vector2D -> Vector2D
subtractV2 v1 v2 =
  (firstV2 v1 - firstV2 v2, secondV2 v1 - secondV2 v2)
  
-- Scalar multiplication of a Float and a Vector
scalarV2 : Float -> Vector2D -> Vector2D
scalarV2 f v =
  (f * firstV2 v, f * Tuple.second v)

dotV2 : Matrix2D -> Vector2D -> Maybe Vector2D
dotV2 matrix v =
  let
    {- [a, b    [x
        c, d]    y]
    -}
    
    a = firstV2 (justToVector2D (List.head matrix))
    b = firstV2 (justToVector2D (backHead matrix))
    c = secondV2 (justToVector2D (List.head matrix))
    d = secondV2 (justToVector2D (backHead matrix))

    x = firstV2 v
    y = secondV2 v

    x2 = (a*x) + (b*x)
    y2 = (c*y) + (d*y)

    finalV = 
      if (List.length matrix == 2)
        then Just (x2,y2)
        else Nothing

  in
    finalV
  
-- Returns first element of Vector2D
firstV2 : Vector2D -> Float
firstV2 v = Tuple.first v

-- Returns second element of Vector2D
secondV2 : Vector2D -> Float
secondV2 v = Tuple.second v

{--------------------------------------- MATRIX ---------------------------------------}

type alias Matrix2D = List Vector2D

newM2 : Matrix2D
newM2 = defaultMatrix2D

-- Adds all entries of two Matrix2Ds together
addM2 : Matrix2D -> Matrix2D -> Maybe Matrix2D
addM2 m1 m2 = 
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    if (length1 == length2) 
      then Just (List.map2 addV2 m1 m2)
      else Nothing
      
-- Subtracts all entries of two Matrix2Ds
subtractM2 : Matrix2D -> Matrix2D -> Maybe Matrix2D
subtractM2 m1 m2 = 
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    if (length1 == length2)
      then Just (List.map2 subtractV2 m1 m2)
      else Nothing

-- Scalar multiplication of a float and a Matrix2D
scalarM2 : Float -> Matrix2D -> Matrix2D
scalarM2 f m = 
  List.map2 scalarV2 (List.repeat (List.length m) f) m

-- Dot multiplication of two Matrix2Ds of length 2
dotM2 : Matrix2D -> Matrix2D -> Maybe Matrix2D
dotM2 m1 m2 =
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    if (length1==length2 && length1==2)
      then 
        let
          {- [a, b    [w, x
              c, d]    y, z]
          -}
          
          a = firstV2 (justToVector2D (List.head m1))
          b = firstV2 (justToVector2D (backHead m1))
          c = secondV2 (justToVector2D (List.head m1))
          d = secondV2 (justToVector2D (backHead m1))
          
          w = firstV2 (justToVector2D (List.head m2))
          x = firstV2 (justToVector2D (backHead m2))
          y = secondV2 (justToVector2D (List.head m2))
          z = secondV2 (justToVector2D (backHead m2))
          
          tl = a*w + b*y
          tr = a*x + b*z
          bl = c*w + d*y
          br = c*x + d*z
        in
          Just [ (tl, bl) , (tr, br) ]
      else
        Nothing

{--------------------------------------- LINE TYPE ---------------------------------------}

type LineType = Solid Float
              | Dotted Float
              | Dashed Float

type EndType = None
             | Directional
             | Bidirectional
          

convertLineType : LineType -> Color -> Stencil -> Shape userMsg
convertLineType lt clr =
  case lt of
    Solid x -> outlined (solid x) clr
    Dotted x -> outlined (dotted x) clr
    Dashed x -> outlined (dashed x) clr
         
{--------------------------------------- VISIBLE VECTORS ---------------------------------------}

type alias VisVector2D = 
  { vector : Vector2D
  , lineType : LineType
  , endType : EndType
  }

-- Base Vector type for applications, alongside transformations
newVV2 : VisVector2D
newVV2 = defaultVisVector2D

setVV2 : Vector2D -> VisVector2D -> VisVector2D
setVV2 vec visVec = { visVec | vector = vec }

addVV2 : Vector2D -> VisVector2D -> VisVector2D
addVV2 vec visVec = { visVec | vector = addV2 vec visVec.vector}

subtractVV2 : Vector2D -> VisVector2D -> VisVector2D
subtractVV2 vec visVec = { visVec | vector = subtractV2 vec visVec.vector}

scalarVV2 : Float -> VisVector2D -> VisVector2D
scalarVV2 scalar visVec = { visVec | vector = scalarV2 scalar visVec.vector}

dotVV2 : Matrix2D -> VisVector2D -> VisVector2D
dotVV2 matrix visVec = { visVec | vector = justToVector2D (dotV2 matrix visVec.vector)}

lineTypeVV2 : LineType -> VisVector2D -> VisVector2D
lineTypeVV2 lt visVec = { visVec | lineType = lt}

endTypeVV2 : EndType -> VisVector2D -> VisVector2D
endTypeVV2 et visVec = { visVec | endType = et }

{--------------------------------------- GRID ---------------------------------------}

type alias Grid2D = 
  { transformationMatrix : Matrix2D
  , vectorObjects : Dict Int VisVector2D
  , xColor : Color
  , yColor : Color
  , xLineType : LineType
  , yLineType : LineType

  , scale : Float

  , startingOffset : Coordinate2D
  , offset : Coordinate2D
  }

-- Base Vector type for applications, alongside transformations
newG2 : Grid2D
newG2 = defaultGrid2D

addVVectorG2 : VisVector2D -> Grid2D -> Grid2D
addVVectorG2 visVec grid =
  { grid | vectorObjects = Dict.insert (getNextVectorObjectKey grid.vectorObjects) visVec grid.vectorObjects }

removeVVectorG2 : Int -> Grid2D -> Grid2D
removeVVectorG2 visVecID grid =
  let
    vectorObject = grid.vectorObjects
    removedGrid = Dict.remove visVecID vectorObject
    filteredGrid = Dict.filter (\key _ -> key > visVecID) removedGrid
    shiftedGrid = Dict.fromList (List.map (\(key, value) -> (key - 1, value)) (Dict.toList filteredGrid) )
    updatedGrid = Dict.union shiftedGrid removedGrid
    finalGrid = 
      if (Dict.size vectorObject == Dict.size removedGrid)
        then updatedGrid
        else Dict.remove (Dict.size vectorObject) updatedGrid
  in 
     { grid | vectorObjects = finalGrid } 

scaleVVectorG2 : Float -> Int -> Grid2D -> Grid2D
scaleVVectorG2 scalar visVecID grid = 
  let
    vectorObjects = grid.vectorObjects

    vectorUpdater record = { record | vector = scalarV2 scalar record.vector }
    updater func x = Maybe.map func x
    
    finalGrid = Dict.update visVecID (updater vectorUpdater) vectorObjects
  in
    { grid | vectorObjects = finalGrid }

{--------------------------------------- RENDER ---------------------------------------}

renderLibModel : LibModel -> ((Float, Float) -> userMsg) -> userMsg -> Shape userMsg
renderLibModel model holdMsg releaseMsg =
  [ square 10000 |> filled white
  , List.map renderG2 (Dict.values model.grids)
      |> group
  ] |> group
    |> ( case model.motionState of
             NotDragging -> notifyMouseDownAt holdMsg
             Dragging -> notifyMouseMoveAt holdMsg 
         )
      |> notifyLeave releaseMsg
      |> notifyMouseUp releaseMsg

-- Turns a Grid2D to a Shape
renderG2 : Grid2D -> (Shape usermsg)
renderG2 grid =
  [ List.map (\offset -> if (offset /= 0) then
                           [ line (-10000, grid.scale * toFloat offset ) (10000, grid.scale * toFloat offset)         -- horizontal grid lines
                               |> convertLineType (Solid 0.1) grid.xColor 
                           , text (Debug.toString offset)
                               |> filled black
                               |> scale (grid.scale * 0.02)
                               |> move (0, grid.scale * toFloat offset + 1)
                           ] |> group
                         else [] |> group
             )
             (List.range -50 50)
    |> group

  , List.map (\offset -> if (offset /= 0) then
                           [ line (grid.scale * toFloat offset, -10000) (grid.scale * toFloat offset, 10000)         -- vertical grid lines
                               |> convertLineType (Solid 0.1) grid.yColor 
                           , text (Debug.toString offset)
                               |> filled black
                               |> scale (grid.scale * 0.02)
                               |> move (grid.scale * toFloat offset, 1)
                           ] |> group
                         else [] |> group
             )
             (List.range -50 50)
    |> group
  
  , text "0"
      |> filled black
      |> scale (grid.scale * 0.02)
      |> move (1, 1)
  , line (-10000, 0) (10000, 0) -- X axis
      |> convertLineType grid.xLineType grid.xColor
  , line (0, -10000) (0, 10000) -- Y axis
      |> convertLineType grid.yLineType grid.yColor

  , let
      vectorUpdater record scalar = { record | vector = scalarV2 scalar record.vector }
      listOfVectors = Dict.values (Dict.map (\_ v -> vectorUpdater v grid.scale) grid.vectorObjects)
    in
      List.map renderVV2 (listOfVectors)
        |> group
  ] |> group
    |> move (grid.offset)

-- Turns a Vector2D to a Shape
renderVV2 : VisVector2D -> (Shape usermsg)
renderVV2 vector =
  [ line (0, 0) vector.vector
      |> convertLineType vector.lineType black
  , case vector.endType of
      None -> [] |> group
      Directional -> triangle 5
                       |> filled black
                       |> rotate (degrees -30)
                       |> rotate -(atan2 (firstV2 vector.vector) (secondV2 vector.vector))
                       |> move vector.vector
      Bidirectional -> [ triangle 5
                           |> filled black
                           |> rotate (degrees -30)
                           |> rotate -(atan2 (firstV2 vector.vector) (secondV2 vector.vector))
                           |> move vector.vector
                       , triangle 5
                           |> filled black
                           |> rotate (degrees -30)
                           |> rotate -(atan2 (firstV2 vector.vector) (secondV2 vector.vector))
                           |> rotate (degrees 180)
                       ] |> group
  ] |> group

{--------------------------------------- MESSAGES ---------------------------------------}

type DraggingState = NotDragging
                   | Dragging

type Msg = Tick Float GetKeyState -- Unused
         | Blank -- Unused

         -- All model interactions
         | AddG2 Grid2D -- Add (Grid2D).
         | RemoveG2 Int -- Remove Grid2D with (ID Int)

         | ScaleG2 Float Int -- Scale by (Scalar) a Grid with (ID Int).
         | ScaleG2All Float -- Scale by (Scalar) ALL grids.

         | AddVVectorG2 VisVector2D Int -- Add (VisVector2D) to (Grid with key Int)
         | AddVVectorG2All VisVector2D -- Add (VisVector2D) to ALL grids.

         | RemoveVVectorG2 Int Int -- Remove a vector with (ID Int) from (Grid with key Int)
         | RemoveVVectorG2All Int -- Remove a vector with (ID Int) from ALL grids.

         | ScaleVVectorG2 Float Int Int -- Scale by (Scalar) a vector with (ID Int) from (Grid with key Int) 
         | ScaleVVectorG2All Float Int -- Scale by (Scalar) a vector with (ID Int) from ALL grids.

         | HoldMove (Float, Float)
         | ReleaseMove

-- Updates the grid.
updateLibModel : Msg -> LibModel -> ( LibModel, Cmd Msg )
updateLibModel msg model = 
  case msg of
    Tick _ _ -> ( model, Cmd.none )
    Blank -> ( model, Cmd.none )

    AddG2 grid ->
      let
        nextAvailableKey = getNextKey model.grids
        updatedGrid = Dict.insert nextAvailableKey grid model.grids
      in
        ( { model | grids = updatedGrid }, Cmd.none )
        
    RemoveG2 gridID ->
      let
        removedGrid = Dict.remove gridID model.grids
        filteredGrid = Dict.filter (\key _ -> key > gridID) removedGrid
        shiftedGrid = Dict.fromList ( List.map (\(key, value) -> (key - 1, value)) (Dict.toList filteredGrid) )
        updatedGrid = Dict.union shiftedGrid removedGrid
        finalGrid = 
          if ( Dict.size model.grids == Dict.size removedGrid )
            then updatedGrid
            else Dict.remove (Dict.size model.grids) updatedGrid
      in
        ( { model | grids = finalGrid }, Cmd.none )
       
    ScaleG2 scalar gridID ->
      let
        theGrid = Dict.get gridID model.grids

        updatedGrid = Maybe.map (\x -> { x | scale = x.scale * scalar }) theGrid
        updatedGridDict = 
          case updatedGrid of
            Nothing -> model.grids
            Just workingGrid -> Dict.insert gridID workingGrid model.grids

      in
        ( { model | grids = updatedGridDict }, Cmd.none )
      
    ScaleG2All scalar ->
      let
        gridDict = model.grids
        newGrids = Dict.map (\_ v -> { v | scale = v.scale * scalar}) gridDict
      in
        ( { model | grids = newGrids }, Cmd.none )

    AddVVectorG2 visVector gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids

        updatedGrid = Maybe.map2 addVVectorG2 (Just visVector) theGrid
        updatedGridModel = case updatedGrid of
                            Nothing -> model.grids
                            Just newGrid -> Dict.insert gridKey newGrid model.grids
        
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    
    AddVVectorG2All visVector ->
      let
        gridDict = model.grids
        
        newGrids = Dict.map (\_ v -> addVVectorG2 visVector v) gridDict 
      in
        ( { model | grids = newGrids }, Cmd.none )


    RemoveVVectorG2 vId gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 removeVVectorG2 (Just vId) theGrid 
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    
    RemoveVVectorG2All vId ->
      let
        gridDict = model.grids

        newGrids = Dict.map (\_ v -> removeVVectorG2 vId v) gridDict
      in
        ( { model | grids = newGrids }, Cmd.none )


    ScaleVVectorG2 scalar vId gridKey ->
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map3 scaleVVectorG2 (Just scalar) (Just vId) theGrid 
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )

    ScaleVVectorG2All scalar vId ->
      let
        gridDict = model.grids

        newGrids = Dict.map (\_ v -> scaleVVectorG2 scalar vId v) gridDict
      in
        ( { model | grids = newGrids }, Cmd.none )

    HoldMove (x, y) ->
      let 
        updatedModel = 
          case model.motionState of
            NotDragging -> 
              let
                allGrids = model.grids
                offsetGrids = Dict.map (\_ v -> { v | startingOffset = v.offset} ) allGrids
              in
                { model | startingMousePos = (x, y), motionState = Dragging, grids = offsetGrids }
            Dragging ->
              let
                allGrids = model.grids
                difference = scalarV2 1 (subtractV2 (x, y) model.startingMousePos)
                offsetGrids = Dict.map (\_ v -> { v | offset = addV2 v.startingOffset difference} ) allGrids
              in
                 { model | grids = offsetGrids }
      in
        ( updatedModel, Cmd.none )
    
    ReleaseMove ->
      let
        updatedModel = { model | motionState = NotDragging }
      in
        ( updatedModel, Cmd.none )

{--------------------------------------- DEFAULTS ---------------------------------------}

-- Default Coordinate2D
defaultCoordinate2D : Coordinate2D
defaultCoordinate2D = (0, 0)

-- Default Vector2D for Maybe conversion
defaultVector2D : Vector2D
defaultVector2D = (0, 0)

-- Default matrix for Maybe conversions.
defaultMatrix2D : Matrix2D
defaultMatrix2D = [ (0, 0), (0, 0) ]

-- Identity matrix
identityMatrix2D : Matrix2D
identityMatrix2D = [ (1, 0), (0, 1) ]

-- Default LineType
defaultLineType : LineType
defaultLineType = Solid 1

-- Default EndType
defaultEndType : EndType
defaultEndType = None

-- Default VisVector2D
defaultVisVector2D : VisVector2D
defaultVisVector2D = 
  { vector = defaultVector2D
  , lineType = defaultLineType
  , endType = defaultEndType
  }

-- Default Grid2D
defaultGrid2D : Grid2D
defaultGrid2D =
  { transformationMatrix = defaultMatrix2D
  , vectorObjects = Dict.empty
  , xColor = black
  , yColor = black
  , xLineType = defaultLineType
  , yLineType = defaultLineType

  , scale = 100

  , startingOffset = (0, 0)
  , offset = (0, 0)
  }

-- Initial model
defaultLibModel : LibModel
defaultLibModel = 
  { grids = Dict.fromList [(1, defaultGrid2D)]
  , motionState = NotDragging
  , startingMousePos = (0, 0)
  }
  
{--------------------------------------- MAYBE? ---------------------------------------}

-- Converts Maybe Vector2D to Vector2D
justToVector2D : Maybe Vector2D -> Vector2D
justToVector2D f =
  case f of
    Nothing -> defaultVector2D
    Just a -> a

-- Converts Maybe Matrix2D to Matrix2D
justToMatrix2D : Maybe Matrix2D -> Matrix2D
justToMatrix2D f =
  case f of
    Nothing -> defaultMatrix2D
    Just a -> a

{--------------------------------------- HELPER ---------------------------------------}

-- Returns the last item of a List as a Maybe type
backHead : List a -> Maybe a
backHead l = List.head (List.reverse l)

getNextVectorObjectKey : Dict Int VisVector2D -> Int
getNextVectorObjectKey dict = getNextKey dict

-- Gives back the next available key for a Dict
getNextKey : Dict Int a -> Int
getNextKey dict = getNextKeyHelper dict 1

-- getNextKey helper
getNextKeyHelper : Dict Int a -> Int -> Int                             
getNextKeyHelper dict index = 
  if (index > (Dict.size dict))
    then (Dict.size dict) + 1
    else
      if (Dict.member index dict)
        then getNextKeyHelper dict (index + 1)
        else index

{--------------------------------------- MODEL ---------------------------------------}

-- Visualizer Model
type alias LibModel = 
  { grids : Dict Int Grid2D
  , motionState : DraggingState
  , startingMousePos : (Float, Float)
  }