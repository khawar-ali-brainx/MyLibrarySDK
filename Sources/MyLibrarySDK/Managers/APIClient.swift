//
//  APIClient.swift
//  zytrack_ios
//
//  Created by BrainX Technologies on 3/1/21.
//

import Alamofire
import Foundation

protocol HTTPRequest {
    var endPoint: URL? { get }

    var method: HTTPMethod { get }

    var parameters: Parameters? { get }

    var headers: HTTPHeaders? { get }

    var multipartFormData: MultipartFormData? { get }
}

extension HTTPRequest {
    var parameters: Parameters? { nil }

    var headers: HTTPHeaders? { nil }

    var multipartFormData: MultipartFormData? { nil }
}

typealias APIClientResult = Result<Any, FeedbackError>

class APIClient {
    // MARK: - Class Instances

    static let shared = APIClient()

    // MARK: - Initializer

    private init() {}

    // MARK: - Public Methods

    func performMultipartFormDataRequest(_ request: HTTPRequest, withCompletion completion: @escaping (APIClientResult) -> Void) {
        guard let url = request.endPoint else {
            completion(.failure(FeedbackError(message: LocalizeKey.error.string)))
            return
        }
        guard let multipartFormData = request.multipartFormData else { return }
        AF.upload(multipartFormData: multipartFormData, to: url, method: request.method, headers: request.headers)
            .responseJSON { response in
                let headers = response.response?.allHeaderFields ?? [:]
                switch response.result {
                case let .success(value):
                    completion(.success((headers: headers, body: value)))
                case let .failure(error):
                    completion(.failure(FeedbackError(message: error.localizedDescription)))
                }
            }
    }
}
