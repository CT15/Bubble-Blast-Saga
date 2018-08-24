//
//  PlayingAreaViewController.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 15/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit
import PhysicsEngine
import AVFoundation

protocol PlayingAreaViewControllerDelegate: class {
    func setupLevelSelection()
    func setupLevelDesigner()
}

class PlayingAreaViewController: UIViewController {

    var bubbleGrid: BubbleGrid!
    var bubbles: Bubbles!

    var shooterView: ShooterView!
    lazy var shooter = Shooter(frame: view.frame, bubbles: bubbles)

    var limitLine: UIImageView!

    var movingBubble: Bubble?   // the bubble object fired by the shooter
    var movingBubbleImageView: UIImageView?

    var displayLink: CADisplayLink?
    var tapGestureRecognizer: UITapGestureRecognizer!

    var player: AVAudioPlayer!

    var previousVC: String!

    weak var delegate: PlayingAreaViewControllerDelegate!

    convenience init(bubbles: Bubbles, from previousVC: String) {
        self.init(nibName: nil, bundle: nil)
        self.bubbles = bubbles
        self.previousVC = previousVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupShooterView()
        setupBubbleGrid()
        setupLimitLine()
        setupGestureRecognizer()
    }

    private func setupShooterView() {
        let shooterViewFrameHeight = 2.5 * Constants.bubbleDiameter
        let shooterViewFrame = CGRect(x: 0, y: view.frame.height - shooterViewFrameHeight,
                                      width: view.frame.width, height: shooterViewFrameHeight)
        shooterView = ShooterView(frame: shooterViewFrame)
        shooterView.delegate = self

        view.addSubview(shooterView)
        Renderer.updateShooterBubbleImages(shooter: shooter, inView: shooterView)
    }

    private func setupBubbleGrid() {
        bubbleGrid = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            let bubbleGridFrameHeight = view.frame.height - 2.5 * Constants.bubbleDiameter
            let bubbleGridFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: bubbleGridFrameHeight)

            let bubbleGrid = BubbleGrid(frame: bubbleGridFrame, collectionViewLayout: layout)

