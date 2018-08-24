//
//  GameCompletePopupViewController.swift
//  FinalGame
//
//  Created by Calvin Tantio on 4/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol GameCompletePopupViewControllerDelegate: class {
    func back()
}

class GameCompletePopupViewController: UIViewController, GameCompletePopupViewDelegate {

    var gameCompletePopupView: GameCompletePopupView!
    var status: String!

    weak var delegate: GameCompletePopupViewControllerDelegate!

    convenience init(status: String) {
        self.init(nibName: nil, bundle: nil)
        self.status = status
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        gameCompletePopupView = GameCompletePopupView(frame: view.frame, status: status)
        gameCompletePopupView.delegate = self
        view.addSubview(gameCompletePopupView)
    }

    func endGame() {
        ControllerHelper.closeViewController(self)
        delegate.back()
    }
}
