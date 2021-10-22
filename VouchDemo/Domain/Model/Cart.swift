//
//  Cart.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import Foundation

struct Cart: Codable {
    let category: Category?
    let ticket: Ticket?
    let dateSelected: String?
    let nationality: String?
    var number: Int?
    
    func update(category: Category? = nil, ticket: Ticket? = nil, dateSelected: String? = nil, nationality: String? = nil, number: Int? = nil) -> Cart {
        return Cart(category: category == nil ? self.category : category,
                    ticket: ticket == nil ? self.ticket : ticket,
                    dateSelected: dateSelected == nil ? self.dateSelected : dateSelected,
                    nationality: nationality == nil ? self.nationality : nationality,
                    number: number == nil ? self.number : number)
    }
    
    func getDateVisit() -> String {
        return "Date of visit \(dateSelected ?? "")"
    }
    
    func getFee() -> String {
        return "$ \((number ?? 0)*(ticket?.price ?? 0))"
    }
}
