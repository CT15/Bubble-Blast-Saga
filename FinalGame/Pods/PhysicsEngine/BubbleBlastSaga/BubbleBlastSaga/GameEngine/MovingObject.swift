//
//  MovingObject.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 19/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

public protocol MovingObject {
    var directionVector: CGVector? { get }
    var center: CGPoint { get set }
    var size: CGSize { get set }

    func move()
    func reverseDirection()
}

extension MovingObject {

    public var doesHitSideWall: Bool {
        return center.x + size.width / 2 >= UIScreen.main.bounds.width || center.x - size.width / 2 <= 0
    }

    public var doesHitTopWall: Bool {
        return center.y - size.height / 2 <= 0
    }
}
