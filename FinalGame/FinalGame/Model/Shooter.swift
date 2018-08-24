//
//  Shooter.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 17/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class Shooter {
    private struct ShooterConstants {
        static let totalBubbles = 49   // not including the first bubble
    }

    var bubbleRemaining = ShooterConstants.totalBubbles

    var currentBubble: Bubble?
    lazy var nextBubble: Bubble? = makeBubble()

    let bubbles: Bubbles

    let center: CGPoint

    private var isLoaded: Bool {
        return currentBubble != nil
    }

    init(frame: CGRect, bubbles: Bubbles) {
        let centerX = frame.width / 2
        let centerY = frame.height - Constants.bubbleDiameter
        center = CGPoint(x: centerX, y: centerY)

        self.bubbles = bubbles

        loadBubble()
    }

    /// Returns the loaded bubble object if the shooter is loaded.
    /// Returns nil otherwise.
    func shootBubble() -> Bubble? {
        guard let bubbleToShoot = currentBubble else {
            return nil
        }

        currentBubble = nil
        loadBubble()

        return bubbleToShoot
    }

    /// Switches the current bubble with the next bubble if both exist.
    func switchBubble() {
        guard let newNextBubble = currentBubble, let newCurrentBubble = nextBubble else {
            return
        }

        currentBubble = newCurrentBubble
        nextBubble = newNextBubble
    }

    /// Loads next bubble to the shooter.
    /// Does nothing if the shooter is already loaded.
    private func loadBubble() {
        guard !isLoaded else {
            return
        }

        currentBubble = nextBubble
        nextBubble = nil
        loadNextBubble()
    }

    /// Prepares the next bubble.
    /// Does nothing if there is no more bubbles in the shooter.
    private func loadNextBubble() {
        guard bubbleRemaining > 0 else {
            nextBubble = nil
            return
        }

        bubbleRemaining -= 1
        nextBubble = makeBubble()
    }

    private func makeBubble() -> Bubble {
        // Constructs a random color
        guard var bubbleType = BubbleType(rawValue: Int(arc4random() % 4)) else {
            fatalError("Bubble type must exist")
        }

        if bubbles.isEmpty || bubbles.containsSpecialBubble() {
            return Bubble(type: bubbleType, center: center)
        }

        while !bubbles.containsBubbleOfType(bubbleType) {
            bubbleType = BubbleType(rawValue: Int(arc4random() % 4))!
        }

        return Bubble(type: bubbleType, center: center)
    }
}
