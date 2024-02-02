//
//  TickerDataSource.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation

protocol TickerDataSourceProtocol {
    func fetchTickers(request: TickerRequest) async throws
    func getTickers() -> [TickerDTO]
}

final class TickerDataSource: TickerDataSourceProtocol {
    private var tickers: [TickerDTO] = []

    private let httpManager: HTTPManager

    init(tickers: [TickerDTO] = [], httpManager: HTTPManager) {
        self.tickers = tickers
        self.httpManager = httpManager
    }

    // MARK: - fetch

    func fetchTickers(request: TickerRequest) async throws {
        do {
            tickers = try await HTTPManager.shared.request(
                type: [TickerDTO].self,
                target: QuotationRouter.ticker(request)
            )
        } catch {
            // 여기서 잡히는 에러는 request 메서드에서 넘겨받은 에러 뿐이니까
            // 그대로 토스
            throw error
        }
    }

    // MARK: - get

    func getTickers() -> [TickerDTO] {
        return tickers
    }
}
