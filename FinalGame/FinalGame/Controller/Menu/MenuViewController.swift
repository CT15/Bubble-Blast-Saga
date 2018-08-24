//
//  MenuViewController.swift
//  FinalGame
//
//  Created by Calvin Tantio on 2/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func setupLevelDesigner()
    func setupLevelSelection()
}

class MenuViewController: UIViewController, MenuViewDelegate {

    var menuView: MenuView!

    weak var delegate: MenuViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
    }

    private func setupMenuView() {
        menuView = MenuView(frame: view.frame)
        menuView.delegate = self

        view.addSubview(menuView)
    }

    func openLevelSelection() {
        ControllerHelper.closeViewController(self)
        delegate.setupLevelSelection()
    }

    func openLevelDesigner() {
        ControllerHelper.closeViewController(self)
        delegate.setupLevelDesigner()
    }
}
