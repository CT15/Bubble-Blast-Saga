//
//  PlayingAreaViewController+UICollectionViewDelegateFlowLayout.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension PlayingAreaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        // The distance to shift each section up to touch its previous section
        let topEdgeInset = CGFloat(3.squareRoot() - 2) * Constants.bubbleRadius

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        return section % 2 == 0 ?
            UIEdgeInsets(top: topEdgeInset, left: 0, bottom: 0, right: 0) :
            UIEdgeInsets(top: topEdgeInset, left: Constants.bubbleRadius, bottom: 0, right: Constants.bubbleRadius)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.bubbleSize
    }
}
