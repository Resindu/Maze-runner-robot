/* robot
 * Author: Resindu
 * Creation date: 12/19/2019
 */
MACHINE
    robot

    INCLUDES
        maze
        
    PROMOTES
        foundExit, visitedSquare, robotsRoute
        
    SETS
        DIRECTIONS = {
            North, 
            South, 
            East, 
            West
        };
    
        MESSAGE = {
            MoveSuccessful, 
            CannotMoveInternalWallDetected, 
            CannotMoveExternalWallDetected, 
            TeleportSuccessful,
            CannotTeleportImmediatelyToExitOnStart,
            CannotTeleportToInternalWalls,
            CannotTeleportToCurrentSquare
            
        }
        
    VARIABLES
    
        visitedDirection,
        visitedPath,
        xPosition,
        yPosition
            
    INVARIANT
        
        visitedDirection: seq(DIRECTIONS) &
        visitedPath: seq(INTEGER * INTEGER) &
        xPosition: NATURAL1 &
        yPosition:NATURAL1 &
        xPosition: xAxis &
        yPosition: yAxis
        
    INITIALISATION
        
        visitedDirection := [] ||
        visitedPath := [] ||
        xPosition := 1 ||
        yPosition := 1
    
    OPERATIONS
    
    //Moving to North 
    
       message  <-- moveNorth  =
        IF
            ((xPosition|-> yPosition  + 1 ) /: blackSquares & 
            (yPosition + 1 : yAxis))
        THEN
            yPosition := yPosition + 1 ||
            visitedDirection := visitedDirection <- North ||
            visitedPath := visitedPath <- (xPosition |-> yPosition) ||
            updateAll(xPosition, yPosition +1, visitedPath <- (xPosition  |-> yPosition)) ||
            message := MoveSuccessful
        ELSIF
            (yPosition +1 /:  yAxis)
    	      THEN 
    	          message := CannotMoveExternalWallDetected
    	 ELSE 
    	     message := CannotMoveInternalWallDetected
        END;
    
    //Moving to South 
    
       message  <-- moveSouth  =
        IF
            ((xPosition |-> yPosition -1) /: blackSquares & 
            (yPosition - 1 :  yAxis))
        THEN
            yPosition := yPosition - 1 ||
            visitedDirection := visitedDirection <- South ||
            visitedPath := visitedPath <- (xPosition |-> yPosition) ||
            updateAll(xPosition, yPosition -1, visitedPath <- (xPosition  |-> yPosition)) ||
            message := MoveSuccessful
        ELSIF
            (yPosition - 1 /:  yAxis)
    	      THEN 
    	          message := CannotMoveExternalWallDetected
    	 ELSE 
    	     message := CannotMoveInternalWallDetected
        END;
    
    //Moving to East 
    
       message  <-- moveEast  =
        IF
            ((xPosition +1  |-> yPosition) /: blackSquares & 
            (xPosition + 1 : xAxis))
        THEN
            xPosition := xPosition + 1 ||
            visitedDirection := visitedDirection <- East ||
            visitedPath := visitedPath <- (xPosition  |-> yPosition) ||
            updateAll(xPosition + 1, yPosition, visitedPath <- (xPosition  |-> yPosition)) ||
            message := MoveSuccessful
        ELSIF
            (xPosition + 1 /:  xAxis)
    	      THEN 
    	          message := CannotMoveExternalWallDetected
    	 ELSE 
    	     message := CannotMoveInternalWallDetected
        END;
        
    //Moving to West 
    
       message  <-- moveWest  =
        IF
            ((xPosition  - 1 |-> yPosition) /: blackSquares & 
            (xPosition - 1 : xAxis))
        THEN
            xPosition := xPosition - 1 ||
            visitedDirection := visitedDirection <- West ||
            visitedPath := visitedPath <- (xPosition |-> yPosition) ||
            updateAll(xPosition - 1, yPosition, visitedPath <- (xPosition  |-> yPosition)) ||
            message := MoveSuccessful
        ELSIF
            (xPosition - 1 /: xAxis)
    	      THEN 
    	          message := CannotMoveExternalWallDetected
    	 ELSE 
    	     message := CannotMoveInternalWallDetected
        END;
        
    //Get the current position on the maze
    
       currentPosition  <-- getPosition  =
       BEGIN 
           currentPosition := (xPosition|-> yPosition)
       END;
    
    //Teleportation
    
       teleportMessage  <-- teleport(xTeleport, yTeleport)  =
       PRE
           xTeleport : xAxis &
           yTeleport : yAxis 
       THEN
           IF
                ((xTeleport |-> yTeleport) /: blackSquares &
                 ((xTeleport /= xPosition)or  
                  (yTeleport /= yPosition))&    
                ((xTeleport|-> yTeleport) /: exitSquare or
                (xPosition |-> yPosition) /: entrySquare)) 
           THEN
               xPosition := xTeleport ||
               yPosition := yTeleport ||
               teleportMessage := TeleportSuccessful ||
    		     visitedPath := visitedPath <- (xPosition |-> yPosition) ||
    		     updateAll(xTeleport, yTeleport, visitedPath <- (xPosition  |-> yPosition))
           ELSE IF
                   ((xTeleport |-> yTeleport) : blackSquares)
               THEN
                   teleportMessage := CannotTeleportToInternalWalls
           ELSE IF
                  ((xTeleport |-> yTeleport) : exitSquare)
               THEN
                   teleportMessage := CannotTeleportImmediatelyToExitOnStart         
              
            ELSE IF
                  ((xTeleport = xPosition)or  
                  (yTeleport = yPosition))
               THEN
                   teleportMessage := CannotTeleportToCurrentSquare         
           
        
               END
           END
           END
           END
       END
    
END
