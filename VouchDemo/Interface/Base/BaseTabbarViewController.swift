//
//  Created by DU on 13/10/2021.
//

import UIKit

enum TabBarType: Int, CaseIterable {
    case home, magician, mypage

    var tabBarItem: (title: String, image: String, navigationController: UINavigationController) {
        var title: String = ""
        var image: String = ""
        var viewController = UIViewController()
        switch self {
        case .home:
            title = "Trang Chủ"
            image = "home_disable"
            viewController = HomeViewController.instantiateInitialFromStoryboard()
        case .magician:
            title = "Đại Sư"
            image = "magician_disable"
            viewController = MagicianViewController.instantiateInitialFromStoryboard()
        case .mypage:
            title = "Thông Tin Cá Nhân"
            image = "gear_disable"
            viewController = MyPageViewController.instantiateInitialFromStoryboard()
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        return (title, image, navigationController)
    }
}

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupTabbar()
        self.moveToTabBarIndex(type: .home)
    }

    // MARK: - Public Method
    public func setupTabbar() {
        customTabBar()
        self.viewControllers = TabBarType.allCases.map { $0.tabBarItem.navigationController }
        for (index, tabBarType) in TabBarType.allCases.enumerated() {
            guard let tabBarItems = self.tabBar.items else {
                return
            }
            let tabBarItem = tabBarItems[index]
            tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 4, right: 0)
            tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -2)
            tabBarItem.tag = tabBarType.rawValue
            tabBarItem.title = tabBarType.tabBarItem.title
            tabBarItem.image = UIImage(named: tabBarType.tabBarItem.image)
        }
    }

    private func customTabBar() {
        let tabbarBackgroundColor = UIColor.white
        tabBar.barTintColor = tabbarBackgroundColor
        tabBar.tintColor = UIColor(hexString: "#FF995F")
        tabBar.unselectedItemTintColor = UIColor(hexString: "#636363")
        let font = UIFont.systemFont(ofSize: 9.5, weight: .medium)
        let attributesNormal = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#636363"),
                                NSAttributedString.Key.font: font]
        let attributesSelect = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF995F"),
                                NSAttributedString.Key.font: font]
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelect, for: .selected)
    }

    public func setTabbarHidden(isHidden: Bool) {
        self.tabBar.isHidden = isHidden
        UIView.transition(with: self.view, duration: 0.5, options: .curveLinear, animations: nil)
    }
}

extension TabBarViewController {
    // Move tabbar
    func moveToTabBarIndex(type: TabBarType) {
        guard let viewControllerList = self.viewControllers,
              viewControllerList.count > type.rawValue else {
            return
        }
        self.selectedIndex = type.rawValue
    }

    // Get navigation controller of tabbar
    func getNavigationController(tabbarType: TabBarType) -> UINavigationController? {
        guard let viewControllers = self.viewControllers, viewControllers.count > tabbarType.rawValue else { return nil }
        guard let navigationController = viewControllers[tabbarType.rawValue] as? UINavigationController else { return nil }
        return navigationController
    }
}
