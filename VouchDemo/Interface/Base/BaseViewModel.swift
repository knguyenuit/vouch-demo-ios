//
//  BaseViewModel.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class BaseViewModel: NSObject {

    var disposeBag: DisposeBag!

    public override init() {
        disposeBag = DisposeBag()
        super.init()
    }

    deinit {
        #if DEBUG
        print("\(String(describing: self)) deinit.")
        #endif
    }
}
