//
//  Bubble+MovingObject.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 17/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import PhysicsEngine

extension Bubble: MovingObject {

    func move() {
        // Can only move when the directionVector is set
        guard let vector = directionVector else {
            return
        }

        // scaling down such that dy == 1
        let xVelocity = vector.dx / vector.dy.magnitude * Constants.bubbleSpeed
        let yVelocity = vector.dy / vector.dy.magnitude * Constants.bubbleSpeed

        center.x += xVelocity
        center.y += yVelocity

        if doesHitSideWall {
            reverseDirection()
        }
    }

    func reverseDirection() {
        guard let vector = directionVector else {
            return
        }

        directionVector = CGVector(dx: -vector.dx, dy: vector.dy)
    }
}
