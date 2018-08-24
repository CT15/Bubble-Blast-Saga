//
//  LevelSelectionView.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol LevelSelectionViewDelegate: class {
    func back()
}
class LevelSelectionView: UIView {

    private struct LevelSelectionViewConstants {
        static let titleFont = "Times New Roman"
        static let titleSize = Constants.screenWidth / 10
        static let titleColor = UIColor.white

        static let backButtonFontSize: CGFloat = 30
    }

    weak var delegate: LevelSelectionViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewHelper.setupBackground(imageName: "level-selection-background", in: self)
        setupTitle()
        setupBackButton()
    }

    private func setupTitle() {
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 4)

        title.text = "Level Selection"
        title.textColor = LevelSelectionViewConstants.titleColor
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont(name: LevelSelectionViewConstants.titleFont, size: LevelSelectionViewConstants.titleSize)

        addSubview(title)
    }

    private func setupBackButton() {
        let backButton = ViewHelper.makeButtonWithLabel("BACK")
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: LevelSelectionViewConstants.backButtonFontSize)
        backButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        let backButtonContainer = ViewHelper.makeContainerFor(backButton)
        backButtonContainer.frame = CGRect(x: 0, y: frame.height * 9 / 10,
                                           width: frame.width, height: frame.height / 10)
        addSubview(backButtonContainer)
    }

    @objc
    private func didTapButton() {
        delegate.back()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
