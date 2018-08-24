//
//  SavePopupViewController.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

protocol SavePopupDelegate: class {
    func saveToFile(_ fileName: String)
}

class SavePopupViewController: UIViewController, SavePopupButtonsDelegate {

    // savePopupView and delegate must and will be initialised.
    // savePopupView and delegate will always have values after being initialised.
    var savePopupView: SavePopupView!
    weak var delegate: SavePopupDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        savePopupView = SavePopupView(frame: view.frame)
        savePopupView.delegate = self
        view.addSubview(savePopupView)
    }

    func closePopup() {
        ControllerHelper.closeViewController(self)
    }

    func saveDesignToFile(_ fileName: String) {
        let trimmedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidFileName(trimmedFileName) else {
            return
        }

        delegate.saveToFile(trimmedFileName)
        self.view.removeFromSuperview()
    }

    private func isValidFileName(_ fileName: String) -> Bool {
        return fileName != "" && fileName.count <= 10 && !fileName.contains(" ")
    }

}
