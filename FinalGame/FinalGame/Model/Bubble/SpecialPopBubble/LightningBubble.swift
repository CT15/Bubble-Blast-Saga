//
//  LightningBubble.swift
//  FinalGame
//
//  Created by Calvin Tantio on 1/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class LightningBubble: Bubble, SpecialPopBubble {
    func activateEffect(in bubbles: Bubbles, indexPath: IndexPath) -> [IndexPath] {
        return bubbles.getIndexPathsAtSection(indexPath.section).filter { $0 != indexPath }
    }
}
