//
//  Bubbles+GamePlay.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 20/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import PhysicsEngine

/// Extension containing functions related to the game play logic.
extension Bubbles {

    /// Checks if the specified bubble intersects with any of the bubbles in the grid.
    func intersectWith(_ bubble: Bubble) -> Bool {

        for bubbleInGrid in getAllBubblesInGrid() {
            let distance = GameMath.distance(source: bubble.center, destination: bubbleInGrid.center)

            if distance < Constants.bubbleDiameter {
                return true
            }
        }

        return false
    }

    /// Checks whether bubble grid contains at least one bubble of the specified type
    func containsBubbleOfType(_ type: BubbleType) -> Bool {
        return getAllBubblesInGrid().contains { $0.type == type }
    }

    /// Checks whether bubble grid contains at least one special bubble
    func containsSpecialBubble() -> Bool {
        return getAllBubblesInGrid().contains { $0.type.rawValue > Constants.maxColorBubbleRawValue }
    }

    /// Checks if there is bubble in the last section of the grid.
    /// This is a condition for Game Over (Lose).
    func containsBubbleInLastSection() -> Bool {
        for indexPath in bubblesDictionary.keys where indexPath.section == Constants.totalGridSections - 1 {
            return true
        }

        return false
    }

    /// Removes a cluster of 3 bubbles or more with the same color starting from the bubble
    /// at the specified index path.
    /// If the cell at the specified index path does not contain bubble, returns an empty array.
    /// Returns an array of the bubbles removed, an empty array if no bubble is removed.
    func popBubblesStartingFrom(_ startingIndexPath: IndexPath) -> Set<Bubble> {
        guard let startingBubble = bubblesDictionary[startingIndexPath] else {
            return []
        }

        let minimumBubbleInClusterToPop = 3

        let colorPopped = startingBubble.type

        var indexPathsToCheck = Stack<IndexPath>()
        var visitedIndexPaths = Set<IndexPath>()
        var indexPathsToPop = Set<IndexPath>()

        var indexPathsToPopSpecial = Stack<IndexPath>()
        indexPathsToPopSpecial.push(contentsOf: Array(indexPathsOfSpecialBubbleAdjacentFrom(startingIndexPath)))

        indexPathsToCheck.push(startingIndexPath)
        indexPathsToPop.insert(startingIndexPath)

        while let indexPath = indexPathsToCheck.pop() {
            visitedIndexPaths.insert(indexPath)

            // skips empty cell
            guard let bubble = bubblesDictionary[indexPath] else {
                continue
            }

            if bubble.type == colorPopped {
                indexPathsToPop.insert(indexPath)

                for neighbour in getNeighboursOf(indexPath) where !visitedIndexPaths.contains(neighbour) {
                    indexPathsToCheck.push(neighbour)
                }
            }
        }

        var poppedBubbles = Set<Bubble>()

        while let indexPathOfSpecialBubble = indexPathsToPopSpecial.pop() {
            guard let specialBubble = bubblesDictionary[indexPathOfSpecialBubble] as? SpecialPopBubble else {
                continue
            }

            // Removes its surrounding bubbles
            var startEffectIndexPath: IndexPath
            if bubblesDictionary[indexPathOfSpecialBubble]!.type == .star {
                startEffectIndexPath = startingIndexPath
            } else {
                startEffectIndexPath = indexPathOfSpecialBubble
            }

            for indexPath in specialBubble.activateEffect(in: self, indexPath: startEffectIndexPath) {
                guard let bubbleToRemove = bubblesDictionary[indexPath] else {
                    continue
                }

                // For chaining effect, add special bubble popped into the stack
                if let _ = bubbleToRemove as? SpecialPopBubble {
                    indexPathsToPopSpecial.push(indexPath)
                    continue
                }

                // Indestructible bubble cannot be removed by special pop bubble
                if bubbleToRemove.type != .indestructible && bubbleToRemove.type != .magnetic {
                    poppedBubbles.insert(bubbleToRemove)
                    removeBubbleAt(indexPath)
                }
            }

            // Removes itself
            poppedBubbles.insert(bubblesDictionary[indexPathOfSpecialBubble]!)
            removeBubbleAt(indexPathOfSpecialBubble)
        }

        if indexPathsToPop.count >= minimumBubbleInClusterToPop {
            for indexPath in indexPathsToPop {
                if let bubbleToPop = bubblesDictionary[indexPath] {
                    poppedBubbles.insert(bubbleToPop)
                    removeBubbleAt(indexPath)
                }
            }
        }

        return poppedBubbles
    }

    /// Removes all floating bubbles.
    /// Returns an array of the bubbles removed, an empty array if no bubble is removed.
    func removeFloatingBubble() -> [Bubble] {

        var indexPathsToCheck = Stack<IndexPath>()
        var visitedIndexPaths = Set<IndexPath>()
        var connectedIndexPaths = Set<IndexPath>()

        // a bubble is not floating if it is connected to any bubble at
        // the top section of the grid
        let bubblesInTopSection = bubblesDictionary.keys.filter { $0.section == 0 }
        indexPathsToCheck.push(contentsOf: bubblesInTopSection)

        while let indexPath = indexPathsToCheck.pop() {
            visitedIndexPaths.insert(indexPath)

            // skips empty cell
            guard bubblesDictionary[indexPath] != nil else {
                continue
            }

            connectedIndexPaths.insert(indexPath)

            for neighbour in getNeighboursOf(indexPath) where !visitedIndexPaths.contains(neighbour) {
                indexPathsToCheck.push(neighbour)
            }
        }

        let unconnectedIndexPaths = bubblesDictionary.keys.filter { !connectedIndexPaths.contains($0) }
        var removedBubbles: [Bubble] = []
        for indexPath in unconnectedIndexPaths {
            removedBubbles.append(bubblesDictionary[indexPath]!)
            removeBubbleAt(indexPath)
        }

        return removedBubbles
    }

    // Returns an array of index paths that is adjacent to the specified index path.
    // The index paths may not exist in the bubble grid.
    func getNeighboursOf(_ indexPath: IndexPath) -> [IndexPath] {

        let evenSectionsNeigboursOffsets = [[-1, -1], [-1, 0], [0, -1], [0, 1], [1, -1], [1, 0]]
        let oddSectionNeighboursOffsets = [[-1, 0], [-1, 1], [0, -1], [0, 1], [1, 0], [1, 1]]

        var neighbourOffsets: [[Int]]
        var neighbours: [IndexPath] = []

        if indexPath.section % 2 == 0 {
            neighbourOffsets = evenSectionsNeigboursOffsets
        } else {
            neighbourOffsets = oddSectionNeighboursOffsets
        }

        for offset in neighbourOffsets {
            let section = indexPath.section + offset[0]
            let item = indexPath.item + offset[1]

            neighbours.append(IndexPath(item: item, section: section))
        }

        return neighbours
    }

    private func indexPathsOfSpecialBubbleAdjacentFrom(_ indexPath: IndexPath) -> Set<IndexPath> {
        var indexPaths = Set<IndexPath>()
        for neighbour in getNeighboursOf(indexPath) {
            if let _ = getBubbleAt(neighbour) as? SpecialPopBubble {
                indexPaths.insert(neighbour)
            }
        }
        return indexPaths
    }
}
