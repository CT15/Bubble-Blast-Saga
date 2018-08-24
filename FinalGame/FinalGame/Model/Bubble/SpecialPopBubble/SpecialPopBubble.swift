//
//  SpecialPopBubble.swift
//  FinalGame
//
//  Created by Calvin Tantio on 1/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

/// Represents special bubble that can cause bubbles in the grid to pop
protocol SpecialPopBubble: Codable {
    func activateEffect(in bubbles: Bubbles, indexPath: IndexPath) -> [IndexPath]
}
