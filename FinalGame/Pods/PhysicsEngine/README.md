CS3217 Problem Set 4
==

**Name:** Calvin Tantio

**Matric No:** A0160601X

**Tutor:** Wang Xien Dong

## Tips

1. CS3217's Gitbook is at https://www.gitbook.com/book/cs3217/problem-sets/details. Do visit the Gitbook often, as it contains all things relevant to CS3217. You can also ask questions related to CS3217 there.
2. Take a look at `.gitignore`. It contains rules that ignores the changes in certain files when committing an Xcode project to revision control. (This is taken from https://github.com/github/gitignore/blob/master/Swift.gitignore).
3. A SwiftLint configuration file is provided for you. It is recommended for you to use SwiftLint and follow this configuration. Keep in mind that, ultimately, this tool is only a guideline; some exceptions may be made as long as code quality is not compromised.
    - Unlike previous problem sets, you are creating the Xcode project this time, which means you will need to copy the config into the folder created by Xcode and [configure Xcode](https://github.com/realm/SwiftLint#xcode) yourself if you want to use SwiftLint. 
4. Do not burn out. Have fun!

## Problem 1: Design

## Problem 1.1

![class-diagram](https://github.com/cs3217/2018-ps4-CT15/blob/master/class-diagram.png "Class Diagram")

Similar to PS3, the **Model** consists of `Bubbles` and `Bubble` class. `Bubbles` still represents the collection of `Bubble` in the grid. The data processing related to the removal of bubbles (floating and cluster) and addition of bubbles to the grid is done by `Bubbles`. There is an additional `Shooter` class to store all the information related to the shooter such as the total bubble ammunition, the switching of the current bubble and next bubble, the loading of the shooter, etc. Since `Bubble` is a moving object, it conforms to the `MovingObject` protocol. This fascilitates the bubble traveling from the shooter after it is fired until it stops moving.

The **View** consists of two major areas. The `BubbleGrid` area and the `ShooterView` area. The `BubbleGrid` area is where the player can tap to shoot the bubbles and where the bubbles will snap into the grid (invisible). Similar to PS3, `BubbleGrid` is made up of `BubbleGridCell`s. The `ShooterView` displays the current bubble and the next bubble in the shooter. User can tap on either one of the bubbles (current or next) to switch the current bubble with the next bubble. All the processing of the user action is done in the `PlayingAreaViewController`; hence, both views have `PlayingAreaViewController` as their delegate.

The **Controller** (`PlayingAreaViewController`) relays information between the **Model** and **View**. Again, similar to what I have done in PS3. This time round, the implementation of the **View** updating / rendering functions are defined in `Renderer` structure for a cleaner and shorter `PlayingAreaViewController` code.

`GameMath` is a structure containing static function that helps any game related calculation such as fnding the distance between two points. `Constants` structure and `BubbleColor` enumeration are self explanatory.

Note that I have `MainViewController` class. `MainViewController` will be used to "enable" / "disable" its child ViewControllers and their respective Views. This fascilitates the changing of screen, for example, from LevelDesigner screen to PlayingArea screen.

## Problem 1.2

In my implementation, most of the computation / data processing is done in the `Bubbles` object, and the rendering is done by the `Renderer` functions. Thus, if I want to extend my game logic, extension will be mostly done there. For example, for the removal of all bubbles of the same color (Star bubble), I could add a new function for the `Bubbles` class that checks all the `Bubble` values in the `bubblesDictionary` and remove all key-value pairs that have `Bubble` of a particular color as the values. After taht, I can call `Renderer.setImagesIn()` to update the `BubbleGrid` view based on the new data provided by the `Bubbles` object. As the newly added function in `Bubbles` will be made to return an array of all the bubbles removed (similar to `removeFloatingBubble()` and `popBubblesStartingFrom()` functions), this data can be fetched to the `Renderer.animateFadingBubbles()` function for the fading animation.

Another example is the removal of adjacent bubbles (Bomb bubble). `Bubbles` class already contains the function `getNeighboursOf()` that can be used to find the adjacent index path of the cell that surrounds the specified index path (`removeBubbleAt()` function takes in an index path argument) . Hence, removal of adjacent bubbles is not an issue. Similarly, the removal of bubbles in the same row (Lightning Bubble) can be easily done by checking the `bubblesDictionary` for `IndexPath` with the same `section` as the specified index path before removing them. Again, `Renderer` functions will be called to do the appropriate animations and updating of the `BubbleGrid` view.

The implementation of Indestructible Bubble is a little bit different but relatively simple as well. There will be a new enum case for the Indestrcutible Bubble. Since the shooter is implemented in such a way that it can only shoot bubbles of color `.blue`, .`red`, `.orange` and `.green`.  The Indestructible Bubble can never be popped (but can be removed as a floating bubble). This is because `popBubblesStartingFrom()` function in `Bubbles` class always check for similar color, and the color of Indestructible Bubble will never be the same as the bubble fired by the shooter.  On the other hand, `removeFloatingBubble()` function in `Bubbles` class does not check color when removing bubble, but rather connectedness with the bubbles at section 0 of the grid.

Note: I may change the enum `BubbleColor` to a more apt enum name, e.g `BubbleType` because `BubbleColor` of `.indestructible` sounds weird. This can be easily refactored using Xcode.

## Problem 2.1

I have a `Shooter` object whose job is to shoot bubble. The shooter has an attribute `center`. This is the center where the bubble shot will begin its motion. When the player taps on the screen, the location where the tap happens will be recorded. A `CGVector` will be constructed with the center of the shooter as the source and the tap location as the destination.

Every time the shooter shoots a bubble, it returns that `Bubble` object. This `CGVector` is then assigned to the `directionVector` attribute of the `Bubble` object returned by the shooter. In `Bubble` object's `move()` function (conformance to `MovingObject` protocol), the `dx` and `dy` of the `CGVector` will be scaled down such that `dy` is equal to 1 before multiplying both `dx` and `dy` with `bubbleSpeed` (constant) to get `xVelocity` and `yVelocity` of the bubble.

Every time the `move()` function is called, the `Bubble` object will changes its `center` as follows:
```swift
center.x += xVelocity
center.y += yVelocity
```
The `Renderer` renders the moving bubble image on the screen by changing the center of the `UIImageView` according to the `center` of the `Bubble` object.

The `Shooter` object handles the new bubble provision internally (`private`). Every time `shootBubble()` is called, a `private` function `loadBubble()` will be called. The checking of whether there are any bubbles left in the shooter is also done inside the `Shooter` object. For this PS, I have set the bubble ammunition to 50 bubbles (constant).

My playing area `view` is separated into two parts as indicated by the diagram below.

![playing-area-view](https://github.com/cs3217/2018-ps4-CT15/blob/master/playing-area-view.png "Playing Area View")

To make sure that the player can only shoot bubble upwards, `UITapGestureRecognizer` is only added to the `BubbleGrid` section. In this way, when the player taps on the `ShooterView` section, nothing will happen (although the shooter bubble is already located at the lowest point, we still to make sure that the player does not shoot horizontally).

## Problem 3: Testing

1. Black-box testing
    - Test bubble launching
        - When I tap at the region where the angle between the tap location and the center of the current shooter bubble does not allow the bubble to travel upwards (i.e. tap at horizontal position), I expect nothing to happen.
        - When I tap at the region where the angle between the tap location and the center of the current shooter bubble allows the bubble to travel upwards, I expect the current bubble at the shooter to be fired, the next bubble to replace the current bubble and a new bubble to replace the next bubble.
        - When I tap anywhere on the screen to launch bubble while a bubble has not stopped / snapped to a grid, I expect no bubble to be launched.
        - **Note**: The **current** bubble is located at the middle. The **next** bubble is located at the side.
    - Test bubble movement
        - When I launch the bubble (refer to the bubble launching test above) towards any of the side walls, I expect the moving bubble to travel at a constant speed and change direction when it hits the wall.
        - **Note**: The bubble speed varies depending on the angle when it is fired. However, the bubble will maintain constant speed once it is fired until it stops.
    - Test bubble collisions and snapping to grid cells
        - When I launch the bubble (refers to the first test above), I expect the bubble to stop moving when it collides with another bubble in the arena or the top wall. When the bubble stops moving, I expect to observe the bubble to snap into the isometric bubble grid (invisible).
        - **Note**: The snapping of the bubble into the grid means that sometimes, I will expect a shift in the position of the bubble after it stops moving.
    - Test removal of connected bubbles of the same color
        - When I successfully launch the bubble towards a cluster of bubble such that the cluster of bubbles contains 3 or more bubbles with the same color, I expect to observe that the cluster of bubble fades away (fade out animation).
    - Test removal of unattached bubbles
        - When a cluster of bubbles fades away (refer to connected bubble removal test above), I will expect to observe that bubbles that become floating (not connected to the bubbles on the top wall) falls out of the screen (falling animation).
    - Test shooter bubbles
        - If I keep shooting the bubble, I expect the shooter to run out of bubble after 50 shots (not able to shoot bubble anymore).
        - When I tap either the current bubble or the next bubble, I expect the color of the current bubble and the next bubble to switch (if I keep tapping, the colors will switch back and forth).
        - **Note**: The **current** bubble is located at the middle. The **next** bubble is located at the side.
        - **Note**: If the next bubble is empty (black circle), tapping on either one of the bubble will not do anything.
    - Test bubble crossing the limit line
        - When the bubbles on the screen form a cluster deep enough to reach the red line, I expect all the bubbles on the screen to disappear (no animation).
        - **Note**: This implementation is only for PS4 to simulate GAME OVER condition. This will be modified in PS5.

2. Glass-box testing
    - Test Shooter
        - Test construction
            - After construction (init), I expect the `currentBubble` and `nextBubble` attributes to have values of `Bubble` objects (random color), `bubbleRemaining` to have a value of `Int` 49 and  `center` to have a value of `CGPoint`.
        - Test shootBubble
            - Checks the `currentBubble` and store it as an immutable reference.
            - Checks the `nextBubble` and store it as an immutable reference.
            - Checks the `bubbleRemaining` and store it as an immutable value.
            - Calls `shootBubble()` function. I expect the `Bubble` object returned should have the same reference as the immutable reference of `currentBubble` stored previously.
            - **Note**: The `Bubble` object can be `nil` (when there is no more bubble in the shooter).
            - Checks the `bubbleRemaining`. I expect the `bubbleRemaining` value to be 1 lesser than the previously checked `bubbleRemaining` value stored.
            - **Note**: The `bubbleRemaining` value will remain the same only if it is already 0 when it is first checked.
            - Checks the `currentBubble`. I expect the `currentBubble` to points to the same reference as the immutable reference to `nextBubble` stored previously (can be `nil`).
        - Test switchBubble
            - If both the `currentBubble` and the `nextBubble` are not nil, when I call `switchBubble()` function, I expect `currentBubble` and `nextBubble` to switch.
            - If either one or both of `currentBubble` and `nextBubble` is / are `nil`, when I call `switchBubble()` function, I expect `currentBubble` and `nextBubble` to still have their original bubble reference (nothing changes).
        - Test loadBubble (private)
        - Test loadNextBubble (private)
        - **Note:**: Both `loadBubble()` and `loadNextBubble()` are privately invoked when `shootBubble()` is called. The shootBubble test above has also tested the behaviour of these two private functions.
    - Test Bubble
        - Test convenience construction
            - When I contruct `Bubble` object by calling its `convenience init()` function, I expect `color` to be either `.blue`, `.red`, `.orange` or `.green`, `center` to be `CGPoint` provided in the contructor argument, `bubbleImage` to match the color of the bubble and `directionVector` of `nil`.
        - Test construction
            - When I contruct `Bubble` object by calling its `init()` function, I expect `color` to be `BubbleColor` specified in the argument, `center` to be `CGPoint` provided in the contructor argument, `bubbleImage` to match the color of the bubble and `directionVector` of `nil`.
        - Test cycleColor
            - If the bubble `color` is `.none`, when I call `cycleColor()` function, I expect nothing to happen. The `color` value should remain `.none`.
            - If the bubble `color` is not `.none`, when I call `cycleColor()` function multiple times, I expect the `color` of the bubble to changes in the following order: `.blue` ->` .red` ->  `.orange` ->  `.green` -> `.blue`.
        - Test move
            - If the `directionVector` of a bubble is `nil`, when `move()` is called, I expect nothing to happen.
            - If the `directionVector` of a bubble is not `nil`, when `move()` is called, I expect the `center` to "move" in the direction of the `directionVector`.
        - Test reverseDirection
            - If the `directionVector` of a bubble is `nil`, when `reverseDirection()` is called, I expect nothing to happen.
            - If the `directionVector` of a bubble is not `nil`, when `reverseDirection()` is called, I expect the `directionVector` to have the same `dy` value (sign and magnitude) and `dx` of the opposite sign (same magnitude).
        - Test doesHitSideWall
            - If the `center` of the bubble object is such that `center.x + Constants.bubbleRadius >= Constants.screenWidth` (hits right wall) or  `center.x - Constants.bubbleRadius <= 0` (hits left wall), I expect `doesHitSideWall` to return `true`.
            - Otherwise, I expect `doesHitSideWall` to return `false`.
        - Test doesHitTopWall
            - If the `center` of the bubble is such that `center.y - Constants.bubbleRadius <= 0`, I expect `doesHitTopWall` to return `true`.
            - Otherwise, I expect `doesHitTopWall` to return `false`.
    - Test Bubbles
        - Test construction
            - When I contruct `Bubbles` object by calling its `init()` function, I expect `bubblesDictionary` to be an empty dictionary.
        - Test getBubbleAt
            - If cell at `indexPath` specified does not contain bubble, I expect `getBubbleAt()` function to return `nil`.
            - If cell at `indexPath` specified contains bubble, I expect `getBubbleAt()` function to return the bubble object contained in the cell.
        - Test removeBubbleAt
            - If cell at `indexPath` specified does not contain bubble, I expect `removeBubbleAt()` to do nothing.
            - If cell at `indexPath` specified contains bubble, I expect `removeBubbleAt()` function to remove the key value pair with key of `indexPath` from `bubblesDictionary`.
        - Test addBubbleAt
            - If the color of the `bubble` argument is `.none`, I expect `addBubbleAt()` function to do nothing.
            - If the color of the `bubble` argument is not `.none`, I expect `addBubbleAt()` function to add the value `bubble` to `bubblesDictionary` with key of `indexPath`.
        - Test removeAllBubbles
            - When I call `removeAll()` function, I expect `bubblesDictionary` to become an empty dictionary.
        - Test getIndexPathsOfFilledCells
            - If `bubblesDictionary` is empty, I expect `getIndexPathsOfFilledCells()` function to return an empty array.
            - If `bubblesDictionary` is not empty, I expect `getIndexPathsOfFilledCells()` function to return an an array containing all the keys (`IndexPath`) of `bubblesDictionary`.
        - Test getAllBubblesInGrid
            - If `bubblesDictionary` is empty, I expect `getAllBubblesInGrid()` function to return an empty array.
            - If `bubblesDictionary` is not empty, I expect `getAllBubblesInGrid()` function to return an an array containing all the values (`Bubble`) in `bubblesDictionary`.
        - Test intersectWith
            - If the `bubble` argument's `center` attribute has a distance of less than `Constants.bubbleDiameter` from the `center` of any one bubbles in the `bubblesDictionary`, I expect `intersectWith()` function to return `true`.
            - Otherwise, I expect `intersectWith()` function to return `false`.
        - Test containsBubbleInLastSection
            - If the `bubbesDictionary` contains at least a key (`IndexPath`) with `section` equals to `Constants.totalGridSections - 1`, I expect `containsBubbleInLastSection()` function to return `true`.
            - Otherwise, I expect `containsBubbleInLastSection()` function to return `false`.
        - Test popBubblesStartingFrom
            - If `startingIndexPath` argument is not one of the `bubblesDictionary`'s keys, I expect `popBubblesStartingFrom()` function to return and empty array and `bubblesDictionary` to remain unchanged.
            - If the bubble grid (represented by the `bubblesDictionary`) does not contain a cluster of 3 bubbles or more with the same color starting from the bubble at the specified `startingIndexPath`, I expect `popBubblesStartingFrom()` function to return and empty array and `bubblesDictionary` to remain unchanged.
            - Otherwise, I expect `popBubblesStartingFrom()` function to return a `Bubble` array of the bubbles in the cluster removed and all the key value pairs with keys equal to the bubbles removed to be removed from  `bubblesDictionary`.
        - Test removeFloatingBubble
            - If the `bubblesDictionary` is empty, I expect `removeFloatingBubble()` to return an empty array and the `bubblesDictionary` to remain empty.
            - If the bubble grid (represented by the `bubblesDictionary`) does not contain any bubbles that are unreachable from the bubbles located at the top section (section 0) of the grid, I expect `removeFloatingBubble()` to return an empty array and the `bubblesDictionary` to remain unchanged.
            - Otherwise, I expect `removeFloatingBubble()` function to return a `Bubble` array of the bubbles unreachable from the bubbles locted at the top section of the grid and all the key value pairs with keys equal to the bubbles removed to be removed from  `bubblesDictionary`.
        - Test getNeighboursOf (private)
        -**Note**: `getNeighboursOf()` is privately invoked when `popBubblesStartingFrom()` and `removeFloatingBubble()` are called. The popBubblesStartingFrom test  and removeFloatingBubble test above have also tested the behaviour of this private function.
    - Test GameMath
        - Test distance
            - Input two `CGPoint`s as the argument to `distance()` function, for example `CGPoint(x: 1.0, y: 1.0)` and `CGPoint(x:2.0, y: 3.0)`.
            - Compare the value returned by `distance()` function with the values computed manually using Pythagoras Theorem.
            - I expect the two values compared to be the same.
    - **Note**:  Similar to PS3, glass-box testing is done on the Model and GameMath because they process and compute data. As View's job is only to display the changes made to the Model, black-box testing is sufficient to test whether the View is displaying what it is expected to display. The Controller and Renderer, similarly, only acts as a link between the Model and the View. As long as we know that the Model and the View is working correctly, we can be sure that Controller and Renderer has translated the Model data to the View correctly.
