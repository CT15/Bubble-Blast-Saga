//
//  GameCompletePopupView.swift
//  FinalGame
//
//  Created by Calvin Tantio on 4/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol GameCompletePopupViewDelegate: class {
    func endGame()
}

class GameCompletePopupView: UIView {

    var endGameButton: UIButton!

    var status: String!

    weak var delegate: GameCompletePopupViewDelegate!

    init(frame: CGRect, status: String) {
        super.init(frame: frame)
        self.status = status
        ViewHelper.createPopupBackground(for: self)
        setupPopupBox()
    }

    private func setupPopupBox() {
        let label = UILabel()
        label.text = "YOU " + status
        label.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0.2, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center

        endGameButton = ViewHelper.makeButtonWithLabel("END GAME")
        endGameButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        let endGameButtonContainer = ViewHelper.makeContainerFor(endGameButton)

        ViewHelper.createPopupBox(with: [label, endGameButtonContainer], in: self)
    }

    @objc
    private func didTapButton(sender: UIButton) {
        delegate.endGame()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
