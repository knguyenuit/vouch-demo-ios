//
//  TicketUseCase.swift
//  VouchDemo
//
//  Created by NguyenSeven on 19/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol TicketUseCaseType: AnyObject {
    func getTicketDetail(with ticketId: Int) -> Observable<Result<Ticket, NetworkError>>
}

class TicketUseCase: TicketUseCaseType, ClientModule {
    func getTicketDetail(with ticketId: Int) -> Observable<Result<Ticket, NetworkError>> {
        let ticket = APIRouter.getTicketDetail(ticketId: ticketId)
        return apiClient.request(ticket)
    }
}
