//
//  AppKey.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 08/08/2021.
//

import Foundation

struct AppKey {
    struct FirestoreClientKey {
        static let listRoom = "rooms"
        static let listMessage = "messages"
    }

    struct APIClientKey {
        static let platform = "iOS"
    }

    struct UserDefault {
        static let userToken = "user_token"
        static let userInfo = "user_info"
        static let carts = "carts"
        static let categories = "categories"
    }
}
