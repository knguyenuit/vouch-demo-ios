//
//  CartTableCell.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import UIKit

protocol CartTableCellDelegate:  NSObjectProtocol {
    func cartDecreaseTapped(cart: Cart?, cell: CartTableCell)
    func cartIncreaseTapped(cart: Cart?, cell: CartTableCell)
}

class CartTableCell: UITableViewCell {
    @IBOutlet private weak var ticketTitleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var dateOfVisitLabel: UILabel!
    @IBOutlet private weak var feeLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    private var cart: Cart?
    weak var delegate: CartTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(cart: Cart) {
        self.cart = cart
        ticketTitleLabel.text = cart.ticket?.title
        categoryLabel.text = cart.category?.name
        dateOfVisitLabel.text = cart.getDateVisit()
        feeLabel.text = cart.getFee()
        numberLabel.text = "\(cart.number ?? 1)"
    }
    
    @IBAction func decreaseBtnTapped(_ sender: Any) {
        delegate?.cartDecreaseTapped(cart: cart, cell: self)
    }
    
    @IBAction func increaseBtnTapped(_ sender: Any) {
        delegate?.cartIncreaseTapped(cart: cart, cell: self)
    }
}
