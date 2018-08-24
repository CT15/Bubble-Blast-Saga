//
//  Cannon.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class Cannon: UIImageView {
    private struct CannonConstants {
        static let aimationDurationInSecond = 0.3
        static let animationRepeatCount = 1
        static let spriteEmptySpaceFrac: CGFloat = 0.45
        static let spriteCannonFrac: CGFloat = 1 - spriteEmptySpaceFrac
    }

    private let cannonImage = UIImage(named: "cannon")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialImage()
        setupAnimation()
    }

    private func setupInitialImage() {
        let initialRect = CGRect(x: 0,
                                 y: cannonImage.size.height / 2 * CannonConstants.spriteEmptySpaceFrac,
                                 width: cannonImage.size.width / 6,
                                 height: cannonImage.size.height / 2 * CannonConstants.spriteCannonFrac)

        image = cropImage(cannonImage, rect: initialRect)
    }

    private func cropImage(_ image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage)
    }

    private func setupAnimation() {
        var sprites = [UIImage]()

        for yPos in 0...1 {
            for xPos in 0...5 {
                let rect = CGRect(x: cannonImage.size.width / 6 * CGFloat(xPos),
                                  y: cannonImage.size.height / 2 * CGFloat(yPos) +
                                     cannonImage.size.height / 2 * CannonConstants.spriteEmptySpaceFrac,
                                  width: cannonImage.size.width / 6,
                                  height: cannonImage.size.height / 2 * CannonConstants.spriteCannonFrac)
                sprites.append(cropImage(cannonImage, rect: rect))
            }
        }

        animationImages = sprites

        animationDuration = CannonConstants.aimationDurationInSecond
        animationRepeatCount = CannonConstants.animationRepeatCount
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
