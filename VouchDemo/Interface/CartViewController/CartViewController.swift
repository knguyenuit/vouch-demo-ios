//
//  CartViewController.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import UIKit

class CartViewController: BaseViewController {
    
    //MARK: Outlets
    //--------------------
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalFeeLabel: UILabel!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    //MARK: Properties
    //--------------------
    private var viewModel = CartViewModel()
    private var carts: [CartData] = []
    
    //MARK: Life cycles
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        bindingData()
        bindingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(isHidden: true, hidesBackButton: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigation(isHidden: false, hidesBackButton: false)
    }
    
    //MARK: Functions
    //--------------------
    private func configTableView() {
        tableView.register(CartTableCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /// Show total fee
    private func showTotalFee() {
        var total: Int = 0
        carts.forEach { (cart) in
            total += cart.getFee()
        }
        totalFeeLabel.text = "$ \(total)"
    }
    
    /// Add Header Section
    private func setupViewSection(titleText: String?) -> UIView {
        let headerSection = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = titleText
        title.textAlignment = .left
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        headerSection.addSubview(title)
        
        title.topAnchor.constraint(equalTo: headerSection.topAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: headerSection.bottomAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: headerSection.leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: headerSection.rightAnchor).isActive = true

        let underLine = UIView()
        underLine.translatesAutoresizingMaskIntoConstraints = false
        underLine.backgroundColor = .systemGray4
        
        headerSection.addSubview(underLine)
        underLine.leftAnchor.constraint(equalTo: headerSection.leftAnchor, constant: 20).isActive = true
        underLine.rightAnchor.constraint(equalTo: headerSection.rightAnchor, constant: 20).isActive = true
        underLine.bottomAnchor.constraint(equalTo: headerSection.bottomAnchor).isActive = true
        underLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return headerSection
    }
}

//MARK: Binding Data
//--------------------
extension CartViewController {
    private func bindingData() {
        let input = CartViewModel.Input(viewWillAppear: rx.viewWillAppear.mapToVoid().asObservable())
        
        let output = viewModel.transform(input: input)
        output.getCarts.drive(onNext: { [weak self] (carts) in
            guard let self = self else { return }
            self.carts = carts
            self.showTotalFee()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func bindingAction() {
        backButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind(onNext: { [weak self] (_) in
            guard let self = self, !self.carts.isEmpty else { return }
            self.pushViewController(CompleteViewController(), animated: true)
        }).disposed(by: disposeBag)
    }
}

//MARK: UITableView Datasource + Delegate
//--------------------
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Config Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section < carts.count else { return UIView() }
        return setupViewSection(titleText: carts[section].title)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // Config Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carts[section].carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < carts.count,
              indexPath.row < carts[indexPath.section].carts.count else { return UITableViewCell() }
        let cell = tableView.dequeue(CartTableCell.self, for: indexPath)
        cell.configure(cart: carts[indexPath.section].carts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//MARK: Cart Cell Delegate
//--------------------
extension CartViewController: CartTableCellDelegate {
    func cartDecreaseTapped(cart: Cart?, cell: CartTableCell) {
        guard let cart = cart,
              let indexPath = tableView.indexPath(for: cell)
        else { return }
        if let number = cart.number, number > 1 {
            let newCart = cart.update(number: number - 1)
            CartDataDefault.updateCart(newCart)
            carts = CartDataDefault.getCartSection()
            showTotalFee()
            tableView.reloadRows(at: [indexPath], with: .none)
        } else {
            // Show Alert confirm remove cart
            let confirmRemoveAler = ConfirmRemoveCartAlert()
            confirmRemoveAler.modalPresentationStyle = .overFullScreen
            confirmRemoveAler.modalTransitionStyle = .crossDissolve
            confirmRemoveAler.removeTapped = { [weak self] in
                guard let self = self else { return }
                CartDataDefault.removeCart(cart)
                self.carts = CartDataDefault.getCartSection()
                self.showTotalFee()
                self.tableView.reloadData()
            }
            self.present(confirmRemoveAler, animated: true, completion: nil)
        }
    }
    
    func cartIncreaseTapped(cart: Cart?, cell: CartTableCell) {
        guard let cart = cart,
              let indexPath = tableView.indexPath(for: cell)
        else { return }
        if let number = cart.number {
            let newCart = cart.update(number: number + 1)
            CartDataDefault.updateCart(newCart)
            carts = CartDataDefault.getCartSection()
            showTotalFee()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
