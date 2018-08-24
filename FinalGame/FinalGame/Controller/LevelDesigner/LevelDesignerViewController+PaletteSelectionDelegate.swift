//
//  ViewController+PaletteSelectionDelegate.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

/// Extension containing delegate methods for the buttons and palettes in PaletteArea
extension LevelDesignerViewController: PaletteAreaDelegate {
    func didTapPalette(_ palette: UIButton) {
        switch palette {
        case paletteArea.bluePalette:
            paletteChosen = .blue
        case paletteArea.redPalette:
            paletteChosen = .red
        case paletteArea.orangePalette:
            paletteChosen = .orange
        case paletteArea.greenPalette:
            paletteChosen = .green
        case paletteArea.indestructiblePalette:
            paletteChosen = .indestructible
        case paletteArea.lightningPalette:
            paletteChosen = .lightning
        case paletteArea.bombPalette:
            paletteChosen = .bomb
        case paletteArea.starPalette:
            paletteChosen = .star
        case paletteArea.magneticPalette:
            paletteChosen = .magnetic
        case paletteArea.erasePalette:
            paletteChosen = .none
        default:
            break
        }
    }

    // When RESET button is pressed
    func resetDesign() {
        bubbles.removeAllBubbles()
        bubbleGrid.reloadData()
    }

    // When START button is pressed
    func startLevel() {
        guard !bubbles.isEmpty else {
            return
        }

        ControllerHelper.closeViewController(self)
        delegate.setupPlayingArea(bubbles: bubbles, from: Constants.levelDesignerVCIdentifier)
    }

    // When SAVE button is pressed
    func openSavePopup() {
        guard !bubbles.isEmpty else {
            return
        }

        let savePopupViewController = SavePopupViewController()
        savePopupViewController.delegate = self

        ControllerHelper.initialiseViewController(savePopupViewController, parent: self)
    }

    // When LOAD button is pressed
    func openLoadPopup() {
        let loadPopupViewController = LoadPopupViewController()
        loadPopupViewController.delegate = self

        ControllerHelper.initialiseViewController(loadPopupViewController, parent: self)
    }

    // When BACK button is pressed
    func back() {
        ControllerHelper.closeViewController(self)
        delegate.setupMenu()
    }
}
