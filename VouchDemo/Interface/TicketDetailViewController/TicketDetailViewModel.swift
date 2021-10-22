//
//  TicketDetailViewModel.swift
//  VouchDemo
//
//  Created by NguyenSeven on 18/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

class TicketDetailViewModel: BaseViewModel, ViewModelType {
    var ticket: Ticket
    var category: Category?
    
    init(ticket: Ticket, category: Category?) {
        self.ticket = ticket
        self.category = category
    }
    
    func transform(input: Input) -> Output {
        let fetchTicket = input.viewWillAppear
            .flatMapLatest { return TicketUseCase().getTicketDetail(with: self.ticket.id ?? 0) }
            .share()
        
        let getTicket = fetchTicket.compactMap { try? $0.get() }
            .share()
            .asDriverOnErrorJustComplete()
        
        return Output(getTicket: getTicket)
    }
}

extension TicketDetailViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var getTicket: Driver<Ticket>
    }
}
