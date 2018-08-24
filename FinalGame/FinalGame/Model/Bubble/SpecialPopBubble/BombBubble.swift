//
//  BombBubble.swift
//  FinalGame
//
//  Created by Calvin Tantio on 1/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class BombBubble: Bubble, SpecialPopBubble {
    func activateEffect(in bubbles: Bubbles, indexPath: IndexPath) -> [IndexPath] {
        return bubbles.getNeighboursOf(indexPath)
    }
}
