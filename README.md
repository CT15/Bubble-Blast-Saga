# Bubble Blast Saga

## Rules

- Normal Puzzle Bobble rules applies
- When the bubbles reaches the red line, the player loses
- Special bubbles (depending on their effects) do not guarantee the popping of the bubble shot
    - For example, if the bubble shot hits a lightning bubble but does not snap into the same grid section / row, it will not pop (but it will fall anyway)
- Magnetic and indestructible bubbles can never be popped even by special bubbles

## Class Diagram Sketch

![class-diagram](https://github.com/cs3217/2018-ps5-CT15/blob/master/class-diagram.jpeg "Class Diagram")

For the **Controller**, I have MainViewController which has reference to all other controllers. This makes navigation from one Controller to another Controller easier. This also reduces a lot of boilerplate code for adding and removing child ViewController. The continuous audio that plays in the background will also only need to be initialised once in the MainViewController.

For the **Model**, there are three classes that conforms to SpecialPopBubble protocol and subclass Bubble. The MovingObject protocol is supposed to act as a conformance to physics law. Since Bubble conforms to MovingObject, it can detect collision, move and halt.

For the **View**, Cannon class has been created separately from the rest of the ShooterView because of the need to store additional information such as the sprite images, animation loop count, animation duration, etc. The separation makes the code neater. Another UICollectionView is created, called LevelList. It contains many LevelListCell, just like BubbleGrid that contains many BubbleGridCell.

All the **View**s have **Controller** as their delegates to process user action such as button press or tapping on the playing area or level designer.

## Testing Instruction

Black-box testing:
- Test background music
    1. As long as the application is open, I expect to hear background music.
- Test Main Menu
    1. Tap "LEVEL SELECTION" button
    Expected outcome: Level Selection screen is displayed
    2. Tap "LEVEL DESIGNER" button
    Expected outcome: Level Designer screen is displayed
- Test Level Designer
    - Test adding bubbles into bubble grid
        - Drag to fill cell:
            1. Make sure that a non-erase palette is selected.
            2. Drag across the cells.
            Expected outcome: Regardless of whether the cells have been filled, dragging across cells when a non-erase palette is selected will fill the cells with the bubbles of the selected palette.
        - Tap to fill cell:
            1. Make sure that a non-erase palette is selected.
            2. Tap an empty cell.
            Expected outome: The empty cell will be filled with the bubble of the selected palette.
    - Test erasing bubbles from the bubble grid
        - Long press to erase a cell
            1. Long press on a filled cell (the palette chosen does not matter).
            Expected outcome: The bubble in the selected cell is removed.
        - Long press and drag to erase cells
            1. Long press on the bubble grid (the palette chosen does not matter).
            2. Drag across the cells in the grid.
            Expected outcome: The bubbles in the cells are removed as user drags across filled cells.
        - Drag to erase cells
            1. Select "Erase" palatte.
            2. Drag across the cells in the grid.
            Expected outcome: The bubbles in the cells are removed as user drags across filled cells.
        - Tap to ease a cell
            1. Select "Erase" palette.
            2. Tap on a filled cell.
            Expected outcome: The bubble in the filled cell is removed.
    - Test cycling bubble color
        - Tap to cycle bubble color
            1. Make sure that a color palette (non-special bubble) is selected (the color chosen does not matter).
            2. Tap on a cell with non-special bubble multiple times.
            Expected outcome: The color of the bubble cycles in the sequence of blue -> red -> orange -> green -> blue (repeating).
    - Test special bubble
        - Test special bubble dominance over normal bubble for tap
            1. Fill cells with special bubbles.
            2. Select any color (non-special bubble) palette.
            3. Tap on cells filled with special bubble.
            Expected outcome: The special bubble is **not** replaced by the normal color bubble.
            Note: This is only true for tap. Testing for dragging and long press are the same as done above.
    - Test resetting design
        1. Fill the cells with bubbles.
        2. Tap "RESET" button.
        Expected outcome: All the bubbles on the screen are cleared.
    - Test saving design
        1. Tap "SAVE" button while there is no bubble in the grid.
        Expected outcome: Nothing (cannot save an empty design).
        2. Design the level (fill the cells with bubbles).
        3. Tap "SAVE" button.
        Expected outcome: A popup appears
        4. Tap "SAVE" button on the popup box without filling in the Level Name.
        Expected outcome: Nothing (cannot have an empty Level Name).
        6. Tap "SAVE" button on the popup box after filling in the Level Name with white spaces.
        Expected outcome: Nothing
        7. Tap "SAVE" button on the popup box after filling in the Level Name with two words
        Expected outcome: Nothing (Level Name cannot contain white space)
        8. Tap "SAVE" button on the popup box after filling in the Level Name with very long  Level Name
        Expected outcome: Nothing (Level Name cannot be more than 10 letters)
        9. Tap "SAVE" button on the popup box after filling in the Level Name with "Level1" (without the "")
        Expected outcome: The popup disappears (indicating that the Level Name is valid and saving is successful)
        Note: Level Name is case sensitive
    - Test loading design
        1. Tap "LOAD" button
        Expected outcome: A popup appears
        2. Enters non-existent file name as the Level Name and tap "LOAD" button  on the popup box.
        Expected outcome: The popup disappears but the display in the bubble grid does not change.
        3. Enters an existing saved file name as the Level Name and tap "LOAD" butoon on the popup box.
        Expected outcome: The popup disappears and the loaded design replaces the current design in the bubble grid.
        Note: Level Name is case sensitive
    - Test start game
        1. Tap "START" button without designing the level
        Expected outcome: Nothing (cannot start a game with empty level design)
        2. Tap "START" button after designing the level / load a level
        Expected outcome: The Playing Area is displayed. If bubbles in the design are not connected to the top wall, they will immediately fall. If there is no more bubbles after these bubbles fall, a winning popup box will appear.
    - Test back button
        1. Tap "BACK" button
        Expected outcome: Back to Main Menu
    
- Test Playing Area
    - Test bubble launching
        1. When I tap at the region where the angle between the tap location and the center of the current shooter bubble does not allow the bubble to travel upwards (i.e. tap at horizontal position), I expect nothing to happen.
        2. When I tap at the region where the angle between the tap location and the center of the current shooter bubble allows the bubble to travel upwards, I expect the current bubble at the shooter to be fired, the cannon image to face the tap position (and animate shooting), the next bubble to replace the current bubble and a new bubble to replace the next bubble.
        3. When I tap anywhere on the screen to launch bubble while a bubble has not stopped / snapped to a grid, I expect no bubble to be launched.
        Note: The current bubble is located at the middle. The next bubble is located at the side.
    - Test bubble movement
        1. When I launch the bubble (refer to the bubble launching test above) towards any of the side walls, I expect the moving bubble to travel at a constant speed and change direction when it hits the wall.
        Note: The bubble speed varies depending on the angle when it is fired. However, the bubble will maintain constant speed once it is fired until it stops.
    - Test bubble collisions and snapping to grid cells
        1. When I launch the bubble (refers to the first test above), I expect the bubble to stop moving when it collides with another bubble in the arena or the top wall. When the bubble stops moving, I expect to observe the bubble to snap into the isometric bubble grid (invisible).
        Note: The snapping of the bubble into the grid means that sometimes, I will expect a shift in the position of the bubble after it stops moving.
    - Test removal of connected bubbles of the same color
        1. When I successfully launch the bubble towards a cluster of bubble such that the cluster of bubbles contains 3 or more bubbles with the same color, I expect to observe that the cluster of bubble to burst.
    - Test removal of unattached bubbles
        1. When a cluster of bubbles fades away (refer to connected bubble removal test above), I will expect to observe that bubbles that become floating (not connected to the bubbles on the top wall) falls out of the screen (falling animation).
    - Test shooter bubbles
        1. If I keep shooting the bubble, I expect the shooter to run out of bubble after 50 shots, at this point in time, I expect a popup with "YOU LOSE" status to appear.
        2. When I tap either the current bubble or the next bubble, I expect the color of the current bubble and the next bubble to switch (if I keep tapping, the colors will switch back and forth).
        Note: The current bubble is located at the middle. The next bubble is located at the side.
        Note: If the next bubble is empty (black circle), tapping on either one of the bubble will not do anything.
    - Test bubble crossing the limit line
        1. When the bubbles on the screen form a cluster deep enough to reach the red line, I expect a popup with "YOU LOSE" status to appear.
    - Test no more bubble in the grid
        1. When all the bubbles on the screen is cleared, I expect a popup with "YOU WIN" status to appear.
    - Test special bubbles:
        1. When the bubble shot hits a lightning bubble, I expect all bubbles in the same row as the lightning bubble to burst and all the hanging bubbles thereafter to fall.
        2. When the bubble shot hits the bomb bubble, I expect all the bubbles adjacent to the bomb bubble to burst and all the hanging bubbles thereafter to fall.
        3. When the bubble shot hits the star bubble, I expect all bubbles of the color of the bubble shot in the arena to burst and all the hanging bubbles thereafter to fall.
        4. When the effect activation of a special bubble results in another special bubble to burst, I expect a chaining behaviour of the special bubbles.
        5. No matter what happen, I expect the magnetic bubble and indestructible bubble to never burst. They can only fall when they are no longer connected to the top wall.
    - Test sound effect:
        1. When a cluster of bubbles burst, I expect a pop sound effect.
        2. When the cannon fires a bubble, I expect a firing sound effect.
    - Test back button:
        1. When I press the "BACK" button, I should expect to go back to the previous screen I came from (either Level Designer or Level Selection screen).
- Test Level Selection
    1. I should expect to see all the levels I have saved to be displayed in sorted (ascending) order.
    2. When I tap the "BACK" button, I expect to go back to the Main Menu screen.
    3. When I tap the "PLAY" button beside the Level Name, I expect to be brought to Playing Area with bubbles in the bubble grid as saved.
    
Glass-box testing:
- Test Shooter
    - Test construction
        1. After construction (init), I expect the currentBubble and nextBubble attributes to have values of Bubble objects (random color), bubbleRemaining to have a value of Int 49, center to have a value of CGPoint and bubbles to have a value of Bubbles.
    - Test shootBubble
        1. Checks the currentBubble and store it as `currentBubble`.
        2. Checks the nextBubble and store it as `nextBubble`.
        3. Checks the bubbleRemaining and store it as `noOfBubble`.
        4. Calls shootBubble() function. I expect the Bubble object returned should have the same reference as the `currentBubble` stored previously.
        Note: The Bubble object can be nil (when there is no more bubble in the shooter).
        5. Checks the bubbleRemaining. I expect the bubbleRemaining value to be 1 lesser than `noOfBubble` stored previously.
        Note: The bubbleRemaining value will remain the same only if it is already 0 when it is first checked.
        6. Checks the currentBubble. I expect the currentBubble to points to the same reference as `nextBubble` stored previously (can be nil).
    - Test switchBubble
        1. If both the currentBubble and the nextBubble are not nil, when I call switchBubble() function, I expect currentBubble and nextBubble to switch.
        2. If either one or both of currentBubble and nextBubble is / are nil, when I call switchBubble() function, I expect currentBubble and nextBubble to still have their original bubble reference (nothing changes).
    - Test loadBubble (private)
    - Test loadNextBubble (private)
    - Test makeBubble (private)
    Note: Both loadBubble() and loadNextBubble() are privately invoked when shootBubble() is called. The shootBubble test above has also tested the behaviour of these two private functions.
    Note: `makeBubble()` is privately invoked when `loadBubble()` is called. Testing of `makeBubble()` can be better showcased in black-box testing as it involves random bubble color value (`.red`, `.orange`, `.blue`, `.green`) . Alternatively we can pass in the following `Bubbles` object during construction:
            1. An empty `Bubbles` object. `makeBubble()` should return `Bubble` object of any of the 4 bubble color.
            2. `Bubbles` object that contains special bubbles. `makeBubble()` should return `Bubble` object of any of the 4 bubble color.
            3. `Bubbles` object with only one bubble color (non-special bubble). `makeBubble()` should return `Bubble` object that color.
- Test Bubble
    - Test construction
        1. When I contruct `Bubble` object by calling its init() function, I expect type to be BubbleType specified in the argument, center to be CGPoint provided in the contructor argument and directionVector of nil.
        2. When I construct a `Bubble` by using another `Bubble` object as an argument, I expect the constructed `Bubble` object to be the exact copy of the argument (same attribute values).
    - Test cycleColor
        1. If the bubble color is not `.red` or `.orange` or `.green` or `.blue`, when I call cycleColor() function, I expect nothing to happen. The type value should remain the same.
        2. Otherwise, when I call cycleColor() function multiple times, I expect the type of the bubble to changes in the following order: .blue ->.red -> .orange -> .green -> .blue.
    - Test getImage
        1. If the type is `.none`, I expect `getImage()` to return `nil`
        2. Otherwise, I expect `getImage()` to return bubble image (`UIImage`)corresponding to its type attribute.
    - Test move
        1. If the directionVector of a bubble is nil, when move() is called, I expect nothing to happen.
        2. If the directionVector of a bubble is not nil, when move() is called, I expect the center to "move" in the direction of the directionVector.
    - Test reverseDirection
        1. If the directionVector of a bubble is nil, when reverseDirection() is called, I expect nothing to happen.
        2. If the directionVector of a bubble is not nil, when reverseDirection() is called, I expect the directionVector to have the same dy value (sign and magnitude) and dx of the opposite sign (same magnitude).
    - Test doesHitSideWall
        1. If the center of the bubble object is such that center.x + Constants.bubbleRadius >= Constants.screenWidth (hits right wall) or center.x - Constants.bubbleRadius <= 0 (hits left wall), I expect doesHitSideWall to return true.
        2. Otherwise, I expect doesHitSideWall to return false.
    - Test doesHitTopWall
        1. If the center of the bubble is such that center.y - Constants.bubbleRadius <= 0, I expect doesHitTopWall to return true.
        2. Otherwise, I expect doesHitTopWall to return false.
- Test Bubbles
    - Test construction
        1. When I contruct Bubbles object by calling its init() function, I expect bubblesDictionary to be an empty dictionary.
    - Test isEmpty
        1. If there is no bubble in grid, I expect `isEmpty` to return `true`.
        2. Otherwise, return `false`.
    - Test getBubbleAt
        1. If cell at indexPath specified does not contain bubble, I expect getBubbleAt() function to return nil.
        2. If cell at indexPath specified contains bubble, I expect getBubbleAt() function to return the bubble object contained in the cell.
    - Test removeBubbleAt
        1. If cell at indexPath specified does not contain bubble, I expect removeBubbleAt() to do nothing.
        2. If cell at indexPath specified contains bubble, I expect removeBubbleAt() function to remove the key value pair with key of indexPath from bubblesDictionary.
    - Test addBubbleAt
        1. If the color of the bubble argument is .none, I expect addBubbleAt() function to do nothing.
        2. If the color of the bubble argument is not .none, I expect addBubbleAt() function to add the value bubble to bubblesDictionary with key of indexPath.
    - Test removeAllBubbles
        1. When I call removeAll() function, I expect bubblesDictionary to become an empty dictionary.
    - Test getIndexPathsOfFilledCells
        1. If bubblesDictionary is empty, I expect getIndexPathsOfFilledCells() function to return an empty array.
        2. If bubblesDictionary is not empty, I expect getIndexPathsOfFilledCells() function to return an an array containing all the keys (IndexPath) of bubblesDictionary.
    - Test getAllBubblesInGrid
        1. If bubblesDictionary is empty, I expect getAllBubblesInGrid() function to return an empty array.
        2. If bubblesDictionary is not empty, I expect getAllBubblesInGrid() function to return an an array containing all the values (Bubble) in bubblesDictionary.
    - Test intersectWith
        1. If the bubble argument's center attribute has a distance of less than Constants.bubbleDiameter from the center of any one bubbles in the bubblesDictionary, I expect intersectWith() function to return true.
        2. Otherwise, I expect intersectWith() function to return false.
    - Test containsBubbleOfType
        1. If the bubblesDictionary contains at least one bubble of the specified  `BubbleType`, returns `true`.
        2. Otherwise, I expect the function to return `false`.
    - Test containsSpecialBubble
        1. If the bubblesDictionary contains at least one special bubble.
        2. Otherwise, I expect the function to return `false`.
    - Test containsBubbleInLastSection
        1. If the bubblesDictionary contains at least a key (IndexPath) with section equals to Constants.totalGridSections - 1, I expect containsBubbleInLastSection() function to return true.
        2. Otherwise, I expect containsBubbleInLastSection() function to return false.
    - Test popBubblesStartingFrom
        1. If startingIndexPath argument is not one of the bubblesDictionary's keys, I expect popBubblesStartingFrom() function to return and empty array and bubblesDictionary to remain unchanged.
        2. If the bubble grid (represented by the bubblesDictionary) does not contain a cluster of 3 bubbles or more with the same color starting from the bubble at the specified startingIndexPath and the starting index path is not adjacent to any `SpecialPopBubble`, I expect popBubblesStartingFrom() function to return and empty array and bubblesDictionary to remain unchanged.
        3. Otherwise, I expect popBubblesStartingFrom() function to return a Bubble array of the bubbles in the cluster removed and all the key value pairs with keys equal to the bubbles removed to be removed from bubblesDictionary.
    - Test removeFloatingBubble
        1. If the bubblesDictionary is empty, I expect removeFloatingBubble() to return an empty array and the bubblesDictionary to remain empty.
        2. If the bubble grid (represented by the bubblesDictionary) does not contain any bubbles that are unreachable from the bubbles located at the top section (section 0) of the grid, I expect removeFloatingBubble() to return an empty array and the bubblesDictionary to remain unchanged.
        3. Otherwise, I expect removeFloatingBubble() function to return a Bubble array of the bubbles unreachable from the bubbles locted at the top section of the grid and all the key value pairs with keys equal to the bubbles removed to be removed from bubblesDictionary.
    - Test getNeighboursOf
        1. Regardless of whether or not the index path argument exists in the bubble grid, I expect the function to return an array of 6 index paths surrounding the index path specified.
    - Test getIndexPathsAtSection
        1. If the bubblesDictionary is empty, I expect the function to return an empty array.
        2. If the bubble grid (represented by the bubblesDictionary) does not contain any bubbles at the section specified, I expect the function to return an empty array.
        3. Otherwise, I expect the function to return an array of `IndexPath`s of cells with section as specified by the argument that contains bubble.
    - Test getIndexPathsWithSameType
        1. If the bubblesDictionary is empty, I expect the function to return an empty array.
        2. If index path specified does not exist in the bubble grid, I expect the function to return an empty array.
        3. If the bubble grid (represented by the bubblesDictionary) does not contain any **other** bubbles with the same type as the bubble at the index path spacified, I expect the function to return an array containing only the index path argument.
        4. Otherwise, I expect the function to return an array of `IndexPath` of all the cells containing bubbles with the same type as bubble in the specified index path (including the argument itself).
    - Test initialiseSpecialBubbles
        1. If the bubblesDictionary is empty, I expect bubblesDictionary to remain empty.
        2. If bubblesDictionary does not contain `Bubble` object of type `.bomb`, `.lightning` or `.star`, I expect bubblesDictionary to remain the same.
        3. Otherwise, I expect all `Bubble` object of type `.bomb` in bubblesDictionary to be replaced by `BombBubble` object with the exact same attribute values, all `Bubble` object of type `.lightning` in bubblesDictionary to be replaced by `LightningBubble` object with the exact same attribute values. and all `Bubble` object of type `.star` in bubblesDictionary to be replaced by `StarBubble` object with the exact same attribute values.
- Test GameMath
    - Test distance
        1. Input two CGPoints as the argument to distance() function, for example CGPoint(x: 1.0, y: 1.0) and CGPoint(x:2.0, y: 3.0).
        2. Compare the value returned by distance() function with the values computed manually using Pythagoras Theorem.
        3. I expect the two values compared to be the same.
        
Note: Similar to PS3 and PS4, glass-box testing is done on the Model and GameMath because they process and compute data. As View's job is only to display the changes made to the Model, black-box testing is sufficient to test whether the View is displaying what it is expected to display. The Controller and Renderer, similarly, only acts as a link between the Model and the View. As long as we know that the Model and the View is working correctly, we can be sure that Controller and Renderer has translated the Model data to the View correctly. The audio sound effect can be tested through simple hearing.
 
## Reflection

I think the design of my MVC architecture can still be improved further. After all, this is my first attempt in consciously applying MVC design pattern. I realise that my code has not fully spearated concerns between Model, View and Controller yet. I realise that sometimes  my data processing is done in the ViewController rather than the Model simply because I need the information from the View in order to process my data. I think this is something that I should keep in mind and work on in future projects. I also have some doubts regarding the division of resposibility between MVC. For example, should I call `UIView.animate()` and `UIImageView.startAnimating()` in the View or the Controller? This is different from `Renderer`. To me, `Renderer` is just a helper for ViewController. It takes information from the Model and display it in the View. However, `UIImageView.startAnimating()` does not require information from the Model. Also, where should I process the audio and sound effect (I did it in the ViewController)? These are some of the things that I should explore and find out more.

My Physics Engine is definitely not perfect either. This is the reason why I am having difficulty in implementing magnetic bubble and non-snapping bubble. I have tried Unity before, and I believe that in order for a `GameObject` to conform to physics law, it has to have `RigidBody` components. I tried to mimick this by creating `MovingObject` protocol and make `Bubble` conform to it. This works for basic collision detection. However, I find it hard to extend it to more complicated logic like that of magnetic bubble.

Improvement wise, I think for MVC design pattern, I have headed into the correct direction. I just have to plan more carefully before starting to code, and this will come with practise and experience. Also, I need to anticipate boilerplate code for View, especially if I am not using the storyboard, so that I do not have to spend too much time in the end to extract out these repetitions of code. For the Physics Engine, I think in addition to a "physics object", I need a "physics world" (a world in which the physics law works). For the magnetic bubble, I think the attraction can be implemented easier if I use "physics world" instead of "physics object" only because I need to know an area in which the magnetic force works. This is also something to try out in the future.
