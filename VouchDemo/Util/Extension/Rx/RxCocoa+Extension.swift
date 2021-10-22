//
//  RxCocoa+Extension.swift
//  FooBot-iOS
//
//  Created by NguyenSeven on 12/10/2021.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

}

extension ObservableType {
    func resultError<T>(ofType: T.Type) -> Observable<NetworkError?> {
        return map { element -> NetworkError? in
            guard let result = element as? Result<T, NetworkError> else {
                return nil
            }
            switch result {
            case .success:
                return nil
            case .failure(let error):
                return error
            }
        }
    }
}

extension UITextField {
    public func observable() -> Observable<String> {
        return rx.text.orEmpty.asObservable()
    }
    
    public func value() -> Observable<String> {
        let text = rx.observe(String.self, "text").map({ $0 ?? "" })
      return Observable.merge(observable(), text).distinctUntilChanged()
    }
}

extension UIButton {
    public func observable() -> Observable<Void> {
        return rx.tap.asObservable()
    }
}

extension UITextView {
    public func observable() -> Observable<String> {
        return rx.text.orEmpty.asObservable()
    }

    public func value() -> Observable<String> {
        let text = rx.observe(String.self, "text").map({ $0 ?? "" })
      return Observable.merge(observable(), text).distinctUntilChanged()
    }
}
