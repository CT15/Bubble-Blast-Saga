//
//  Renderer.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 18/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

/// Methods to render the View based on the Model
struct Renderer {

    /// Updates the current bubble and next bubble images of the shooter view according to
    /// the data of the shooter model.
    static func updateShooterBubbleImages(shooter: Shooter, inView view: ShooterView) {
        if let currentBubble = shooter.currentBubble?.getImage() {
            view.currentBubbleContainer.setImage(currentBubble.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            view.currentBubbleContainer.setImage(nil, for: .normal)
        }

        if let nextBubble = shooter.nextBubble?.getImage() {
            view.nextBubbleContainer.setImage(nextBubble.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            view.nextBubbleContainer.setImage(nil, for: .normal)
        }
    }

    /// Creates a bubble image view according to the data of the bubble model and
    /// adds the image into the specified view.
    /// Returns the created image view
    static func renderBubble(_ bubble: Bubble, inView view: UIView) -> UIImageView {
        let bubbleImageView: UIImageView = {
            let imageView = UIImageView(image: bubble.getImage())
            imageView.frame = CGRect(x: bubble.center.x - Constants.bubbleRadius,
                                     y: bubble.center.y - Constants.bubbleRadius,
                                     width: Constants.bubbleDiameter,
                                     height: Constants.bubbleDiameter)
            return imageView
        }()

        view.addSubview(bubbleImageView)

        return bubbleImageView
    }

    /// Sets the center of the bubble image view according to the data of the
    /// bubble model.
    static func moveBubbleImage(_ image: UIImageView, accordingTo bubble: Bubble) {
        image.center = bubble.center
    }

    /// Sets all cells images in the grid according to the data of the bubbles model.
    static func setImagesIn(_ grid: BubbleGrid, accordingTo bubbles: Bubbles) {
        for cell in grid.visibleCells {
            if let indexPath = grid.indexPath(for: cell) {
                setCellImageAt(indexPath, ofGrid: grid, accordingTo: bubbles)
            }
        }
    }

    /// Sets the cell image in the grid at the specified index path according to the data
    /// of the bubbles model.
    static func setCellImageAt(_ indexPath: IndexPath, ofGrid grid: BubbleGrid, accordingTo bubbles: Bubbles) {
        guard let cell = grid.cellForItem(at: indexPath) as? BubbleGridCell else {
            return
        }

        if let bubble = bubbles.getBubbleAt(indexPath) {
            cell.bubbleImageView.layer.opacity = 1.0
            cell.bubbleImageView.image = bubble.getImage()
        } else {
            cell.bubbleImageView.image = nil
            cell.bubbleImageView.layer.opacity = 0.3
        }
    }

    /// Creates image views of the bubbles in the specified set and adds them to the view.
    /// Creates falling animation for these image views.
    static func animateFallingBubbles(_ bubbles: [Bubble], inView view: UIView) {
        var bubbleImages: [UIImageView] = []

        for bubble in bubbles {
            bubbleImages.append(renderBubble(bubble, inView: view))
        }

        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn,
            animations: {
                bubbleImages.forEach {
                    $0.center.y += Constants.screenHeight
                }
        }, completion: { (finished: Bool) -> Void in
                if finished {
                    bubbleImages.forEach { $0.removeFromSuperview() }
                }
        })
    }

    /// Creates image views of the bubbles in the specified set and adds them to the view.
    /// Creates bursting animation for these image views.
    static func animateBurstingBubbles(_ bubbles: [Bubble], inView view: UIView) {
        var bubbleImages: [UIImageView] = []
        var burstImages: [UIImageView] = []

        for bubble in bubbles {
            bubbleImages.append(renderBubble(bubble, inView: view))

            let frame = CGRect(x: bubble.center.x - Constants.bubbleRadius,
                               y: bubble.center.y - Constants.bubbleRadius,
                               width: Constants.bubbleDiameter,
                               height: Constants.bubbleDiameter)
            let bubbleBurst = BubbleBurst(frame: frame)
            view.addSubview(bubbleBurst)
            burstImages.append(bubbleBurst)
        }

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear,
            animations: {
                bubbleImages.forEach {
                    $0.alpha = 0.0
                }
                burstImages.forEach {
                    $0.startAnimating()
                }
            }, completion: { (finished: Bool) -> Void in
                if finished {
                    bubbleImages.forEach { $0.removeFromSuperview() }
                    burstImages.forEach { $0.removeFromSuperview() }
                }
        })
    }

    /// Crops a UIImage according to the specified CGRect
    static func cropImage(_ image: UIImage, inRect rect: CGRect) -> UIImage {
        guard let cgImage = image.cgImage?.cropping(to: rect) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }
}
