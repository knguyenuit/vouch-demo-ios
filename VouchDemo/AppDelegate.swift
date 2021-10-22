//
//  AppDelegate.swift
//  VouchDemo
//
//  Created by NguyenSeven on 16/10/2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// Window
    var window: UIWindow?
    /// Tabbar
//    let tabBarViewController = TabBarViewController()
    /// Singleton
    static var shared = AppDelegate()

    /// Did finish launching the app
    ///
    /// - Parameters:
    ///   - application: UIApplication
    ///   - launchOptions: [UIApplication.LaunchOptionsKey: Any]
    /// - Returns: Bool
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup Root ViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootViewController(navigationController: UINavigationController(rootViewController: HomeViewController()))
        setupKeyboardManager()
        return true
    }

    /// Setup root viewcontroller
    ///
    /// - Parameter navigationController: UINavigationController
    func setRootViewController(navigationController: UINavigationController) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    /// Keyboards
    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = ""
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
    }


}

