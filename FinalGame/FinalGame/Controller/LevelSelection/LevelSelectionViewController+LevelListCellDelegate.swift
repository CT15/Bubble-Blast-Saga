//
//  LevelSelectionViewController+LevelListCellDelegate.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension LevelSelectionViewController: LevelListCellDelegate {
    func playLevel(_ levelName: String) {
        let bubbles = loadFromFile(levelName)
        ControllerHelper.closeViewController(self)
        delegate.setupPlayingArea(bubbles: bubbles, from: Constants.levelSelectionVCIdentifier)
    }

    private func loadFromFile(_ fileName: String) -> Bubbles {
        let jsonDecoder = JSONDecoder()
        let fileName = fileName
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)

            let bubbles = try jsonDecoder.decode(Bubbles.self, from: data)
            bubbles.initialiseSpecialBubbles()
            return bubbles
        } catch {
            return Bubbles() // If cannot load data, return empty bubbles
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
