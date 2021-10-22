//
//  Created by NguyenSeven on 14/10/2021.
//

import Foundation

struct AppUserDefault {
    static let standard = UserDefaults.standard
    typealias Key = AppKey

    static var userToken: String? {
        set {
            standard.set(newValue, forKey: Key.UserDefault.userToken)
        }
        get {
            standard.string(forKey: Key.UserDefault.userToken)
        }
    }

    static func saveUserInfo(info: LoginResponse) {
        if let encoded = try? JSONEncoder().encode(info) {
            UserDefaults.standard.set(encoded, forKey: Key.UserDefault.userInfo)
        }
    }

    static func getUserInfo() -> LoginResponse? {
        guard let userInfo = UserDefaults.standard.object(forKey: Key.UserDefault.userInfo) as? Data,
              let loadedUserInfo = try? JSONDecoder().decode(LoginResponse.self, from: userInfo) else { return nil }
        return loadedUserInfo
    }
}

struct CartDataDefault {
    static let standard = UserDefaults.standard
    typealias Key = AppKey
    
    static var cartBadge: Int {
        get {
            return getCarts().count
        }
    }
    
    static func saveCart(_ cart: Cart) {
        var carts: [Cart] = getCarts()
        if let index = carts.firstIndex(where: { $0.category?.id == cart.category?.id && $0.ticket?.id == cart.ticket?.id }) {
            let newCart = Cart(category: cart.category,
                               ticket: cart.ticket,
                               dateSelected: cart.dateSelected,
                               nationality: cart.nationality,
                               number: (carts[index].number ?? 0) + (cart.number ?? 0))
            carts[index] = newCart
        } else {
            carts.append(cart)
        }
        
        if let encoded = try? JSONEncoder().encode(carts) {
            UserDefaults.standard.set(encoded, forKey: Key.UserDefault.carts)
        }
    }
    
    static func getCarts() -> [Cart] {
        guard let cartsData = standard.object(forKey: Key.UserDefault.carts) as? Data,
              let carts = try? JSONDecoder().decode([Cart].self, from: cartsData) else { return [] }
        return carts
    }
    
    static func getCartSection() -> [CartData] {
        var cartSection: [CartData] = []
        CategoryDataDefault.getCategories().forEach { (category) in
            let carts = self.getCarts().filter({ $0.category?.id == category.id })
            if !carts.isEmpty {
                cartSection.append(CartData(title: category.name, carts: carts))
            }
        }
        return cartSection
    }
    
    static func updateCart(_ cart: Cart) {
        var carts: [Cart] = getCarts()
        if let index = carts.firstIndex(where: { $0.category?.id == cart.category?.id && $0.ticket?.id == cart.ticket?.id }) {
            carts[index] = cart
        }

        if let encoded = try? JSONEncoder().encode(carts) {
            UserDefaults.standard.set(encoded, forKey: Key.UserDefault.carts)
        }
    }
    
    static func removeCart(_ cart: Cart) {
        var carts: [Cart] = getCarts()
        if let index = carts.firstIndex(where: { $0.category?.id == cart.category?.id && $0.ticket?.id == cart.ticket?.id }) {
            carts.remove(at: index)
        }
        
        if let encoded = try? JSONEncoder().encode(carts) {
            UserDefaults.standard.set(encoded, forKey: Key.UserDefault.carts)
        }
    }
    
    static func removeAll() {
        UserDefaults.standard.set(nil, forKey: Key.UserDefault.carts)
    }
}

struct CategoryDataDefault {
    static let standard = UserDefaults.standard
    typealias Key = AppKey
    static func saveCategories(_ categories: [Category]) {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: Key.UserDefault.categories)
        }
    }
    
    static func getCategories() -> [Category] {
        guard let data = standard.object(forKey: Key.UserDefault.categories) as? Data,
              let categories = try? JSONDecoder().decode([Category].self, from: data) else { return [] }
        return categories
    }
}
