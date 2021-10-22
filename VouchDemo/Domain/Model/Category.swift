//
//  Category.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import Foundation

struct CategoryData: Codable {
    let data: [Category]
}

struct Category: Codable {
    let id: Int?
    let name: String?
}
