//
//  MainViewController.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, LevelDesignerViewControllerDelegate,
                          MenuViewControllerDelegate, LevelSelectionViewControllerDelegate,
                          PlayingAreaViewControllerDelegate {

    var background: UIImageView!

    var menuViewController: MenuViewController!
    var playingAreaViewController: PlayingAreaViewController!
    var levelDesignerViewController: LevelDesignerViewController!
    var levelSelectionViewController: LevelSelectionViewController!

    var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        player = AudioHelper.setupPlayer(fileName: "music", loop: -1)  // infinite loop
        setupBackground()
        setupMenu()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupBackground() {
        ViewHelper.setupBackground(imageName: "play-background", in: view)
    }

    func setupMenu() {
        menuViewController = MenuViewController()
        menuViewController.delegate = self
        ControllerHelper.initialiseViewController(menuViewController, parent: self)
    }

    func setupLevelDesigner() {
        levelDesignerViewController = LevelDesignerViewController()
        levelDesignerViewController.delegate = self
        ControllerHelper.initialiseViewController(levelDesignerViewController, parent: self)
    }

    func setupLevelSelection() {
        levelSelectionViewController = LevelSelectionViewController()
        levelSelectionViewController.delegate = self
        ControllerHelper.initialiseViewController(levelSelectionViewController, parent: self)
    }

    func setupPlayingArea(bubbles: Bubbles, from previousVC: String) {
        playingAreaViewController = PlayingAreaViewController(bubbles: bubbles, from: previousVC)
        playingAreaViewController.delegate = self
        ControllerHelper.initialiseViewController(playingAreaViewController, parent: self)
    }
}
