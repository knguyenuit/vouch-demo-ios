//
//  TicketCalendarPopup.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import UIKit

protocol TicketCalendarPopupDelegate: NSObjectProtocol {
    func ticketCalendarSelect(dateSelected: String)
}

class TicketCalendarPopup: BaseViewController {
    @IBOutlet private weak var fsCalendarView: CalenderView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    
    private var dateTimeString: String? {
        didSet {
            showTime()
        }
    }
    private var dateSelected: String?
    weak var delegate: TicketCalendarPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        bindingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(isHidden: true, hidesBackButton: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fsCalendarView.shadow(color: .black, offset: .zero, opacity: 0.4, radius: 4)
    }
    
    private func initUI() {
        dateTimeString = Date().getString(form: "EEEE, d MMM yyyy")
        dateSelected = Date().getString(form: "dd/MM/yyyy")
        showTime()
        fsCalendarView.delegate = self
    }
    
    private func showTime() {
        guard let dateTimeString = self.dateTimeString,
              isViewLoaded else { return }
        dateTimeLabel.text = dateTimeString
    }
}

// Binding Action
extension TicketCalendarPopup {
    private func bindingAction() {
        closeButton.rx.tap.bind { [weak self] (_) in
            guard let self = self else { return }
            self.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)
        
        selectButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.dismiss(animated: false) { [weak self] in
                guard let self = self, let dateSelected = self.dateSelected else { return }
                self.delegate?.ticketCalendarSelect(dateSelected: dateSelected)
            }
        }).disposed(by: disposeBag)
    }
}

// Ticket Delegate
extension TicketCalendarPopup: CalenderDelegate {
    func didTapDate(date: String, dateShow: String) {
        dateTimeString = dateShow
        dateSelected = date
    }
}
