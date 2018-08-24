//
//  Bubbles.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 18/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

/// This class represents all the bubbles in the bubble grid cells.
class Bubbles: Codable {
    private(set) var bubblesDictionary: [IndexPath: Bubble] = [:]

    var isEmpty: Bool {
        return getAllBubblesInGrid().isEmpty
    }

    /// Returns a `Bubble` object at the specified index path.
    /// Returns nil if there is no bubble at the specified index path.
    func getBubbleAt(_ indexPath: IndexPath) -> Bubble? {
        return bubblesDictionary[indexPath]
    }

    /// Removes bubble at the specified index path.
    /// Does nothing when there is no bubble at the specified index path.
    func removeBubbleAt(_ indexPath: IndexPath) {
        bubblesDictionary.removeValue(forKey: indexPath)
    }

    /// Adds the specified bubble to the specified index path.
    /// Does nothing when the requested bubble color is .none.
    /// Overwrites the existing bubble at the specified index path if bubble already exists.
    func addBubbleAt(_ indexPath: IndexPath, bubble: Bubble) {
        guard bubble.type != .none else {
            return
        }

        bubblesDictionary[indexPath] = bubble
    }

    /// Removes all bubbles in the bubble grid.
    func removeAllBubbles() {
        bubblesDictionary.removeAll()
    }

    /// Returns an array containing the index paths of all the cells containing bubbles.
    /// Returns an empty array if there is no bubble in the bubble grid.
    func getIndexPathsOfFilledCells() -> [IndexPath] {
        return Array(bubblesDictionary.keys)
    }

    /// Returns an array containing the all the bubbles in the bubble grid.
    /// Returns an empty array if there is no bubble in the bubble grid.
    func getAllBubblesInGrid() -> [Bubble] {
        return Array(bubblesDictionary.values)
    }
}
