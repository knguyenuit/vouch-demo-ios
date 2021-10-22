//
//  ConfirmRemoveCartAlert.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import UIKit

class ConfirmRemoveCartAlert: BaseViewController {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var removeTapped: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindingAction()
    }
    
    private func setupUI() {
        contentView.shadow(color: .black, offset: .zero, opacity: 0.5, radius: 5.0)
    }
}

// Binding Action
extension ConfirmRemoveCartAlert {
    private func bindingAction() {
        cancelButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        removeButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.removeTapped?()
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
