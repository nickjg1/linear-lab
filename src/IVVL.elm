module IVVL exposing (..)

{--------------------------------------- IMPORTS ---------------------------------------}

import GraphicSVG exposing (..)
import GraphicSVG.Widget exposing (..)
import GraphicSVG.App exposing (..)

import Dict exposing (Dict)

{--------------------------------------- COORDINATES AND VECTORS ---------------------------------------}

type alias Coordinate2D = (Float, Float)
type alias Vector2D = Coordinate2D

type alias VisVector2D = 
  { vector : Vector2D
  , lineType : LineType
  , endType : EndType
  }

-- Vector2D convertor
vectorToVisVector2D : Vector2D -> VisVector2D
vectorToVisVector2D vector = 
  { vector = vector 
  , lineType = defaultLineType
  , endType = defaultEndType
  }

-- Default Coordinate2D
defaultCoordinate2D : Coordinate2D
defaultCoordinate2D = (0, 0)

-- Default Vector2D for Maybe conversion
defaultVector2D : Vector2D
defaultVector2D = (0, 0)

-- Default VisVector2D
defaultVisVector2D : VisVector2D
defaultVisVector2D = 
  { vector = defaultVector2D
  , lineType = defaultLineType
  , endType = defaultEndType
  }

-- Converts Maybe Vector2D to Vector2D
justToVector2D : Maybe Vector2D -> Vector2D
justToVector2D f =
  case f of
    Nothing -> defaultVector2D
    Just a -> a

-- Adds two Vector2Ds
add : Vector2D -> Vector2D -> Vector2D
add v1 v2 =
  (Tuple.first v1 + Tuple.first v2, Tuple.second v1 + Tuple.second v2)

-- Subtracts two Vector2Ds
subtract : Vector2D -> Vector2D -> Vector2D
subtract v1 v2 =
  (Tuple.first v1 - Tuple.first v2, Tuple.second v1 - Tuple.second v2)
  
-- Scalar multiplication of a Float and a Vector
scalarMultiply : Float -> Vector2D -> Vector2D
scalarMultiply f v =
  (f * Tuple.first v, f * Tuple.second v)
  
-- String representation of Vector2Ds
print : Vector2D -> String
print v = Debug.toString v
  
-- Returns first element of Vector2D
first : Vector2D -> Float
first v = Tuple.first v

-- Returns second element of Vector2D
second: Vector2D -> Float
second v = Tuple.second v

{--------------------------------------- MATRIX ---------------------------------------}

type alias Matrix2D = List Vector2D

-- Default matrix for Maybe conversions.
defaultMatrix2D : Matrix2D
defaultMatrix2D = [ (0, 0), (0, 0) ]

-- Identity matrix
identityMatrix2D : Matrix2D
identityMatrix2D = [ (1, 0), (0, 1) ]

-- Converts Maybe Matrix2D to Matrix2D
justToMatrix2D : Maybe Matrix2D -> Matrix2D
justToMatrix2D f =
  case f of
    Nothing -> defaultMatrix2D
    Just a -> a

-- Adds all entries of two Matrix2Ds together
addMatrix2D : Matrix2D -> Matrix2D -> Maybe Matrix2D
addMatrix2D m1 m2 = 
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    if (length1 == length2) 
      then Just (List.map2 add m1 m2)
      else Nothing
      
-- Subtracts all entries of two Matrix2Ds
subtractMatrix2D : Matrix2D -> Matrix2D -> Maybe Matrix2D
subtractMatrix2D m1 m2 = 
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    if (length1 == length2)
      then Just (List.map2 subtract m1 m2)
      else Nothing

-- Scalar multiplication of a float and a Matrix2D
scalarMultiplyMatrix2D : Float -> Matrix2D -> Matrix2D
scalarMultiplyMatrix2D f m = 
  List.map2 scalarMultiply (List.repeat (List.length m) f) m

