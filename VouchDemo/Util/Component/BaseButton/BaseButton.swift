//
//  BaseButton.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 15/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

class BaseButton: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet fileprivate weak var button: UIButton!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    // MARK: - Private Method
    private func initView() {
        Bundle.main.loadNibNamed("BaseButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.anchor(top: self.topAnchor,
                           bottom: self.bottomAnchor,
                           left: self.leftAnchor,
                           right: self.rightAnchor)
    }

    public func config(text: String?, enable: Bool = true) {
        button.setTitle(text, for: .normal)
        button.backgroundColor = UIColor(named: "grey_primary")
        button.isEnabled = enable
    }
}

extension Reactive where Base: BaseButton {
    var tap: RxCocoa.ControlEvent<Void> {
        return base.button.rx.tap
    }
}

extension Reactive where Base: BaseButton {
    var enable: Binder<Bool> {
        return Binder(base) { view, enabled in
            view.button.isEnabled = enabled
            view.button.backgroundColor = enabled ? UIColor(named: "orage_primary") : UIColor(named: "grey_primary")
        }
    }
}
