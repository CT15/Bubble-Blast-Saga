//
//  ViewHelper.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

struct ViewHelper {
    private struct ViewHelperConstants {
        static let popupBackgroundAlpha: CGFloat = 0.5
    }

    static func setupBackground(imageName: String, in view: UIView) {
        let background = UIImageView(image: UIImage(named: imageName))
        background.contentMode = .scaleAspectFill
        background.frame = view.frame

        view.addSubview(background)
    }

    static func makeButtonWithLabel(_ label: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setAttributedTitle(NSAttributedString(string: label), for: UIControlState.normal)

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.defaultButtonLabelSize)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.1

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

    static func makeContainerFor(_ view: UIView) -> UIView {
        let container = UIView()
        container.addSubview(view)
        view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        return container
    }

    static func makeContainersFor(_ views: [UIView]) -> [UIView] {
        var containers = [UIView]()
        views.forEach {
            containers.append(makeContainerFor($0))
        }
        return containers
    }

    static func createPopupBackground(for view: UIView) {
        let background = UIView()
        background.backgroundColor = .gray
        background.alpha = ViewHelperConstants.popupBackgroundAlpha
        background.frame = view.frame

        view.addSubview(background)
    }

    static func createPopupBox(with elements: [UIView], in view: UIView) {
        let popupBox = UIView()
        popupBox.backgroundColor = .white
        popupBox.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(popupBox)
        popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupBox.heightAnchor.constraint(equalTo: view.heightAnchor,
                                         multiplier: 0.25).isActive = true
        popupBox.widthAnchor.constraint(equalTo: view.widthAnchor,
                                        multiplier: 0.5).isActive = true

        let stackView = UIStackView(arrangedSubviews: elements)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        popupBox.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: popupBox.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: popupBox.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: popupBox.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: popupBox.trailingAnchor).isActive = true
    }

    static func makeTextFieldWithPlaceHolder(_ placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Enter Level Name"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
