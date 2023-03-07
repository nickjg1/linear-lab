{--------------------------------------- GIT REQUIREMENTS ---------------------------------------}
module Main exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.Widget as Widget exposing (..) 
import GraphicSVG.EllieApp as EllieApp exposing (..)
import GraphicSVG.App as App exposing (..)

-- default GetKeyState to EllieApp version
import GraphicSVG.EllieApp exposing (GetKeyState)

{--------------------------------------- IMPORTS ---------------------------------------}
import Dict exposing (Dict)

{--------------------------------------- COORDINATES AND VECTORS ---------------------------------------}

type alias Coordinate2D = (Float, Float)
type alias Vector2D = Coordinate2D

-- Default Vector2D for Maybe conversion
defaultVector2D = (0, 0)

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
defaultMatrix2D = [ (0, 0), (0, 0) ]

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
    case (length1==length2) of
      False -> Nothing
      True -> Just (List.map2 add m1 m2)
      
-- Subtracts all entries of two Matrix2Ds
subtractMatrix2D : Matrix2D -> Matrix2D -> Maybe Matrix2D
subtractMatrix2D m1 m2 = 
  let
    length1 = List.length m1
    length2 = List.length m2
  in
    case (length1==length2) of
      False -> Nothing
      True -> Just (List.map2 subtract m1 m2)

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
    case (length1==length2 && length1==2) of
      False -> Nothing
      True -> let
                
                {-
                [a, b    [w, x
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

-- String representation of Vector2Ds
printMatrix2D : Matrix2D -> String
printMatrix2D m = Debug.toString m

{--------------------------------------- LINE TYPE ---------------------------------------}

type LineType = Solid Float
              | Dotted Float
              | Dashed Float
              | Directional Float
              | Bidirectional Float
           
-- Default LineType
defaultLineType = Solid 1

{--------------------------------------- GRID ---------------------------------------}

type alias Grid2D = 
  { transformationMatrix : Matrix2D
  , vectorObjects : Dict Int Vector2D
  , xColor : Color
  , yColor : Color
  , xLineType : LineType
  , yLineType : LineType
  , scale : Float
  , offset : Coordinate2D
  }

-- Default Grid2D
defaultGrid2D =
  { transformationMatrix = defaultMatrix2D
  , vectorObjects = Dict.empty
  , xColor = black
  , yColor = black
  , xLineType = defaultLineType
  , yLineType = defaultLineType
  , scale = 5
  , offset = (0, 0)
  }
  
-- Creates a new Grid2D with an added Vector2D
grid2DAddVector2D : Grid2D -> Vector2D -> Grid2D
grid2DAddVector2D grid vector = 
  { grid | vectorObjects = Dict.insert (getNextKey grid.vectorObjects) vector grid.vectorObjects }
  
-- Creates a new Grid2D with a vector with specified ID removed
grid2DRemoveVector2D : Grid2D -> Int -> Grid2D
grid2DRemoveVector2D grid id = --grid
  let
    vectorObject = grid.vectorObjects
    removedGrid = Dict.remove id vectorObject
    filteredGrid = Dict.filter (\key value -> key > id) removedGrid
    shiftedGrid = Dict.fromList (List.map (\(key, value) -> (key-1, value)) (Dict.toList filteredGrid) )
    updatedGrid = Dict.union shiftedGrid removedGrid
    finalGrid = 
      case (Dict.size vectorObject == Dict.size removedGrid) of
        True -> updatedGrid
        False -> Dict.remove (Dict.size vectorObject) updatedGrid
  in 
     {grid | vectorObjects = finalGrid} 
     
grid2DScaleVector2D : Grid2D -> Int -> Float -> Grid2D
grid2DScaleVector2D grid id scalar =
  let
    vectorObjects = grid.vectorObjects
    
    updater func x = 
      case x of
        Nothing -> Nothing
        Just y -> Just (func y)
    
    finalGrid = Dict.update id (updater (scalarMultiply scalar) ) vectorObjects
    
  in
    {grid | vectorObjects = finalGrid}

{--------------------------------------- RENDER ---------------------------------------}

-- Turns a Grid2D to a Shape
renderGrid2D : Grid2D -> (Shape usermsg)
renderGrid2D grid =
  [ line (-1000, 0) (1000, 0)
      |> (case grid.xLineType of
            Solid x -> outlined (solid x)
            Dotted x -> outlined (dotted x)
            Dashed x -> outlined (dashed x)
            _ -> outlined (solid 1)
         ) grid.xColor
  , line (0, -1000) (0, 1000)
      |> (case grid.yLineType of
            Solid x -> outlined (solid x)
            Dotted x -> outlined (dotted x)
            Dashed x -> outlined (dashed x)
            _ -> outlined (solid 1)
         ) grid.yColor
  , List.map renderVector2D (List.map (scalarMultiply grid.scale) (Dict.values grid.vectorObjects))
      |> group
  ] |> group
    |> move grid.offset

-- Turns a Vector2D to a Shape
renderVector2D : Vector2D -> (Shape usermsg)
renderVector2D vector =
  line (0, 0) vector
    |> outlined (solid 1) black
 

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

-- @private getNextKey helper
getNextKeyHelper : Dict Int a -> Int -> Int                             
getNextKeyHelper dict index = 
  case (index > (Dict.size dict)) of
    True -> (Dict.size dict) + 1
    False ->
      case (Dict.member index dict) of
        True -> getNextKeyHelper dict (index + 1)
        False -> index
    

{--------------------------------------- MESSAGES ---------------------------------------}

-- Add messages here
type Msg = Tick Float GetKeyState
         | AddVector2D Vector2D Int -- Add (Vector2D) to (Grid with key Int)
         | RemoveVector2D Int Int -- Remove a vector with (ID Int) from (Grid with key Int)
         | ScaleVector2D Int Int Float -- Scale a vector with (ID Int) from (Grid with key Int) by (Scalar)

-- Your update function goes here
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
    Tick t _ -> ( { model | time = t }, Cmd.none )
    AddVector2D vector gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 grid2DAddVector2D theGrid (Just vector)
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
        
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    RemoveVector2D vId gridKey -> 
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map2 grid2DRemoveVector2D theGrid (Just vId)
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
    ScaleVector2D vId gridKey scalar ->
      let
        theGrid = Dict.get gridKey model.grids
        
        updatedGrid = Maybe.map3 grid2DScaleVector2D theGrid (Just vId) (Just scalar)
        
        updatedGridModel = case updatedGrid of
                             Nothing -> model.grids
                             Just newGrid -> Dict.insert gridKey newGrid model.grids
      in
        ( { model | grids = updatedGridModel }, Cmd.none )
      

{--------------------------------------- DEBUG ---------------------------------------}

-- Your shapes go here
myShapes model = 
  [ List.map renderGrid2D (Dict.values model.grids)
      |> group
  , [rectangle 30 15 |> filled blue, text "add (5,5)" |> filled white |> scale 0.2] |> group |> move (-90, 40) |> notifyTap (AddVector2D (5, 5) 1)
  , [rectangle 30 15 |> filled blue, text "add (1,0.5)" |> filled white |> scale 0.2] |> group  |> move (-90, 0) |> notifyTap (AddVector2D (1, 0.5) 1)
  , [rectangle 30 15 |> filled blue, text "remove id 2" |> filled white |> scale 0.2] |> group  |> move (-90, -40) |> notifyTap (RemoveVector2D 2 1)
  , [rectangle 30 15 |> filled blue, text "scalar id 2 by 3" |> filled white |> scale 0.2] |> group  |> move (90, -40) |> notifyTap (ScaleVector2D 1 1 3)
  , text (Debug.toString (Maybe.withDefault defaultGrid2D (Dict.get 1 model.grids)).vectorObjects) |> filled red |> scale 0.25 |> move (-50, -40)
  ]

-- This is the type of your model
type alias Model = 
  { time : Float 
  , grids : Dict Int Grid2D
  }

-- Your initial model goes here
init : Model
init = { time = 0, 
         grids = Dict.fromList [(1, defaultGrid2D)]
       }

-- Your subscriptions go here
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- Your main function goes here
main : EllieAppWithTick () Model Msg
main = 
  ellieAppWithTick Tick 
    { init = \flags -> (init, Cmd.none)
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Your view function goes here
view : Model -> { title: String, body : Collage Msg }
view model = 
  {
    title = "Vector Visualizer Library"
  , body = collage (192) (128) (myShapes model)
  }

