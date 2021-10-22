//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeUseCaseType: AnyObject {
    func fetchHomeData() -> Observable<Result<HomeResponse, NetworkError>>
    func fetchCategories() -> Observable<Result<CategoryData, NetworkError>>
    func getTickets(with categoryId: Int) -> Observable<Result<TicketData, NetworkError>>
}

class HomeUseCase: HomeUseCaseType, ClientModule {
    func getTickets(with categoryId: Int) -> Observable<Result<TicketData, NetworkError>> {
        let tickets = APIRouter.getTickets(categoryId: categoryId)
        return apiClient.request(tickets)
    }
    
    func fetchCategories() -> Observable<Result<CategoryData, NetworkError>> {
        let categories = APIRouter.fetchCategories
        return apiClient.request(categories)
    }
    

    func fetchHomeData() -> Observable<Result<HomeResponse, NetworkError>> {
        let home = APIRouter.fetchHome
        return apiClient.request(home)
    }
}
