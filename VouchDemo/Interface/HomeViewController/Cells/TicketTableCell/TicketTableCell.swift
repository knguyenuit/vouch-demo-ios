//
//  TicketTableCell.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import UIKit

class TicketTableCell: UITableViewCell {
    @IBOutlet private weak var ticketNameLabel: UILabel!
    @IBOutlet private weak var feeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(categoryName: String, ticketModel: Ticket) {
        ticketNameLabel.text = ticketModel.title
        feeLabel.text = ticketModel.getFee()
        categoryLabel.text = categoryName
        descriptionLabel.text = ticketModel.description
    }
}
