//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation
import Alamofire

enum APIRouter: APIRequestType {
    struct ParameterKey {
        static let phone = "phone"
        static let password = "password"
        static let loginPlatform = "loginPlatform"
    }

    case fetchHome
    case login(phone: String, password: String)
    case fetchCategories
    case getTickets(categoryId: Int)
    case getTicketDetail(ticketId: Int)

    // MARK: - HttpMethod
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .login(let phone, let password):
            return "login?phone=\(phone)&password=\(password)&loginPlatform=iOS)"
        case .fetchHome:
            return "api/v1/tickets"
        case .fetchCategories:
            return "json-mock/ticketing/categories"
        case .getTickets(let categoryId):
            return "json-mock/ticketing/categories/\(categoryId)"
        case .getTicketDetail(let ticketId):
            return "json-mock/ticketing/tickets/\(ticketId)"
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
}
