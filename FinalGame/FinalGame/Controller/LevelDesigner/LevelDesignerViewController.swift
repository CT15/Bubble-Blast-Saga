//
//  LevelDesignerViewController.swift
//  FinalGame
//
//  Created by Calvin Tantio on 1/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

// To pass information from the level designer to the playing area
protocol LevelDesignerViewControllerDelegate: class {
    func setupPlayingArea(bubbles: Bubbles, from previousVC: String)
    func setupMenu()
}

class LevelDesignerViewController: UIViewController {

    // All the UI elements must and will be initialised.
    // All UI elements will always have values after being initialised.
    var paletteChosen: BubbleType!

    var paletteArea: PaletteArea!

    var bubbleGrid: BubbleGrid!
    var bubbles = Bubbles()

    weak var delegate: LevelDesignerViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        paletteChosen = .blue  // default value when the application starts

        setupPaletteArea()
        setupBubbleGrid()

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(self.longPressToDeleteCell))
        bubbleGrid.addGestureRecognizer(longPressGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dragToFillBubbleCell))
        bubbleGrid.addGestureRecognizer(panGestureRecognizer)
    }

    @objc
    func longPressToDeleteCell(gesture: UILongPressGestureRecognizer) {
        let position = gesture.location(in: bubbleGrid)
        if let indexPath = bubbleGrid.indexPathForItem(at: position) {
            bubbles.removeBubbleAt(indexPath)
            Renderer.setCellImageAt(indexPath, ofGrid: bubbleGrid, accordingTo: bubbles)
        }
    }

    @objc
    func dragToFillBubbleCell(gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: bubbleGrid)
        if let indexPath = bubbleGrid.indexPathForItem(at: position) {
            bubbles.removeBubbleAt(indexPath)
            if let bubble = bubbles.getBubbleAt(indexPath) {
                if paletteChosen != .none {
                    bubble.type = paletteChosen
                }
            } else if paletteChosen != .none {
                let bubbleToAdd = createBubbleBasedOn(paletteChosen, at: indexPath)
                bubbles.addBubbleAt(indexPath, bubble: bubbleToAdd)
            }
            Renderer.setCellImageAt(indexPath, ofGrid: bubbleGrid, accordingTo: bubbles)
        }
    }

    func createBubbleBasedOn(_ paletteChosen: BubbleType, at indexPath: IndexPath) -> Bubble {
        var bubble: Bubble
        let center = bubbleGrid.cellForItem(at: indexPath)!.center
        switch paletteChosen {
        case .lightning:
            bubble = LightningBubble(type: paletteChosen, center: center)
        case .bomb:
            bubble = BombBubble(type: paletteChosen, center: center)
        case .star:
            bubble = StarBubble(type: paletteChosen, center: center)
        default:
            bubble = Bubble(type: paletteChosen, center: center)
        }
        return bubble
    }

    private func setupPaletteArea() {
        paletteArea = {
            let paletteArea = PaletteArea()
            paletteArea.translatesAutoresizingMaskIntoConstraints = false
            return paletteArea
        }()

        paletteArea.delegate = self

        view.addSubview(paletteArea)
        paletteArea.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        paletteArea.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        paletteArea.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        paletteArea.heightAnchor.constraint(equalTo: view.heightAnchor,
                                            multiplier: 0.2).isActive = true
    }

    private func setupBubbleGrid() {
        bubbleGrid = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            let bubbleGrid = BubbleGrid(frame: view.frame, collectionViewLayout: layout)
            bubbleGrid.translatesAutoresizingMaskIntoConstraints = false
            return bubbleGrid
        }()

        bubbleGrid.delegate = self
        bubbleGrid.dataSource = self

        view.addSubview(bubbleGrid)
        bubbleGrid.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bubbleGrid.bottomAnchor.constraint(equalTo: paletteArea.topAnchor).isActive = true
        bubbleGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bubbleGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
