//
//  GameMath.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 19/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

public struct GameMath {

    public static func distance(source: CGPoint, destination: CGPoint) -> CGFloat {
        let xDistance = destination.x - source.x
        let yDistance = destination.y - source.y

        return (pow(xDistance, 2) + pow(yDistance, 2)).squareRoot()
    }

}
