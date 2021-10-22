//
//  CompleteViewController.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import UIKit

class CompleteViewController: BaseViewController {
    @IBOutlet private weak var backToHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(isHidden: true, hidesBackButton: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigation(isHidden: false, hidesBackButton: true)
    }
}

// Binding Action
extension CompleteViewController {
    private func bindingAction() {
        backToHomeButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            CartDataDefault.removeAll()
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
