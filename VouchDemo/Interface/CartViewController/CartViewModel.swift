//
//  CartViewModel.swift
//  VouchDemo
//
//  Created by NguyenSeven on 20/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

struct CartData {
    let title: String?
    let carts: [Cart]
    
    func getFee() -> Int {
        var fee: Int = 0
        for cart in carts {
            fee += (cart.number ?? 0) * (cart.ticket?.price ?? 0)
        }
        return fee
    }
}

class CartViewModel: BaseViewModel, ViewModelType {
    func transform(input: Input) -> Output {
        let fetchCarts = input.viewWillAppear
            .flatMapLatest { return Observable.just(CartDataDefault.getCartSection()) }
            .share()
            .asDriverOnErrorJustComplete()
        
        return Output(getCarts: fetchCarts)
    }
}

extension CartViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var getCarts: Driver<[CartData]>
    }
}
