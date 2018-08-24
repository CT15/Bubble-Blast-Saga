//
//  SavePopupView.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

protocol SavePopupButtonsDelegate: class {
    func closePopup()
    func saveDesignToFile(_ fileName: String)
}

class SavePopupView: UIView {
    // All UI elements must and will be initialised.
    // All UI elements will always have values after being initialised.
    var levelInput: UITextField!

    var saveButton: UIButton!
    var cancelButton: UIButton!

    weak var delegate: SavePopupButtonsDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        ViewHelper.createPopupBackground(for: self)
        setupPopupBox()
    }

    private func setupPopupBox() {
        levelInput = ViewHelper.makeTextFieldWithPlaceHolder("Enter Level Name")

        saveButton = ViewHelper.makeButtonWithLabel("SAVE")
        cancelButton = ViewHelper.makeButtonWithLabel("CANCEL")

        [saveButton, cancelButton].forEach {
            $0?.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        }

        let label = UILabel()
        label.text = "Saving Design"
        label.backgroundColor = UIColor(red: 0.2, green: 0.7, blue: 1.0, alpha: 1)
        label.textColor = .white
        label.textAlignment = .center

        let levelInputContainer = ViewHelper.makeContainerFor(levelInput)
        let saveButtonContainer = ViewHelper.makeContainerFor(saveButton)
        let cancelButtonContainer = ViewHelper.makeContainerFor(cancelButton)

        ViewHelper.createPopupBox(with: [label, levelInputContainer, saveButtonContainer, cancelButtonContainer], in: self)
    }

    @objc
    func didTapButton(sender: UIButton) {
        switch sender {
        case saveButton:
            if let userInput = levelInput.text {
                delegate.saveDesignToFile(userInput)
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
