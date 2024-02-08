//
//  TradeInteractor.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Combine
import Foundation

protocol TradesUseCase {
    func execute(code: String, count: Int, cursor: CLong?) -> Future<[Trade], Error>
}

final class TradeInteractor: TradesUseCase {
    private let repository: TradeRepositoryProtocol

    init(repository: TradeRepository) {
        self.repository = repository
    }

    func execute(code: String, count: Int = 5, cursor: CLong? = nil) -> Future<[Trade], Error> {
        return Future { [weak self] (promixe) in
            guard let self else {return}
            let request = TradeRequest(market: code, to: nil, count: count, cursor: cursor, daysAgo: nil)
            Task {
                do {
                    let trades = try await self.repository.fetchTrades(request: request)
                    promixe(.success(trades))

                } catch {
                    promixe(.failure(error))
                }
            }
        }
    }
}
