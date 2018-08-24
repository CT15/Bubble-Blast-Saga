//
//  PlayingAreaViewController+ShooterViewDelegate.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 19/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

extension PlayingAreaViewController: ShooterViewDelegate {
    func switchShooterBubbles() {
        shooter.switchBubble()
        Renderer.updateShooterBubbleImages(shooter: shooter, inView: shooterView)
    }

    func back() {
        ControllerHelper.closeViewController(self)
        switch previousVC {
        case Constants.levelSelectionVCIdentifier:
            delegate.setupLevelSelection()
        case Constants.levelDesignerVCIdentifier:
            delegate.setupLevelDesigner()
        default:
            break
        }
    }
}
