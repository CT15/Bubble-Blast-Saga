//
//  LevelSelectionViewController+UICollectionViewDataSource.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension LevelSelectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return levelNames.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let levelListCell = levelList.dequeueReusableCell(withReuseIdentifier:
            Constants.levelListCellIdentifier, for: indexPath)
            as? LevelListCell else {
                fatalError("The cell dequed must be able to be downcasted to LevelListCell")
        }

        levelListCell.delegate = self
        return levelListCell
    }
}
