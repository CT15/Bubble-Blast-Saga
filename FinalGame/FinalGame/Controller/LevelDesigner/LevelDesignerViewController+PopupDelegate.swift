//
//  ViewController+PopupDelegate.swift
//  LevelDesigner
//
//  Created by calvint on 10/2/18.
//  Copyright © 2018 nus.cs3217.a0101010. All rights reserved.
//

import UIKit

/// Extension containing delegate methods to save and load level designs
extension LevelDesignerViewController: SavePopupDelegate, LoadPopupDelegate {
    func saveToFile(_ fileName: String) {
        let jsonEncoder = JSONEncoder()
        let fileName = fileName
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            let jsonData = try jsonEncoder.encode(bubbles)
            try jsonData.write(to: fileURL, options: .atomic)
        } catch {
            assertionFailure("Error saving file")
        }
    }

    func loadFromFile(_ fileName: String) {
        let jsonDecoder = JSONDecoder()
        let fileName = fileName
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)

            var indexPathsOfExistingBubbles = bubbles.getIndexPathsOfFilledCells()

            bubbles = try jsonDecoder.decode(Bubbles.self, from: data)

            indexPathsOfExistingBubbles.append(contentsOf: bubbles.getIndexPathsOfFilledCells())

            bubbles.initialiseSpecialBubbles()

            for indexPath in indexPathsOfExistingBubbles {
                Renderer.setCellImageAt(indexPath, ofGrid: bubbleGrid, accordingTo: bubbles)
            }
        } catch {
            return  // If cannot load data, do nothing
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
