//
//  Bubble.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 17/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import PhysicsEngine

class Bubble: Codable {
    var type: BubbleType
    var center: CGPoint
    var size: CGSize

    var directionVector: CGVector?

    /// Constructs a bubble of the specified color at the specified center.
    init(type: BubbleType, center: CGPoint) {
        self.type = type
        self.center = center
        self.size = CGSize(width: Constants.bubbleDiameter, height: Constants.bubbleDiameter)
    }

    /// Constructs an exact copy of another bubble
    init(bubble: Bubble) {
        self.type = bubble.type
        self.center = bubble.center
        self.size = bubble.size
        self.directionVector = bubble.directionVector
    }

    /// Changes the color of the bubble object according to the following cycle:
    /// blue -> red -> orange -> green -> blue
    /// Does nothing when the bubble color is .none
    func cycleColor() {
        switch type {
        case .blue:
            type = .red
        case .red:
            type = .orange
        case .orange:
            type = .green
        case .green:
            type = .blue
        default:
            break
        }
    }

    func getImage() -> UIImage? {
        var imageName = ""

        switch type {
        case .blue:
            imageName = "bubble-blue"
        case .red:
            imageName = "bubble-red"
        case .orange:
            imageName = "bubble-orange"
        case .green:
            imageName = "bubble-green"
        case .indestructible:
            imageName = "bubble-indestructible"
        case .lightning:
            imageName = "bubble-lightning"
        case .bomb:
            imageName = "bubble-bomb"
        case .star:
            imageName = "bubble-star"
        case .magnetic:
            imageName = "bubble-magnetic"
        case .none:
            return nil
        }

        return UIImage(named: imageName)
    }
}

extension Bubble: Hashable {
    var hashValue: Int {
        return "\(type)\(center)\(size)\(String(describing: directionVector))".hashValue
    }

    static func == (lhs: Bubble, rhs: Bubble) -> Bool {
        return lhs.type == rhs.type &&
               lhs.center == rhs.center &&
               lhs.size == rhs.size &&
               lhs.directionVector == rhs.directionVector
    }
}
