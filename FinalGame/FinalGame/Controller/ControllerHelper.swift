//
//  ControllerHelper.swift
//  FinalGame
//
//  Created by Calvin Tantio on 3/3/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

import UIKit

/// Helper functions for transitioning between view controllers
struct ControllerHelper {
    static func initialiseViewController(_ viewController: UIViewController, parent: UIViewController) {
        parent.addChildViewController(viewController)

        guard let viewControllerView = viewController.view else {
            return
        }

        parent.view.addSubview(viewControllerView)
        viewControllerView.frame = CGRect(x: 0, y: 0, width: parent.view.frame.width, height: parent.view.frame.height)

        viewController.didMove(toParentViewController: parent)
    }

    static func closeViewController(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}
