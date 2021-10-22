//
//  HomeContentViewModel.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeContentViewModel: BaseViewModel, ViewModelType {
    private let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    func transform(input: Input) -> Output {
        let fetchTickets = input.viewWillAppear
            .flatMapLatest { return HomeUseCase().getTickets(with: self.category.id ?? 0) }
            .share()
        
        let getTickets = Observable.combineLatest(Observable.just(self.category), fetchTickets.compactMap { try? $0.get() })
            .map { return ($1, $0) }
            .share()
            .asDriverOnErrorJustComplete()
        
        return Output(getTickets: getTickets)
    }
}

extension HomeContentViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var getTickets: Driver<(TicketData, Category)>
    }
}
