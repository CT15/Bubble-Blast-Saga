//
//  PlayinAreaViewController+UICollectionViewDelegate.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension PlayingAreaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let bubbleGridCell = cell as? BubbleGridCell else {
            fatalError("The cell dequed must be able to be downcasted to BubbleGridCell")
        }

        bubbleGridCell.bubbleImageView.image = bubbles.getBubbleAt(indexPath)?.getImage()
    }
}