-- Dot multiplication of two Matrix2Ds of length 2
dotMultiplyMatrix2D : Matrix2D -> Matrix2D -> Maybe Matrix2D
dotMultiplyMatrix2D m1 m2 =
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
          
          a = first (justToVector2D (List.head m1))
          b = first (justToVector2D (backHead m1))
          c = second (justToVector2D (List.head m1))
          d = second (justToVector2D (backHead m1))
          
          w = first (justToVector2D (List.head m2))
          x = first (justToVector2D (backHead m2))
          y = second (justToVector2D (List.head m2))
          z = second (justToVector2D (backHead m2))
          
          tl = a*w + b*y
          tr = a*x + b*z
          bl = c*w + d*y
          br = c*x + d*z
        in
          Just [ (tl, bl) , (tr, br) ]
      else
        Nothing

-- String representation of Vector2Ds
printMatrix2D : Matrix2D -> String
printMatrix2D m = Debug.toString m

{--------------------------------------- LINE TYPE ---------------------------------------}

type LineType = Solid Float
              | Dotted Float
              | Dashed Float

type EndType = None
             | Directional
             | Bidirectional
           
-- Default LineType
defaultLineType : LineType
defaultLineType = Solid 1

-- Default EndType
defaultEndType : EndType
defaultEndType = None

convertLineType : LineType -> Color -> Stencil -> Shape userMsg
convertLineType lt clr =
  case lt of
    Solid x -> outlined (solid x) clr
    Dotted x -> outlined (dotted x) clr
    Dashed x -> outlined (dashed x) clr
         

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

-- Default Grid2D
defaultGrid2D : Grid2D
defaultGrid2D =
  { transformationMatrix = defaultMatrix2D
  , vectorObjects = Dict.empty
  , xColor = black
  , yColor = black
  , xLineType = defaultLineType
  , yLineType = defaultLineType

  , scale = 10

  , startingOffset = (0, 0)
  , offset = (0, 0)
  }
  
-- Creates a new Grid2D with an added Vector2D
grid2DAddVector2D : VisVector2D -> Grid2D -> Grid2D
grid2DAddVector2D vector grid = 
  { grid | vectorObjects = Dict.insert (getNextKey grid.vectorObjects) vector grid.vectorObjects }
  
-- Creates a new Grid2D with a vector with specified ID removed
grid2DRemoveVector2D : Int -> Grid2D -> Grid2D
grid2DRemoveVector2D id grid = --grid
  let
    vectorObject = grid.vectorObjects
    removedGrid = Dict.remove id vectorObject
    filteredGrid = Dict.filter (\key _ -> key > id) removedGrid
    shiftedGrid = Dict.fromList (List.map (\(key, value) -> (key - 1, value)) (Dict.toList filteredGrid) )
    updatedGrid = Dict.union shiftedGrid removedGrid
    finalGrid = 
      if (Dict.size vectorObject == Dict.size removedGrid)
        then updatedGrid
        else Dict.remove (Dict.size vectorObject) updatedGrid
  in 
     {grid | vectorObjects = finalGrid} 
     
grid2DScaleVector2D : Float -> Int -> Grid2D -> Grid2D
grid2DScaleVector2D scalar id grid =
  let
    vectorObjects = grid.vectorObjects

    vectorUpdater record = { record | vector = scalarMultiply scalar record.vector }
    updater func x = Maybe.map func x
    
    finalGrid = Dict.update id (updater vectorUpdater) vectorObjects
    
  in
    {grid | vectorObjects = finalGrid}

{--------------------------------------- RENDER ---------------------------------------}

--finalRender : LibModel -> (Shape usermsg)
finalRender : LibModel-> ((Float, Float) -> userMsg) -> userMsg -> Shape userMsg
finalRender model holdMsg releaseMsg =
  [ square 1000 |> filled white
  , List.map renderGrid2D (Dict.values model.grids)
      |> group
  ] |> group
    |> ( case model.motionState of
             NotMoving -> notifyMouseDownAt holdMsg
             Moving -> notifyMouseMoveAt holdMsg 
         )
      |> notifyLeave releaseMsg
      |> notifyMouseUp releaseMsg

