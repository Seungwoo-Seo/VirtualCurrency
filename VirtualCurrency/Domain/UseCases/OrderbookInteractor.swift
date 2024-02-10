//
//  OrderbookInteractor.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/10.
//

import Combine
import Foundation

protocol OrderbookUseCase {
    func execute(code: String) -> Future<Orderbook, Error>
}

final class OrderbookInteractor: OrderbookUseCase {
    private let repository: OrderbookRepository

    init(repository: OrderbookRepository) {
        self.repository = repository
    }

    func execute(code: String) -> Future<Orderbook, Error> {
        return Future { [weak self] (promixe) in
            guard let self else {return}

            let request = OrderbookRequest(markets: code, level: nil)

            Task {
                do {
                    let orderbooks = try await self.repository.fetchOrderbooks(request: request)
                    if let orderbook = orderbooks.first {
                        promixe(.success(orderbook))
                    }
                } catch {
                    promixe(.failure(error))
                }
            }
        }
    }

}
