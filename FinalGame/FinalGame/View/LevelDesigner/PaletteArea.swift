//
//  PaletteArea.swift
//  LevelDesigner
//
//  Created by calvint on 5/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

protocol PaletteAreaDelegate: class {
    func didTapPalette(_ palette: UIButton)
    func resetDesign()
    func startLevel()
    func openSavePopup()
    func openLoadPopup()
    func back()
}

/// Palette Area shows all the available palettes to design a level.
/// The initial palette selected will be the blue palette
class PaletteArea: UIView {

    private struct PaletteAreaConstants {
        static let unselectedPaletteAlpha: CGFloat = 0.3
        static let selectedPaletteAlpha: CGFloat = 1.0
    }

    // All the UI elements must and will be initialised.
    // All UI elements must and will be initialised.
    var resetButton: UIButton!
    var startButton: UIButton!
    var saveButton: UIButton!
    var loadButton: UIButton!
    var backButton: UIButton!
    var buttons: [UIButton]!

    var bluePalette: UIButton!
    var redPalette: UIButton!
    var orangePalette: UIButton!
    var greenPalette: UIButton!
    var indestructiblePalette: UIButton!
    var lightningPalette: UIButton!
    var bombPalette: UIButton!
    var starPalette: UIButton!
    var magneticPalette: UIButton!
    var erasePalette: UIButton!
    var palettes: [UIButton]!

    var buttonsStackView: UIStackView!
    var paletteSelectorStackView: UIStackView!

    weak var delegate: PaletteAreaDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        initializeButtons()
        initializePalettes()
        setupButtonsLayout()
        setupPalettesLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func initializeButtons() {
        resetButton = ViewHelper.makeButtonWithLabel("RESET")
        startButton = ViewHelper.makeButtonWithLabel("START")
        saveButton = ViewHelper.makeButtonWithLabel("SAVE")
        loadButton = ViewHelper.makeButtonWithLabel("LOAD")
        backButton = ViewHelper.makeButtonWithLabel("BACK")

        buttons = [resetButton, startButton, saveButton, loadButton, backButton]

        buttons.forEach {
            $0.addTarget(self, action: #selector(didTapButton), for: UIControlEvents.touchUpInside)
        }
    }

    @objc
    func didTapButton(sender: UIButton) {
        switch sender {
        case resetButton:
            delegate.resetDesign()
        case startButton:
            delegate.startLevel()
        case saveButton:
            delegate.openSavePopup()
        case loadButton:
            delegate.openLoadPopup()
        case backButton:
            delegate.back()
        default:
            break
        }

    }

    private func initializePalettes() {
        bluePalette = makePaletteWithImageName("bubble-blue")
        bluePalette.alpha = PaletteAreaConstants.selectedPaletteAlpha  // the initial palette selected

        redPalette = makePaletteWithImageName("bubble-red")
        orangePalette = makePaletteWithImageName("bubble-orange")
        greenPalette = makePaletteWithImageName("bubble-green")

        indestructiblePalette = makePaletteWithImageName("bubble-indestructible")
        lightningPalette = makePaletteWithImageName("bubble-lightning")
        bombPalette = makePaletteWithImageName("bubble-bomb")
        starPalette = makePaletteWithImageName("bubble-star")
        magneticPalette = makePaletteWithImageName("bubble-magnetic")

        erasePalette = makePaletteWithImageName("erase")

        palettes = [bluePalette, redPalette, orangePalette, greenPalette,
                    indestructiblePalette, lightningPalette, bombPalette, starPalette, magneticPalette,
                    erasePalette]
    }

    @objc
    func palettePressed(sender: UIButton) {
        palettes.forEach {
            $0.alpha = PaletteAreaConstants.unselectedPaletteAlpha
        }

        sender.alpha = PaletteAreaConstants.selectedPaletteAlpha

        delegate.didTapPalette(sender)
    }

    private func setupButtonsLayout() {
        let buttonContainers = ViewHelper.makeContainersFor(buttons)
        buttonsStackView = UIStackView(arrangedSubviews: buttonContainers)

        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(buttonsStackView)

        buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                 constant: -5).isActive = true
        buttonsStackView.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: 0.25).isActive = true
    }

    private func setupPalettesLayout() {
        paletteSelectorStackView = UIStackView(arrangedSubviews: palettes)

        paletteSelectorStackView.axis = .horizontal
        paletteSelectorStackView.distribution = .fillEqually
        paletteSelectorStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(paletteSelectorStackView)

        let margin: CGFloat = 20
        paletteSelectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                          constant: margin).isActive = true
        paletteSelectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                           constant: -margin).isActive = true
        paletteSelectorStackView.topAnchor.constraint(equalTo: topAnchor,
                                                      constant: margin).isActive = true
        paletteSelectorStackView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor,
                                                         constant: -margin).isActive = true
    }

    private func makePaletteWithImageName(_ imageName: String) -> UIButton {
        let button = UIButton(type: .system)

        button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.alpha = PaletteAreaConstants.unselectedPaletteAlpha

        button.addTarget(self, action: #selector(palettePressed), for: UIControlEvents.touchUpInside)
        return button
    }
}
