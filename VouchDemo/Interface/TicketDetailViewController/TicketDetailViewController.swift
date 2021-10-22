//
//  TicketDetailViewController.swift
//  VouchDemo
//
//  Created by NguyenSeven on 18/10/2021.
//

import UIKit

class TicketDetailViewController: BaseViewController {
    
    //MARK: Outlets
    //--------------------
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var ticketTitleLabel: UILabel!
    @IBOutlet private weak var feeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var addCartButton: UIButton!
    
    //MARK: Properties
    //--------------------
    private var viewModel: TicketDetailViewModel
    
    init(viewModel: TicketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycles
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingAction()
        bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationDefault(title: "Ticket Detail")
        showBadge(withCount: CartDataDefault.cartBadge)
    }
    
    //MARK: Functions
    //--------------------
    private func loadData(ticket: Ticket) {
        ticketTitleLabel.text = ticket.title
        descriptionLabel.text = ticket.description
        feeLabel.text = ticket.getFee()
    }
    
    private func showCalendar() {
        let calendarPopup = TicketCalendarPopup()
        calendarPopup.modalPresentationStyle = .overCurrentContext
        calendarPopup.modalTransitionStyle = .crossDissolve
        calendarPopup.delegate = self
        present(calendarPopup, animated: false, completion: nil)
    }
}

//MARK: Binding Data & Action
//--------------------
extension TicketDetailViewController {
    private func bindingAction() {
        backButton.rx.tap.bind { [weak self] (_) in
            guard let self = self else { return }
            self.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        addCartButton.rx.tap.bind { [weak self] (_) in
            guard let self = self else { return }
            self.showCalendar()
        }.disposed(by: disposeBag)
    }
    
    private func bindingData() {
        let input = TicketDetailViewModel.Input(viewWillAppear: rx.viewWillAppear.mapToVoid().asObservable())
        
        let output = viewModel.transform(input: input)
        output.getTicket.drive(onNext: { [weak self] (ticket) in
            guard let self = self else { return }
            self.loadData(ticket: ticket)
        }).disposed(by: disposeBag)
    }
}

//MARK: TicketCalendarPopup Delegate
//--------------------
extension TicketDetailViewController: TicketCalendarPopupDelegate {
    func ticketCalendarSelect(dateSelected: String) {
        guard let category = viewModel.category else { return }
        let ticketingPopup = AddCartPopup(category: category,
                                          ticket: viewModel.ticket,
                                          dateCreated: dateSelected)
        ticketingPopup.modalPresentationStyle = .overCurrentContext
        ticketingPopup.modalTransitionStyle = .crossDissolve
        ticketingPopup.delegate = self
        present(ticketingPopup, animated: true, completion: nil)
    }
}

//MARK: Add Cart Popup Delegate
//--------------------
extension TicketDetailViewController: AddCartPopupDelegate {
    func addCartComplete() {
        showBadge(withCount: CartDataDefault.cartBadge)
    }
}
