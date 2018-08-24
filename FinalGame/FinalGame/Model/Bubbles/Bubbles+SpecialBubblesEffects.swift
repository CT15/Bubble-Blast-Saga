//
//  Bubbles+SpecialBubblesEffects.swift
//  FinalGame
//
//  Created by Calvin Tantio on 1/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

/// Extension containing functions related to the effect of special bubbles
extension Bubbles {
    func getIndexPathsAtSection(_ section: Int) -> [IndexPath] {
        return getIndexPathsOfFilledCells().filter { $0.section == section }
    }

    func getIndexPathsWithSameType(indexPath: IndexPath) -> [IndexPath] {
        guard let type = bubblesDictionary[indexPath]?.type else {
            return []
        }
        return getIndexPathsOfFilledCells().filter { getBubbleAt($0)?.type == type }
    }

    func initialiseSpecialBubbles() {
        let indexPathsOfBubbles = getIndexPathsOfFilledCells()

        for indexPath in indexPathsOfBubbles {
            guard let bubble = bubblesDictionary[indexPath],
                bubble.type.rawValue > Constants.maxColorBubbleRawValue else {
                continue
            }

            switch bubble.type {
            case .lightning:
                addBubbleAt(indexPath, bubble: LightningBubble(bubble: bubble))
            case .bomb:
                addBubbleAt(indexPath, bubble: BombBubble(bubble: bubble))
            case .star:
                addBubbleAt(indexPath, bubble: StarBubble(bubble: bubble))
            default:
                break
            }
        }
    }
}
