//
//  HomeContentViewController.swift
//  VouchDemo
//
//  Created by NguyenSeven on 18/10/2021.
//

import UIKit

protocol HomeContentViewControllerDelegate: NSObjectProtocol {
    func didSelectTicket(_ ticket: Ticket, category: Category?)
}

class HomeContentViewController: BaseViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: HomeContentViewModel
    private var tickets: [Ticket] = []
    private var category: Category?
    weak var delegate: HomeContentViewControllerDelegate?
    
    init(viewModel: HomeContentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(isHidden: true, hidesBackButton: true)
    }
    
    private func configTableView() {
        tableView.register(TicketTableCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// Binding Data
extension HomeContentViewController {
    private func bindingData() {
        let input = HomeContentViewModel.Input(viewWillAppear: rx.viewWillAppear.mapToVoid().asObservable())
        
        let output = viewModel.transform(input: input)
        output.getTickets.drive(onNext: { [weak self] (ticketData, category) in
            guard let self = self else { return }
            self.tickets = ticketData.data
            self.category = category
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// UITableView Datasource + Delegate
extension HomeContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < tickets.count else { return UITableViewCell() }
        let cell = tableView.dequeue(TicketTableCell.self, for: indexPath)
        cell.configure(categoryName: category?.name ?? "", ticketModel: tickets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < tickets.count else { return }
        delegate?.didSelectTicket(tickets[indexPath.row], category: category)
    }
}
