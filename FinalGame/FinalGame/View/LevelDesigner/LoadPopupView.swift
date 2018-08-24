//
//  LoadPopupView.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

protocol LoadPopupButtonsDelegate: class {
    func closePopup()
    func loadDesignFromFile(_ fileName: String)
}

class LoadPopupView: UIView {
    // All UI elements must and will be initialised.
    // All UI elements will always have values after being initialised.
    var levelInput: UITextField!

    var loadButton: UIButton!
    var cancelButton: UIButton!

    weak var delegate: LoadPopupButtonsDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewHelper.createPopupBackground(for: self)
        setupPopupBox()
    }

    private func setupPopupBox() {
        levelInput = ViewHelper.makeTextFieldWithPlaceHolder("Enter Level Name")

        loadButton = ViewHelper.makeButtonWithLabel("LOAD")
        cancelButton = ViewHelper.makeButtonWithLabel("CANCEL")

        [loadButton, cancelButton].forEach {
            $0?.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }

        let label = UILabel()
        label.text = "Loading Design"
        label.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.5, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center

        let levelInputContainer = ViewHelper.makeContainerFor(levelInput)
        let loadButtonContainer = ViewHelper.makeContainerFor(loadButton)
        let cancelButtonContainer = ViewHelper.makeContainerFor(cancelButton)

        ViewHelper.createPopupBox(with:
            [label, levelInputContainer, loadButtonContainer, cancelButtonContainer], in: self)
    }

    @objc
    func didTapButton(sender: UIButton) {
        switch sender {
        case loadButton:
            if let userInput = levelInput.text {
                delegate.loadDesignFromFile(userInput)
            }
        case cancelButton:
            delegate.closePopup()
        default:
            break
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
