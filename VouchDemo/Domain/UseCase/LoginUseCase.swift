//
//  Created by NguyenSeven on 14/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginUseCaseType: AnyObject {
    func doLogin(request: LoginRequest) -> Observable<Result<LoginResponse, NetworkError>>
}

class LoginUseCase: LoginUseCaseType, ClientModule {

    func doLogin(request: LoginRequest) -> Observable<Result<LoginResponse, NetworkError>> {
        let home = APIRouter.login(phone: request.phone, password: request.password)
        return apiClient.request(home)
    }
}

