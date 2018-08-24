//
//  PlayingAreaViewController+UICollectionViewDataSource.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension PlayingAreaViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.totalGridSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section % 2 == 0 {
            return Constants.totalItemsInEvenSection
        }
        return Constants.totalItemsInOddSection
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
}
