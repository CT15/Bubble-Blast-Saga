//
//  LevelSelectionViewController+UICollectionViewDelegate.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension LevelSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let levelListCell = cell as? LevelListCell else {
            fatalError("The cell dequed must be able to be downcasted to BubbleGridCell")
        }

        levelListCell.levelName.text = levelNames[indexPath.section]
    }
}
