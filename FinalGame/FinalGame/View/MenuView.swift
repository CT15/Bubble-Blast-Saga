//
//  MenuView.swift
//  FinalGame
//
//  Created by Calvin Tantio on 2/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol MenuViewDelegate: class {
    func openLevelSelection()
    func openLevelDesigner()
}

class MenuView: UIView {
    private struct MenuViewConstants {
        static let titleLabelSize = Constants.screenWidth / 10
        static let font = "Times New Roman"
        static let buttonFontSize = titleLabelSize / 3
    }

    var levelSelectionButton: UIButton!
    var levelDesignerButton: UIButton!
    var buttons: [UIButton]!
    var buttonsStackView: UIStackView!

    var gameTitle: UILabel!

    weak var delegate: MenuViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewHelper.setupBackground(imageName: "menu-background", in: self)
        setupGameTitle()
        setupButtons()
    }

    private func setupGameTitle() {
        gameTitle = UILabel()
        gameTitle.frame = CGRect(x: 0, y: frame.height / 4, width: frame.width, height: frame.height / 5)

        gameTitle.text = Constants.gameTitle
        gameTitle.textAlignment = NSTextAlignment.center
        gameTitle.font = UIFont(name: MenuViewConstants.font, size: MenuViewConstants.titleLabelSize)
        gameTitle.textColor = .white

        addSubview(gameTitle)
    }

    private func setupButtons() {
        levelSelectionButton = ViewHelper.makeButtonWithLabel("LEVEL SELECTION")
        levelDesignerButton = ViewHelper.makeButtonWithLabel("LEVEL DESIGNER")

        buttons = [levelSelectionButton, levelDesignerButton]
        buttons.forEach {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: MenuViewConstants.buttonFontSize)
            $0.addTarget(self, action: #selector(didTapButton), for: UIControlEvents.touchUpInside)
        }

        let buttonContainer = ViewHelper.makeContainersFor(buttons)
        buttonsStackView = UIStackView(arrangedSubviews: buttonContainer)

        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually

        buttonsStackView.frame = CGRect(x: 0, y: frame.height / 5 + frame.height / 3,
                                        width: frame.width, height: frame.height / 10)
        addSubview(buttonsStackView)
    }

    @objc
    func didTapButton(sender: UIButton) {
        switch sender {
        case levelSelectionButton:
            delegate.openLevelSelection()
        case levelDesignerButton:
            delegate.openLevelDesigner()
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
