//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation
import Alamofire
import RxSwift

protocol APIClientType {
    func request<T: Codable>(_ router: APIRequestType) -> Observable<Result<T, NetworkError>>
}

protocol APIRequestType {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

enum NetworkError: Error {
    case dicconnect
    case parsing(description: String)
    case network(description: String)
    case unauthorized(description: String)
    case forbidden(description: String)
    case notFound(description: String)
    case conflict(description: String)
    case wrongLogic(description: String)
    case internalServer(description: String)
    case badRequest
    case unknow(description: String)
    case invalidData
    case memberHasExpired
}

struct NetworkRequest: URLConvertible, URLRequestConvertible {

    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }

    enum ContentType: String {
        case json = "application/json"
        case urlencoded = "application/x-www-form-urlencoded"
    }

    private let endPoint: String
    private let token: String?

    let router: APIRequestType
    var headers: HTTPHeaders {
        if let token = token {
            return [
                HttpHeaderField.contentType.rawValue: ContentType.urlencoded.rawValue,
                HttpHeaderField.authentication.rawValue: "Bearer \(token)"
            ]
        }
        return [:]
    }

    init(endPoint: String, router: APIRequestType, token: String?) {
        self.endPoint = endPoint
        self.router = router
        self.token = token
    }

    func asURLRequest() throws -> URLRequest {
        let url = try endPoint.asURL()
            .appendingPathComponent(router.path)
            .absoluteString.removingPercentEncoding ?? "Error: url format is invalid"

        var urlRequest = URLRequest(url: try url.asURL())

        urlRequest.httpMethod = router.method.rawValue
        if let token = self.token {
            urlRequest.setValue("Bearer \(token)",
                                forHTTPHeaderField: HttpHeaderField.authentication.rawValue)
        }

        switch router.method {
        case .post, .put:
            urlRequest.setValue(ContentType.json.rawValue,
                                forHTTPHeaderField: HttpHeaderField.acceptType.rawValue)
            urlRequest.setValue(ContentType.json.rawValue,
                                forHTTPHeaderField: HttpHeaderField.contentType.rawValue)
        default: break
        }

        let encoding: ParameterEncoding = {
            switch router.method {

            case .post, .put:
                return JSONEncoding.default
            default:
                return URLEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: router.parameters)
    }

    func asURL() throws -> URL {
        return try endPoint.asURL().appendingPathComponent(router.path)
    }
}

class POODecoder {

    private let decoder = JSONDecoder()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        get { return decoder.dateDecodingStrategy }
        set { decoder.dateDecodingStrategy = newValue }
    }

    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        get { return decoder.dataDecodingStrategy }
        set { decoder.dataDecodingStrategy = newValue }
    }

    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        get { return decoder.nonConformingFloatDecodingStrategy }
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        get { return decoder.keyDecodingStrategy }
        set { decoder.keyDecodingStrategy = newValue }
    }

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}


extension NetworkError: LocalizedError {
    public var description: String {
        switch self {
        case .dicconnect:
            return "disconnect"
        case .parsing(let description):
            return description
        case .network(let description):
            return description
        case .unauthorized(let description):
            return description
        case .forbidden(let description):
            return description
        case .notFound(let description):
            return description
        case .conflict(let description):
            return description
        case .wrongLogic(let description):
            return description
        case .internalServer(let description):
            return description
        case .badRequest:
            return "Bad request"
        case .unknow(let description):
            return description
        case .invalidData:
            return "Invalid data"
        case .memberHasExpired:
            return "Token has expired"
        }
    }
}
