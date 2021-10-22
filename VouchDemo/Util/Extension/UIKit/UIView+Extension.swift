//
//  Created by NguyenSeven on 22/03/2021.
//

import UIKit

// MARK: - Auto layout

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                bottom: NSLayoutYAxisAnchor? = nil,
                paddingBottom: CGFloat = 0,
                left: NSLayoutXAxisAnchor? = nil,
                paddingLeft: CGFloat = 0,
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
    }

    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

extension UIView {
    func shadow(color: UIColor = .black, offset: CGSize = .zero, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    @available(iOS 13.0, *)
    func addIndicatorActivity(_ indicatorView: UIActivityIndicatorView, _ style: UIActivityIndicatorView.Style = .large) {
        self.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorView.style = style
        indicatorView.alpha = 0.8
        indicatorView.startAnimating()
    }
}

extension UIViewController {

    func showAlert(title: String?, message: String?, titleButtonDone: String? = "OK", titleButtonCancel: String?, doneAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // cancel button
        if let titleCancel = titleButtonCancel {
            let actionCancel = UIAlertAction(title: titleCancel, style: .default) { (_: UIAlertAction) in
                if let cancelHandler = cancelAction {
                    cancelHandler()
                }
            }
            alertController.addAction(actionCancel)
        }

        // done button
        if let titleDone = titleButtonDone {
            let actionDone = UIAlertAction(title: titleDone, style: .default) { (_: UIAlertAction) in
                if let doneHandler = doneAction {
                     doneHandler()
                }
            }
            alertController.addAction(actionDone)
        }

        // present
        self.present(alertController, animated: true, completion: nil)
    }
}
