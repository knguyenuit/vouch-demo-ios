//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation
import Alamofire
import RxSwift

class APIClient: APIClientType {
    
    private var loading: FooLoadingType!
    
    func request<T: Codable>(_ router: APIRequestType) -> Observable<Result<T, NetworkError>> {
        let request = NetworkRequest(endPoint: AppConfig.mainDomain, router: router, token: AppUserDefault.userToken)
        return baseRequest(request)
    }
    
    func baseRequest<T: Codable>(_ request: NetworkRequest) -> Observable<Result<T, NetworkError>> {
        print("Request: \(request.urlRequest?.curlString ?? "")")
        loading = FooLoading()
        func handleLoadingState(isHidden: Bool) {
            loading.handleState(isHidden: isHidden)
        }
        handleLoadingState(isHidden: false)
        return Observable<Result<T, NetworkError>>.create { observer in
            let request = AF.request(request)
                .responseJSON { (response) in
                    let result: Result<T, NetworkError> = self.handleResponse(response: response)
                    switch result {
                    case .success(let value):
                        Swift.dump(value)
                        observer.onNext(.success(value))
                    case .failure(let error):
                        switch error {
                        case .unauthorized(description: _):
                            observer.onNext(.failure(error))
                        default:
                            observer.onNext(.failure(error))
                        }
                    }
                    handleLoadingState(isHidden: true)
                    observer.onCompleted()
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    private func handleResponse<T: Codable>(response: AFDataResponse<Any>) -> Result<T, NetworkError> {
        let decoder = JSONDecoder()
        
        func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T: Decodable {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return try decoder.decode(type, from: data)
        }
        
        switch response.result {
        case .success(let value):
            let json: [String: Any] = ["data": value]
            if let data = json["data"] as? [String: Any] {
                do {
                    let object: T = try decode(T.self, from: data)
                    return .success(object)
                } catch {
                    return .failure(NetworkError.parsing(description: error.localizedDescription))
                }
            } else if let arrayData = json["data"] as? [[String: Any]] {
                let data = ["data": arrayData]
                do {
                    let object: T = try decode(T.self, from: data)
                    return .success(object)
                } catch {
                    return .failure(NetworkError.parsing(description: error.localizedDescription))
                }
            }
            return .failure(NetworkError.invalidData)
        case .failure(let error):
            switch response.response?.statusCode {
            case 400:
                return .failure(NetworkError.wrongLogic(description: error.localizedDescription))
            case 401:
                return .failure(NetworkError.unauthorized(description: error.localizedDescription))
            case 403:
                return .failure(NetworkError.forbidden(description: error.localizedDescription))
            case 404:
                return .failure(NetworkError.notFound(description: error.localizedDescription))
            case 409:
                return .failure(NetworkError.conflict(description: error.localizedDescription))
            case 500:
                return .failure(NetworkError.internalServer(description: error.localizedDescription))
            case 501:
                return .failure(NetworkError.internalServer(description: error.localizedDescription))
            default:
                return .failure(NetworkError.unknow(description: error.localizedDescription))
            }
        }
    }
}
