# hstar
Hedgehog Escape Solver https://www.youtube.com/watch?v=mArq6JzFqOk


## Setup
Download or clone the repo
open hstar/hstar.xcodeproj

## Run
Press Cmd+U to run the tests

Or open hstar/hstarTests/hstarTests.swift and press Cmd+alt+ctrl+U


## Create your own Test Case
In hstarTests.swift, create a new test function with a starting condition and a list of obstacles

The HStar.shortestPath(...) function will return a list of hedges, which contain the lower left position of the hedge and an orientation, including the start position. 

If no path was found, the result will be an empty list

    func testHedgeFromVideoAt1m25s()
    {
        //create a starting hedge
        let start = Hedge(
            position: Position(x: 1, y: 4), //position
            orientation: Orientation(top: .five, north: .four) //top could have also been .two
        )
        //list of obstacle positions
        let obstacles = Set<Position>([
            Position(x: 1, y: 3),
            Position(x: 2, y: 4),
            Position(x: 3, y: 2),
            Position(x: 6, y: 5)
        ])
        //get the shortest path to the goal including the start node
        let path = try! HStar.shortestPath(from: start, obstacles: obstacles)
        XCTAssert(path.count > 0)
        XCTAssertEqual(9, path.count)
    }
    
## Hedge Face Model

The hedge faces are numbered like die, and have been assigned in the following way:

         ___
     ___|_3_|________
    |_2_|_1_|_5_|_6_|
        |_4_|
 
 
            |3|3|
            | | |
            |3|3|
    |2| |2| |1|1| |5| |5| |6|6|
    |2|2|2| |1|1| |5|5|5| |6|6|
            |4|4|
            |4|4|
            |4|4|
             
## Exceptions

Bad orientations will throw HedgeError.invalidOrientation 

## Caveats

I'm still learning Swift, especially when it comes to the best way to throw exceptions, the best usages of ? and !, unowned and weak, and the best way to test my code. 

This project is far from perfect and any and all feedback is appreciated. 

## Bonus

Run the application and try to solve it yourself! (Please don't judge me on it's beauty. This is a tech demo only. The UI is as ugly as it can possibly be, and the views are not unit tested.)

