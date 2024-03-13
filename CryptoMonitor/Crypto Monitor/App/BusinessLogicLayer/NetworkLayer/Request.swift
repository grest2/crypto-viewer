//
//  Request.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Alamofire
import Foundation

typealias RequestResult<TSuccess> = Result<TSuccess, Error>

protocol IRequstBuilder {
    
    associatedtype TResult
    
    func with(url: URLConvertible) -> Self
    
    func with(method: HTTPMethod) -> Self
    
    func with(headers: HTTPHeaders) -> Self
    
    func execute() async throws -> RequestResult<TResult>
}

class Request<TResult>: IRequstBuilder where TResult: Decodable {
    
    // MARK: - Private props
    private var session: Session = Session.default
    
    private var url: URLConvertible?
    
    private var method: HTTPMethod?
    
    private var headers: HTTPHeaders?
    
    // MARK: Public methods
    func with(url: Alamofire.URLConvertible) -> Self {
        self.url = url
        return self
    }
    
    func with(method: Alamofire.HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    func with(headers: Alamofire.HTTPHeaders) -> Self {
        self.headers = headers
        return self
    }
    
    func execute() async throws -> RequestResult<TResult> {
        guard let url, let method 
        else { throw BussinessLogicErrors.incorrectRequestBuilding }
        
        let request = try await buildRequest(url: url, method: method)
        
        if let data = request.data {
            let result = try JSONDecoder().decode(TResult.self, from: data)
            return .success(result)
        } else {
            let code = request.response?.statusCode ?? -1
            return .failure(BussinessLogicErrors.requestError(code: code))
        }
    }
    
    private func buildRequest(url: URLConvertible, method: HTTPMethod) async throws -> AFDataResponse<Data> {
        return try await withCheckedThrowingContinuation { [self] continuation in
            session.request(url, method: method, headers: headers).responseData { responseData in
                if let response = responseData.response {
                    continuation.resume(with: .success(responseData))
                } else {
                    let code = responseData.response?.statusCode ?? -1
                    continuation.resume(with: .failure(BussinessLogicErrors.requestError(code: code)))
                }
            }
        }
    }
}
