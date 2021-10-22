//
//  AddCartPopup.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import UIKit
enum NationalityType {
    case singaporean, foreigner
    
    var text: String {
        switch self {
        case .singaporean: return "Singaporean/PR"
        case .foreigner: return "Foreigner"
        }
    }
}

protocol AddCartPopupDelegate: NSObjectProtocol {
    func addCartComplete()
}

class AddCartPopup: BaseViewController {
    @IBOutlet private weak var ticketTitleLabel: UILabel!
    @IBOutlet private weak var feeLabel: UILabel!
    @IBOutlet private weak var singaporeButton: UIButton!
    @IBOutlet private weak var foreignerButton: UIButton!
    @IBOutlet private weak var decreaseButton: UIButton!
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var increaseButton: UIButton!
    @IBOutlet private weak var addCartButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    private var nationality: NationalityType = .singaporean {
        didSet {
            updateNationalityUI()
        }
    }
    
    private var number: Int = 1 {
        didSet {
            updateNumber()
        }
    }
    private var category: Category
    private var ticket: Ticket
    private var dateCreated: String
    weak var delegate: AddCartPopupDelegate?
    
    init(category: Category, ticket: Ticket, dateCreated: String) {
        self.category = category
        self.ticket = ticket
        self.dateCreated = dateCreated
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNationalityUI()
        bindingAction()
        updateNumber()
        updateUI()
    }
    
    private func updateNationalityUI() {
        guard isViewLoaded else { return }
        singaporeButton.backgroundColor = nationality == .singaporean ? .systemGray5 : .white
        foreignerButton.backgroundColor = nationality == .foreigner ? .systemGray5 : .white
    }
    
    private func updateNumber() {
        guard isViewLoaded else { return }
        numberLabel.text = "\(number)"
    }
    
    private func updateUI() {
        ticketTitleLabel.text = ticket.title
        feeLabel.text = ticket.getFee()
    }
}

// Binding Action
extension AddCartPopup {
    private func bindingAction() {
        singaporeButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.nationality = .singaporean
        }).disposed(by: disposeBag)
        
        foreignerButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.nationality = .foreigner
        }).disposed(by: disposeBag)
        
        decreaseButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if self.number > 1 {
                self.number -= 1
            }
        }).disposed(by: disposeBag)
        
        increaseButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.number += 1
        }).disposed(by: disposeBag)
        
        closeButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        addCartButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let cart = Cart(category: self.category,
                            ticket: self.ticket,
                            dateSelected: self.dateCreated,
                            nationality: self.nationality.text,
                            number: self.number)
            CartDataDefault.saveCart(cart)
            self.delegate?.addCartComplete()
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}