-- Turns a Grid2D to a Shape
renderGrid2D : Grid2D -> (Shape usermsg)
renderGrid2D grid =
  [ List.map (\offset -> line (-1000, grid.scale * toFloat offset ) (1000, grid.scale * toFloat offset)         -- horizontal grid lines
                      |> convertLineType (Solid 0.1) grid.xColor 
             )
             (List.range -20 20)
    |> group

  , List.map (\offset -> line (grid.scale * toFloat offset, -1000) (grid.scale * toFloat offset, 1000)         -- vertical grid lines
                      |> convertLineType (Solid 0.1) grid.yColor 
             )
             (List.range -20 20)
    |> group
    
  , line (-1000, 0) (1000, 0) -- X axis
      |> convertLineType grid.xLineType grid.xColor
  , line (0, -1000) (0, 1000) -- Y axis
      |> convertLineType grid.yLineType grid.yColor

  , let
      vectorUpdater record scalar = { record | vector = scalarMultiply scalar record.vector }
    in
      List.map renderVisVector2D (Dict.values (Dict.map (\_ v -> vectorUpdater v grid.scale ) grid.vectorObjects)) -- Generates all the vectors
        |> group
  ] |> group
    |> move (grid.offset)

-- Turns a Vector2D to a Shape
renderVisVector2D : VisVector2D -> (Shape usermsg)
renderVisVector2D vector =
  [ line (0, 0) vector.vector
      |> convertLineType vector.lineType black
  , case vector.endType of
      None -> [] |> group
      Directional -> triangle 2
                       |> filled black
                       |> rotate (degrees -30)
                       |> rotate -(atan2 (first vector.vector) (second vector.vector))
                       |> move vector.vector
      Bidirectional -> [ triangle 2
                           |> filled black
                           |> rotate (degrees -30)
                           |> rotate -(atan2 (first vector.vector) (second vector.vector))
                           |> move vector.vector
                       , triangle 2
                           |> filled black
                           |> rotate (degrees -30)
                           |> rotate (atan2 (first vector.vector) (second vector.vector))
                       ] |> group
  ] |> group

{--------------------------------------- HELPER ---------------------------------------}

-- Returns the last item of a List as a Maybe type
backHead : List a -> Maybe a
backHead l = List.head (List.reverse l)

-- Turns Maybe to an Int
maybeToInt : Maybe Int -> Int
maybeToInt maybeInt =
  case maybeInt of
    Nothing -> 0
    Just value -> value
    
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
    

{--------------------------------------- MESSAGES ---------------------------------------}

type Msg = Tick Float GetKeyState -- Unused
         | Blank -- Unused

         -- All model interactions
         | AddGrid2D Grid2D -- Add (Grid2D).
         | RemoveGrid2D Int -- Remove Grid2D with (ID Int)
         | AddVector2D Vector2D Int -- Add (Vector2D) to (Grid with key Int)
         | AddVisVector2D VisVector2D Int -- Add (VisVector2D) to (Grid with key Int)
         | RemoveVector2D Int Int -- Remove a vector with (ID Int) from (Grid with key Int)
         | ScaleVector2D Float Int Int -- Scale by (Scalar) a vector with (ID Int) from (Grid with key Int) 

         | HoldMove (Float, Float)
         | ReleaseMove


