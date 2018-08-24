//
//  LevelSelectionViewController.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol LevelSelectionViewControllerDelegate: class {
    func setupMenu()
    func setupPlayingArea(bubbles: Bubbles, from previousVC: String)
}

class LevelSelectionViewController: UIViewController, LevelSelectionViewDelegate {

    struct LevelSelectionViewControllerConstants {
        static let levelListSideMargin = Constants.screenWidth / 20
        static let fontSize = Constants.screenWidth / 2
    }

    var levelSelectionView: LevelSelectionView!
    var levelList: LevelList!
    var levelNames: [String]!

    weak var delegate: LevelSelectionViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLevelSelectionView()
        getSavedLevels()
        setupLevelList()
    }

    private func setupLevelSelectionView() {
        levelSelectionView = LevelSelectionView(frame: view.frame)
        levelSelectionView.delegate = self
        view.addSubview(levelSelectionView)
    }

    private func getSavedLevels() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        levelNames = []

        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for URL in fileURLs {
                levelNames.append(fileManager.displayName(atPath: String(describing: URL)))
            }
        } catch {
            print("Error while loading files")
        }

        levelNames.sort()
    }

    private func setupLevelList() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let levelListFrame = CGRect(x: LevelSelectionViewControllerConstants.levelListSideMargin, y: view.frame.height / 4, width: view.frame.width - 2 * LevelSelectionViewControllerConstants.levelListSideMargin, height: view.frame.height * 0.6)

        levelList = LevelList(frame: levelListFrame, collectionViewLayout: layout)

        levelList.delegate = self
        levelList.dataSource = self

        view.addSubview(levelList)
    }

    func back() {
        ControllerHelper.closeViewController(self)
        delegate.setupMenu()
    }
}
