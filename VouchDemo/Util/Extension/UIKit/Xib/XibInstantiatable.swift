//
//  Created by NguyenSeven on 08/08/2021.
//

import UIKit

protocol XibInstantiatable { }

extension UIView: XibInstantiatable { }

extension XibInstantiatable where Self: UIView {

    static func instantiateFromXib(xibName: String = Self.className) -> Self {
        let bundle = Bundle(for: self)
        let xib = UINib(nibName: xibName, bundle: bundle)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("UIView could not create.")
        }
        return view
    }

    func loadFromXib(xibName: String = Self.className) {
        let xib = UINib(nibName: xibName, bundle: nil)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("UIView could not create.")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(
            [
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
    }
}
