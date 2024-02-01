//
//  HttpManager.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/01.
//

import Foundation
import Moya

extension NetworkError {
    enum HTTPError: Error {
        case invaildParsing
        case unknown(String)
    }
}

final class HTTPManager {
    static let shared = HTTPManager()

    private init() {}

    func request<D: Decodable, T: TargetType>(type: D.Type, target: T) async throws -> D {
        let provider = MoyaProvider<T>()

        let result = await provider.request(target)
        
        switch result {
        case .success(let response):
            do {
                let data = try response.map(type)
                return data
            } catch {
                throw NetworkError.HTTPError.invaildParsing
            }

        case .failure(let error):
            throw error
        }
    }

}

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self else {return}
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
