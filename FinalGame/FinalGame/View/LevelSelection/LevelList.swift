//
//  LevelList.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class LevelList: UICollectionView {
    private struct LevelListConstants {
        static let backgroundColor = UIColor.white
        static let alpha: CGFloat = 0.5
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        register(LevelListCell.self, forCellWithReuseIdentifier: Constants.levelListCellIdentifier)
        backgroundColor = LevelListConstants.backgroundColor
        alpha = LevelListConstants.alpha
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
