//
//  LevelListCell.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol LevelListCellDelegate: class {
    func playLevel(_ levelName: String)
}

class LevelListCell: UICollectionViewCell {
    private struct LevelListCellConstants {
        static let font = "Verdana-bold"
        static let fontSize: CGFloat = Constants.screenWidth / 20
    }

    var levelName: UILabel!
    var playButton: UIButton!

    weak var delegate: LevelListCellDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLevelName()
        setupPlayButton()
    }

    private func setupLevelName() {
        levelName = UILabel()
        levelName.frame = CGRect(x: 0, y: 0, width: frame.width * 0.5, height: frame.height)
        levelName.textAlignment = NSTextAlignment.right
        levelName.font = UIFont(name: LevelListCellConstants.font, size: LevelListCellConstants.fontSize)

        addSubview(levelName)
    }

    private func setupPlayButton() {
        playButton = ViewHelper.makeButtonWithLabel("PLAY")
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: LevelListCellConstants.fontSize)
        playButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        let playButtonContainer = ViewHelper.makeContainerFor(playButton)
        playButtonContainer.frame = CGRect(x: frame.width * 0.5, y: 0, width: frame.width * 0.5, height: frame.height)
        addSubview(playButtonContainer)
    }

    @objc
    private func didTapButton() {
        guard let level = levelName.text else {
            return
        }
        delegate.playLevel(level)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
