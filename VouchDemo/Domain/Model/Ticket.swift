//
//  Ticket.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import Foundation

struct TicketData: Codable {
    let data: [Ticket]
}

struct Ticket: Codable {
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
    
    func getFee() -> String {
        guard let price = self.price else { return "Free" }
        return price > 0 ? "$\(price)" : "Free"
    }
}
