//
//  ViewController+CollectionView.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

/// Extension containing delegate and data source methods related to BubbleGrid and BubbleGridCell
extension LevelDesignerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return 12   // Even section contains 12 bubbles
        }
        return 11   // Odd section contains 11 bubbles
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let bubbleGridCell = bubbleGrid.dequeueReusableCell(withReuseIdentifier:
            Constants.bubbleGridCellIdentifier, for: indexPath)
            as? BubbleGridCell else {
            fatalError("The cell dequed must be able to be downcasted to BubbleGridCell")
        }

        return bubbleGridCell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let bubbleGridCell = cell as? BubbleGridCell else {
            fatalError("The cell dequed must be able to be downcasted to BubbleGridCell")
        }

        bubbleGridCell.bubbleImageView.image = nil

        bubbleGridCell.bubbleImageView.layer.backgroundColor = UIColor.white.cgColor
        bubbleGridCell.bubbleImageView.layer.opacity = 0.3

        let maxNumberOfBubbleInRow = CGFloat(12)
        let cellWidth = view.frame.width / maxNumberOfBubbleInRow
        bubbleGridCell.bubbleImageView.layer.cornerRadius = cellWidth / 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bubble = bubbles.getBubbleAt(indexPath) {
            if paletteChosen == .none {
                bubbles.removeBubbleAt(indexPath)
            } else if paletteChosen.rawValue <= Constants.maxColorBubbleRawValue {
                bubble.cycleColor()
            } else {
                var bubbleToAdd: Bubble
                let center = bubbleGrid.cellForItem(at: indexPath)!.center
                switch paletteChosen {
                case .lightning:
                    bubbleToAdd = LightningBubble(type: paletteChosen, center: center)
                case .bomb:
                    bubbleToAdd = BombBubble(type: paletteChosen, center: center)
                case .star:
                    bubbleToAdd = StarBubble(type: paletteChosen, center: center)
                default:
                    bubbleToAdd = Bubble(type: paletteChosen, center: center)
                }
                bubbles.addBubbleAt(indexPath, bubble: bubbleToAdd)
            }
        } else if paletteChosen != .none {
            var bubbleToAdd: Bubble
            let center = bubbleGrid.cellForItem(at: indexPath)!.center
            switch paletteChosen {
            case .lightning:
                bubbleToAdd = LightningBubble(type: paletteChosen, center: center)
            case .bomb:
                bubbleToAdd = BombBubble(type: paletteChosen, center: center)
            case .star:
                bubbleToAdd = StarBubble(type: paletteChosen, center: center)
            default:
                bubbleToAdd = Bubble(type: paletteChosen, center: center)
            }

            bubbles.addBubbleAt(indexPath, bubble: bubbleToAdd)
        }
        Renderer.setCellImageAt(indexPath, ofGrid: bubbleGrid, accordingTo: bubbles)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let widthOfCell = view.frame.width / 12
        let radiusOfGreyBubble: CGFloat = widthOfCell / 2

        // The distance to shift each section up to touch its previous section
        let topEdgeInset = CGFloat(3.squareRoot() - 2) * radiusOfGreyBubble

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        return section % 2 == 0 ?
            UIEdgeInsets(top: topEdgeInset, left: 0, bottom: 0, right: 0) :
            UIEdgeInsets(top: topEdgeInset, left: radiusOfGreyBubble, bottom: 0, right: radiusOfGreyBubble)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxNumberOfBubbleInRow = CGFloat(12)
        let cellWidth = view.frame.width / maxNumberOfBubbleInRow
        return CGSize(width: cellWidth, height: cellWidth)  // A cell is rectangular so height == width
    }
}
