//
//  LevelSelectionViewController+UICollectionViewDelegateFlowLayout.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension LevelSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: LevelSelectionViewControllerConstants.levelListSideMargin,
                            bottom: 0, right: LevelSelectionViewControllerConstants.levelListSideMargin)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 2 * LevelSelectionViewControllerConstants.levelListSideMargin,
                      height: Constants.screenHeight * 0.1)
    }
}
