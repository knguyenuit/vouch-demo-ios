//
//  BaseViewController.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 12/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    public var disposeBag = DisposeBag()
    private weak var cartButton: UIButton!
    let badgeSize: CGFloat = 20
    let badgeTag = 9830384

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setNavigation(isHidden: Bool = false, hidesBackButton: Bool = false) {
        self.navigationController?.setNavigationBarHidden(isHidden, animated: false)
        self.navigationItem.setHidesBackButton(hidesBackButton, animated: false)
    }
}

extension BaseViewController {
    func navigationDefault(title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(named: "primary")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        addLeftTitle(title: title)
        addCartButton()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func addCartButton() {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightBarButton.setBackgroundImage(UIImage(named: "ic_cart"), for: .normal)
        rightBarButton.addTarget(self, action: #selector(self.cartButtonTapped), for: .touchUpInside)
        cartButton = rightBarButton

        let rightBarButtomItem = UIBarButtonItem(customView: rightBarButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    
    @objc func cartButtonTapped() {
        self.pushViewController(CartViewController(), animated: true)
    }
    
    private func addLeftTitle(title: String) {
        let title = NSAttributedString(string: title,
                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold)])
        let description = NSAttributedString(string: "\nNational Museum Wakanda",
                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .light)])
        let att = NSMutableAttributedString()
        att.append(title)
        att.append(description)
        let button = UIButton(type: .custom)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setAttributedTitle(att, for: .normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    // Custom Bage
    func showBadge(withCount count: Int) {
        if count == 0 {
            removeBadge()
        } else {
            let badge = badgeLabel(withCount: count)
            cartButton.addSubview(badge)

            NSLayoutConstraint.activate([
                badge.leftAnchor.constraint(equalTo: cartButton.leftAnchor, constant: 14),
                badge.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -10),
                badge.widthAnchor.constraint(equalToConstant: badgeSize),
                badge.heightAnchor.constraint(equalToConstant: badgeSize)
            ])
        }
    }

    func badgeLabel(withCount count: Int) -> UILabel {
        let badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .systemRed
        badgeCount.text = String(count)
        return badgeCount
    }
    
    func removeBadge() {
        if let badge = cartButton.viewWithTag(badgeTag) {
            badge.removeFromSuperview()
        }
    }
}
