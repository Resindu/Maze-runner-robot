/* maze
 * Author: Resindu
 * Creation date: 12/19/2019
 */
MACHINE
    maze
    
    SETS
    
    OUTPUTMESSAGE={Yes,No}

    CONSTANTS

    entrySquare,
    exitSquare,
    xAxis,
    yAxis,
    blackSquares

    PROPERTIES
    
    xAxis <: NATURAL1 &
    xAxis = 1..7 &
    yAxis <: NATURAL1 &
    yAxis = 1..5 &
    entrySquare: NATURAL1 <-> NATURAL1 &
    entrySquare = {(1 |-> 1)} &
    exitSquare: NATURAL1 <-> NATURAL1 &
    exitSquare = {(1 |-> 5)} & 
    blackSquares: NATURAL1 <-> NATURAL1 &
    blackSquares = {(1 |-> 3), (2 |-> 1), (2 |-> 3), (2 |-> 5), (3 |-> 3), (4 |-> 2), (4 |-> 3), (4 |-> 4), 
                (6 |-> 1), (6 |-> 2), (6 |-> 4), (7 |-> 4)}

    VARIABLES

    xVisited,
    yVisited,
    visitedRoute

    INVARIANT
    
    xVisited: NATURAL &
    yVisited: NATURAL &
    visitedRoute: seq(INTEGER* INTEGER)

    INITIALISATION
    
    visitedRoute := [] ||
    xVisited := 0 ||
    yVisited := 0

    OPERATIONS

    //Update the grid

   updateAll(updatedXAxis, updatedYAxis, updatedRoute)  =
   PRE
       updatedXAxis: NATURAL1 & updatedYAxis: NATURAL1 & updatedRoute: seq(INTEGER * INTEGER)    
   THEN
       visitedRoute := updatedRoute ||
       xVisited := updatedXAxis ||
       yVisited := updatedYAxis
   END;
   
   //Checking whether the robot has

   exitFound  <-- foundExit  =
   IF
       ((xVisited |-> yVisited) : exitSquare) 
   THEN
       exitFound := Yes
   ELSE
       exitFound := No
   END;

   //Get the visited square position on the maze

   isVisited  <-- visitedSquare(xPoint, yPoint)  =
   PRE    
       xPoint : xAxis &
       yPoint : yAxis
   THEN
       IF
             ((xPoint |-> yPoint) : ran(visitedRoute) )
           
       THEN
           isVisited := Yes
       ELSE
           isVisited := No
       END
   END;

//Get the robot's route through the mazegrid

   robotRoute  <-- robotsRoute  =
   BEGIN 
       robotRoute:= visitedRoute
    
   END

END
