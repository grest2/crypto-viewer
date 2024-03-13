//
//  CryptoMonitorService.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Alamofire
import Foundation

// MARK: - ICryptoMonitorService
protocol ICryptoMonitorService {
    
    /// Get запрос
    func fetch<TResult>(url: String) async throws -> RequestResult<TResult> where TResult : Decodable
}

// MARK: - CryptoMonitorService
final class CryptoMonitorService: ICryptoMonitorService {
    
    // MARK: Public methods
    func fetch<TResult>(url: String) async throws -> RequestResult<TResult> where TResult : Decodable {
        try await buildRequest(url: url, method: .get, result: TResult.self).execute()
    }
    
    // MARK: Private methods
    private func buildRequest<TResult>(url: String,
                                      method: HTTPMethod,
                                      result: TResult.Type,
                                      headers: HTTPHeaders = .default) -> Request<TResult> where TResult : Decodable {
        Request<TResult>()
            .with(url: URL(string: url)!)
            .with(method: method)
            .with(headers: headers)
    }
}