-- Updates the grid.
update : Msg -> LibModel -> ( LibModel, Cmd Msg )
update msg model = 
  case msg of
    Tick _ _ -> ( model, Cmd.none )
    Blank -> ( model, Cmd.none )
    
    AddGrid2D grid ->
      let
        nextAvailableKey = getNextKey model.grids
        
        updatedGrid = Dict.insert nextAvailableKey grid model.grids
      in
        ( { model | grids = updatedGrid }, Cmd.none )
        
    RemoveGrid2D gridId ->
      let
       currentGrids = model.grids
       removedGrid = Dict.remove gridId currentGrids
       filteredGrid = Dict.filter (\key _ -> key > gridId) removedGrid
       shiftedGrid = Dict.fromList (List.map (\(key, value) -> (key - 1, value)) (Dict.toList filteredGrid) )
       updatedGrid = Dict.union shiftedGrid removedGrid
       finalGrid = 
         if (Dict.size currentGrids == Dict.size removedGrid)
           then updatedGrid
           else Dict.remove (Dict.size currentGrids) updatedGrid
      in
        ( { model | grids = finalGrid }, Cmd.none )
       
   
    AddVector2D vector gridKey -> 
      let
        visVector = vectorToVisVector2D vector

        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 grid2DAddVector2D (Just visVector) theGrid
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
        
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    AddVisVector2D visVector gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 grid2DAddVector2D (Just visVector) theGrid
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
        
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    RemoveVector2D vId gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 grid2DRemoveVector2D (Just vId) theGrid 
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    ScaleVector2D scalar vId gridKey ->
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map3 grid2DScaleVector2D (Just scalar) (Just vId) theGrid 
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )

    HoldMove (x, y) ->
      let 
        updatedModel = 
          case model.motionState of
            NotMoving -> 
              let
                allGrids = model.grids
                offsetGrids = Dict.map (\_ v -> { v | startingOffset = v.offset} ) allGrids
              in
                { model | startingMousePos = (x, y), motionState = Moving, grids = offsetGrids }
            Moving ->
              let
                allGrids = model.grids
                difference = scalarMultiply 1 (subtract (x, y) model.startingMousePos)
               -- dummy = add v.startingOffset difference
                offsetGrids = Dict.map (\_ v -> { v | offset = add v.startingOffset difference} ) allGrids
              in
                 { model | grids = offsetGrids }
      in
        ( updatedModel, Cmd.none )
    
    ReleaseMove ->
      let
        updatedModel = { model | motionState = NotMoving }
      in
        ( updatedModel, Cmd.none )
      

{--------------------------------------- DEBUG ---------------------------------------}

type MotionState = NotMoving
                 | Moving

-- Visualizer Model
type alias LibModel = 
  { time : Float 
  , grids : Dict Int Grid2D
  , motionState : MotionState
  , startingMousePos : (Float, Float)
  }

-- Initial model
init : LibModel
init = 
  { time = 0
  , grids = Dict.fromList [(1, defaultGrid2D)]
  , motionState = NotMoving
  , startingMousePos = (0, 0)
  }

-- DEBUGGING PURPOSES ONLY
myShapes : LibModel -> List (Shape userMsg)
myShapes model = 
  [ List.map renderGrid2D (Dict.values model.grids)
      |> group
  --, [rectangle 30 15 |> filled blue, text "add (5,5)" |> filled white |> scale 0.2] |> group |> move (-90, 40) |> notifyTap (AddVector2D (5, 5) 1)
  --, [rectangle 30 15 |> filled blue, text "add (1,0.5)" |> filled white |> scale 0.2] |> group  |> move (-90, 0) |> notifyTap (AddVector2D (1, 0.5) 1)
  --, [rectangle 30 15 |> filled blue, text "remove id 2" |> filled white |> scale 0.2] |> group  |> move (-90, -40) |> notifyTap (RemoveVector2D 2 1)
  --, [rectangle 30 15 |> filled blue, text "scalar id 2 by 3" |> filled white |> scale 0.2 |> move (-10, 0)] |> group  |> move (90, -40) |> notifyTap (ScaleVector2D 3 2 1)
  --, text (Debug.toString (Maybe.withDefault defaultGrid2D (Dict.get 1 model.grids)).vectorObjects) |> filled red |> scale 0.25 |> move (-50, -40)
  ]

{--------------------------------------- DO NOT TOUCH ---------------------------------------}

-- Your subscriptions go here
subscriptions : LibModel -> Sub Msg
subscriptions _ = Sub.none

-- Your main function goes here
main : AppWithTick () LibModel Msg
main = 
  appWithTick Tick 
    { init = \_ _ _ -> (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlRequest = \_ -> Blank
    , onUrlChange = \_ -> Blank
    }

-- You view function goes here
view : LibModel -> { title: String, body : Collage Msg }
view model = 
  { title = "Vector Visualizer Library"
  , body = collage (128) (128) (myShapes model)
  }
