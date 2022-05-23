# Toy Robot Simulator

## Description

- The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
- There are no other obstructions on the table surface.
- The robot is free to roam around the surface of the table, but must be prevented from falling to destruction. Any movement that would result in the robot falling from the table must be prevented, however further valid movement commands must still be allowed.

The application can read the following commands from a specified file or the standard input:

- PLACE X,Y,F
- MOVE
- LEFT
- RIGHT
- REPORT

<br>

- PLACE puts the toy robot on the table in position X,Y and facing NORTH, SOUTH, EAST or WEST.
- The origin (0,0) can be considered to be the SOUTH WEST most corner.
- The first valid command to the robot is a PLACE command, after that, any sequence of commands may be issued, in any order, including another PLACE command. The application discards all commands in the sequence until a valid PLACE command has been executed.
- MOVE moves the toy robot one unit forward in the direction it is currently facing.
- LEFT and RIGHT rotate the robot 90 degrees in the specified direction without changing the position of the robot.
- REPORT announces the X,Y and F of the robot to the standard output.

## Constraints

- The toy robot must not fall off the table during movement. This also includes the initial placement of the toy robot.
- Any move that would cause the robot to fall must be ignored.

## Example Input and Output

### Example a

> PLACE 0,0,NORTH  
> MOVE  
> REPORT

Expected output:
0,1,NORTH

### Example b

> PLACE 0,0,NORTH  
> LEFT  
> REPORT

Expected output:
0,0,WEST

### Example c

> PLACE 1,2,EAST  
> MOVE  
> MOVE  
> LEFT  
> MOVE  
> REPORT

Expected output:
3,3,NORTH