            return bubbleGrid
        }()

        bubbleGrid.delegate = self
        bubbleGrid.dataSource = self

        view.addSubview(bubbleGrid)
        removeFloatingBubbles()
    }

    private func setupLimitLine() {
        limitLine = {
            let imageView = UIImageView()

            let height = 0.5 * Constants.bubbleRadius
            // The limit line is located near the bottom of the bubble grid.
            let bubbleGridFrameHeight = view.frame.height - 2.5 * Constants.bubbleDiameter
            imageView.frame = CGRect(x: 0, y: bubbleGridFrameHeight - 2 * height,
                                     width: view.frame.width, height: height)
            imageView.backgroundColor = .red
            imageView.alpha = 0.5

            return imageView
        }()

        view.addSubview(limitLine)
    }

    private func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shootBubble))
        bubbleGrid.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    private func shootBubble(gesture: UITapGestureRecognizer) {
        guard let bubbleShot = shooter.shootBubble() else {
            return  // Does nothing if there is no more bubble to shoot in the shooter
        }

        Renderer.updateShooterBubbleImages(shooter: shooter, inView: shooterView)
        tapGestureRecognizer.isEnabled = false  // Does not allow player to shoot another bubble
                                                // before the current one snapped into the grid

        stopDisplayLink()   // makes sure that the previously running display link is stopped

        // moving bubble to embody the bubble shot by the shooter
        let position = gesture.location(in: view)

        let dx = position.x - shooter.center.x
        let dy = position.y - shooter.center.y
        bubbleShot.directionVector = CGVector(dx: dx, dy: dy)
        movingBubble = bubbleShot

        shooterView.animateCannon(rotationAngle: -atan(dx/dy))
        player = AudioHelper.setupPlayer(fileName: "silencer", loop: 1)

        if let bubbleToRender = movingBubble {
            movingBubbleImageView = Renderer.renderBubble(bubbleToRender, inView: view)
            if let imageView = movingBubbleImageView {
                view.sendSubview(toBack: imageView)
            }
        }

        displayLink = {     // initialising display link and add it to a run loop
            let displayLink = CADisplayLink(target: self, selector: #selector(shooterDidFire))
            displayLink.add(to: .main, forMode: .commonModes)
            return displayLink
        }()
    }

    @objc
    private func shooterDidFire(_ displayLink: CADisplayLink) {
        guard let bubble = movingBubble, let bubbleImage = movingBubbleImageView else {
            return
        }

        Renderer.moveBubbleImage(bubbleImage, accordingTo: bubble)
        bubble.move()

        if bubble.doesHitTopWall || bubbles.intersectWith(bubble) {
            snapBubbleToGrid(bubbleToSnap: bubble)

            movingBubbleImageView?.removeFromSuperview()
            movingBubbleImageView = nil // No longer requires moving bubble image view
            movingBubble = nil          // No longer requires moving bubble object

            stopDisplayLink()

            self.tapGestureRecognizer.isEnabled = true
            checkGameOver()
        }

    }

    private func snapBubbleToGrid(bubbleToSnap: Bubble) {
        var closestUnfilledCellIndexPath: IndexPath!    // in order for the bubble to snap to the grid,
                                                        // a cell must exist
        var distance = CGFloat.infinity // initial value that will be overwritten

        let unfilledCell = bubbleGrid.visibleCells.filter {
            !bubbles.getIndexPathsOfFilledCells()
                    .contains(bubbleGrid.indexPath(for: $0)!) }

        for cell in unfilledCell {
            let centersDistance = GameMath.distance(source: bubbleToSnap.center, destination: cell.center)

            if centersDistance < distance {
                closestUnfilledCellIndexPath = bubbleGrid.indexPath(for: cell)
                distance = centersDistance
            }
        }

        // changes the center of the bubble to match the center of the cell that it snaps to
        // since closestUnfilledIndexPath is acquired based on the cell, cell must not be nil
        bubbleToSnap.center = bubbleGrid.cellForItem(at: closestUnfilledCellIndexPath)!.center

        bubbles.addBubbleAt(closestUnfilledCellIndexPath, bubble: bubbleToSnap)
        Renderer.setCellImageAt(closestUnfilledCellIndexPath, ofGrid: bubbleGrid, accordingTo: bubbles)

        let delayInSeconds = 0.1    // delay before popping the bubble
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.popClusterOfBubblesStartingFrom(closestUnfilledCellIndexPath)
        }
    }

    private func popClusterOfBubblesStartingFrom(_ startingIndexPath: IndexPath) {
        let bubblesRemoved = bubbles.popBubblesStartingFrom(startingIndexPath)
        if !bubblesRemoved.isEmpty {
            Renderer.animateBurstingBubbles(Array(bubblesRemoved), inView: view)
            Renderer.setImagesIn(bubbleGrid, accordingTo: bubbles)
            player = AudioHelper.setupPlayer(fileName: "pop", loop: 1)

            removeFloatingBubbles() // caused by the removal of the bubble cluster
        }
    }

    private func removeFloatingBubbles() {
        let bubblesRemoved = bubbles.removeFloatingBubble()
        Renderer.animateFallingBubbles(bubblesRemoved, inView: view)
        Renderer.setImagesIn(bubbleGrid, accordingTo: bubbles)

        checkGameOver()
    }

    private func checkGameOver() {
        if bubbles.containsBubbleInLastSection() || bubbles.isEmpty || shooter.currentBubble == nil {
            let status: String
            if bubbles.isEmpty {
                status = "WIN"
            } else {
                status = "LOSE"
            }
            let gameCompletePopupViewController = GameCompletePopupViewController(status: status)
            gameCompletePopupViewController.delegate = self
            ControllerHelper.initialiseViewController(gameCompletePopupViewController, parent: self)
        }
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
