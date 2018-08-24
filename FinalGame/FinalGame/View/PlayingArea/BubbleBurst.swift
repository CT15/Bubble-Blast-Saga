//
//  BubbleBurst.swift
//  FinalGame
//
//  Created by Calvin Tantio on 4/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

class BubbleBurst: UIImageView {
    private struct BubbleBurstConstants {
        static let aimationDurationInSecond = 0.3
        static let animationRepeatCount = 1
    }

    private let burstImage = UIImage(named: "bubble-burst")!

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupInitialImage()
        setupAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupInitialImage() {
        let initialRect = CGRect(x: 0, y: 0, width: burstImage.size.width / 4, height: burstImage.size.height)
        image = cropImage(burstImage, rect: initialRect)
    }

    private func cropImage(_ image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage)
    }

    private func setupAnimation() {
        var sprites = [UIImage]()

        for index in 0...3 {
            let rect = CGRect(x: burstImage.size.width / 4 * CGFloat(index),
                              y: 0,
                              width: burstImage.size.width / 4,
                              height: burstImage.size.height)
            sprites.append(cropImage(burstImage, rect: rect))
        }

        animationImages = sprites

        animationDuration = BubbleBurstConstants.aimationDurationInSecond
        animationRepeatCount = BubbleBurstConstants.animationRepeatCount
    }

}
