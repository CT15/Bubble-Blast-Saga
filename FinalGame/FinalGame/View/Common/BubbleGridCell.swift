//
//  BubbleGridCell.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class BubbleGridCell: UICollectionViewCell {
    // bubbleImageView must and will be initialised.
    // bubbleImageView will always have a value after being initialised.
    var bubbleImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        bubbleImageView = UIImageView(frame: contentView.frame)
        contentView.addSubview(bubbleImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
