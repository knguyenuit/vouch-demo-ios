//
//  Created by NguyenSeven on 14/10/2021.
//

import Foundation
import UIKit

protocol Router { }

extension UIViewController: Router { }

extension AppDelegate: Router { }

extension Router where Self: UIViewController {
//    /// Move to splash view controller
//    func transitionLoginViewController() {
//        let viewController = LoginViewController.instantiateInitialFromStoryboard()
//        pushViewController(viewController, animated: true)
//    }
//
//    /// Set root view controller by login view controller
//    func setRootViewControllerByLoginViewController() {
//        UIApplication.shared.delegate!.window??.rootViewController = LoginViewController.instantiateInitialFromStoryboard()
//    }
//
//    /// Reset root view controller
//    func resetRootViewController() {
//        UIApplication.shared.delegate!.window??.rootViewController = AppDelegate.shared.tabBarViewController
//    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    func popViewController(animated: Bool) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        navigationController.popViewController(animated: animated)
    }

    func popViewControllers(animated: Bool, count: Int) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        let index = navigationController.viewControllers.count - 1 - count
        navigationController.popToViewController(navigationController.viewControllers[index], animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        navigationController.popToRootViewController(animated: animated)
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        navigationController.popToViewController(viewController, animated: animated)
    }

    func popToViewController(_ viewControllerType: AnyClass, animated: Bool) {
        guard let navigationController = navigationController else {
            AppText.println(title: "NavigationController is not found.", messLog: "")
            return
        }
        if let viewController = navigationController.viewControllers.filter({ $0.isKind(of: viewControllerType) }).last {
            navigationController.popToViewController(viewController, animated: animated)
        }
    }

    func present(initialViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if initialViewController.modalPresentationStyle != .custom {
            initialViewController.modalPresentationStyle = .fullScreen
        }
        if let tabBarController = self.tabBarController {
            tabBarController.present(initialViewController, animated: animated, completion: completion)
        } else if let navigationController = self.navigationController {
            navigationController.present(initialViewController, animated: animated, completion: completion)
        } else {
            present(initialViewController, animated: animated, completion: completion)
        }
    }
}
