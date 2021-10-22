//
//  BaseTextField.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 15/10/2021.
//

import UIKit

class BaseTextField: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet public weak var textField: UITextField!

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
        Bundle.main.loadNibNamed("BaseTextField", owner: self, options: nil)
        addSubview(contentView)
        contentView.anchor(top: self.topAnchor,
                           bottom: self.bottomAnchor,
                           left: self.leftAnchor,
                           right: self.rightAnchor)
    }

    public func config(title: String?, placeHolder: String?, keyboardType: UIKeyboardType = .default) {
        titleLabel.text = title
        textField.placeholder = placeHolder
        textField.keyboardType = keyboardType
    }
}
