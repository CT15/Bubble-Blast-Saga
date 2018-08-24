//
//  Constants.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 17/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

struct Constants {
    static let gameTitle = "Bubble Blast Saga"

    // Constants related to screen
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let screenCenterX = screenWidth / 2

    // Constants related to bubble grid
    static let totalGridSections = 15
    static let totalItemsInEvenSection = 12
    static let totalItemsInOddSection = 11

    // Constants related to bubble
    static let bubbleDiameter = screenWidth / CGFloat(totalItemsInEvenSection)
    static let bubbleRadius = bubbleDiameter / 2
    static let bubbleSize = CGSize(width: bubbleDiameter, height: bubbleDiameter)
    static let bubbleSpeed: CGFloat = 15.0

    static let defaultButtonLabelSize: CGFloat = 20

    // Constants for enumeration
    static let maxColorBubbleRawValue = 3

    // Constant identifiers
    static let bubbleGridCellIdentifier = "bubbleCell"
    static let levelListCellIdentifier = "levelCell"
    static let levelSelectionVCIdentifier = "levelSelection"
    static let levelDesignerVCIdentifier = "levelDesigner"
}
