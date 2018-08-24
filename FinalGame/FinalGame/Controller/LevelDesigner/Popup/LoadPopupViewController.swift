//
//  LoadPopupViewController.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

protocol LoadPopupDelegate: class {
    func loadFromFile(_ fileName: String)
}

class LoadPopupViewController: UIViewController, LoadPopupButtonsDelegate {

    // loadPopupView and delegate must and will be initialised.
    // loadPopupView and delegate will always have values after being initialised.
    var loadPopupView: LoadPopupView!
    weak var delegate: LoadPopupDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        loadPopupView = LoadPopupView(frame: view.frame)
        loadPopupView.delegate = self
        view.addSubview(loadPopupView)
    }

    func closePopup() {
        ControllerHelper.closeViewController(self)
    }

    func loadDesignFromFile(_ fileName: String) {
        guard fileName != "" else {
            return
        }

        delegate.loadFromFile(fileName)
        self.view.removeFromSuperview()
    }
}
