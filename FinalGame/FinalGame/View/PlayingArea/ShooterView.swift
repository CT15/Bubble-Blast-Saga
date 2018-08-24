//
//  ShooterView.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 17/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

protocol ShooterViewDelegate: class {
    func switchShooterBubbles()
    func back()
}

class ShooterView: UIView {

    private struct ShooterViewConstants {
        static let buttonFontSize: CGFloat = 30
        static let cannonBaseHeight = 1.5 * Constants.bubbleDiameter
        static let cannonBaseWidth = 2.0 * Constants.bubbleDiameter
    }

    var currentBubbleContainer = UIButton(type: .system)
    var nextBubbleContainer = UIButton(type: .system)

    var backButton: UIButton!

    var cannonBase: UIImageView!
    var cannon: Cannon!

    weak var delegate: ShooterViewDelegate!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBubblePlaceHolder()
        setupCannon()
        setupCannonBase()
        setupButton()
    }

    private func setupBubblePlaceHolder() {

        for bubbleContainer in [currentBubbleContainer, nextBubbleContainer] {
            bubbleContainer.contentMode = .scaleAspectFit
            bubbleContainer.backgroundColor = .black
            bubbleContainer.layer.cornerRadius = Constants.bubbleRadius
            bubbleContainer.addTarget(self, action: #selector(didPressBubbleContainer),
                                      for: UIControlEvents.touchUpInside)

            addSubview(bubbleContainer)
        }

        currentBubbleContainer.frame = CGRect(x: Constants.screenCenterX - Constants.bubbleRadius,
                                              y: frame.height - 1.5 * Constants.bubbleDiameter,
                                              width: Constants.bubbleDiameter,
                                              height: Constants.bubbleDiameter)
        nextBubbleContainer.frame = CGRect(x: Constants.screenCenterX * 0.25 - Constants.bubbleRadius,
                                           y: frame.height - Constants.bubbleDiameter,
                                           width: Constants.bubbleDiameter,
                                           height: Constants.bubbleDiameter)
    }

    private func setupCannon() {
        let cannonFrame = CGRect(x: Constants.screenCenterX - ShooterViewConstants.cannonBaseWidth / 2,
                                 y: 0,
                                 width: ShooterViewConstants.cannonBaseWidth,
                                 height: 2.1 * Constants.bubbleDiameter)
        cannon = Cannon(frame: cannonFrame)
        addSubview(cannon)
    }

    private func setupCannonBase() {
        cannonBase = UIImageView(image: UIImage(named: "cannon-base"))
        cannonBase.frame = CGRect(x: Constants.screenCenterX - ShooterViewConstants.cannonBaseWidth / 2,
                                  y: frame.height - ShooterViewConstants.cannonBaseHeight,
                                  width: ShooterViewConstants.cannonBaseWidth,
                                  height: ShooterViewConstants.cannonBaseHeight)
        addSubview(cannonBase)
    }

    private func setupCannonAnimationImages() -> [UIImage] {
        var sprites = [UIImage]()
        let image = UIImage(named: "cannon")!

        for yPos in 0...1 {
            for xPos in 0...5 {
                let rect = CGRect(x: image.size.width / 6 * CGFloat(xPos), y: image.size.height / 2 * CGFloat(yPos) + image.size.height / 4.5, width: image.size.width / 6, height: (image.size.height / 2) * 0.8)
                sprites.append(cropImage(image, rect: rect))
            }
        }

        return sprites
    }

    private func cropImage(_ image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage)
    }

    private func setupButton() {
        backButton = ViewHelper.makeButtonWithLabel("BACK")
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: ShooterViewConstants.buttonFontSize)
        backButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        let buttonContainer = ViewHelper.makeContainerFor(backButton)
        buttonContainer.frame = CGRect(x: Constants.screenWidth * 0.75,
                                       y: 0,
                                       width: Constants.screenWidth * 0.25,
                                       height: frame.height)

        addSubview(buttonContainer)
    }

    func animateCannon(rotationAngle: CGFloat) {
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.7), view: cannon)
        cannon.transform = CGAffineTransform(rotationAngle: rotationAngle)
        cannon.startAnimating()
    }

    private func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPoint(x: view.frame.size.width * anchorPoint.x, y: view.frame.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.frame.size.width * view.layer.anchorPoint.x,
                               y: view.frame.size.height * view.layer.anchorPoint.y)

        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)

        var position: CGPoint = view.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }

    @objc
    private func didPressBubbleContainer() {
        delegate.switchShooterBubbles()
    }

    @objc
    private func didTapButton() {
        delegate.back()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
