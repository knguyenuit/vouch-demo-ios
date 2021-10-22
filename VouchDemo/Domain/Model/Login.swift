//
//  Login.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 14/10/2021.
//

import Foundation

struct LoginRequest {
    var phone, password: String!
}

struct LoginResponse: Codable {
    let userId, mobile, platform, loginPlatform: String?
    let loginId, loginTime, createTime: String?
    let roleId: Int?
    let registerTimeFrom, registerTimeTo, hxUser, nickName: String?
}
