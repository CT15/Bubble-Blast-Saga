//
//  BubbleGrid.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class BubbleGrid: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        register(BubbleGridCell.self, forCellWithReuseIdentifier: Constants.bubbleGridCellIdentifier)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
