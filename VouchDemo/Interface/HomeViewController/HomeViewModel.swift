//
//  HomeViewModel.swift
//  VouchDemo
//
//  Created by NguyenSeven on 16/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel, ViewModelType {
    func transform(input: Input) -> Output {
        let fecthCategory = input.viewWillAppear
            .flatMapLatest { return HomeUseCase().fetchCategories() }
            .share()
            
        let categories = fecthCategory.compactMap { try? $0.get() }
            .share()
            .asDriverOnErrorJustComplete()
        
        return Output(fetchCategorys: categories)
    }
}

extension HomeViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var fetchCategorys: Driver<CategoryData>
    }
}
