//
//  CandleRepository.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

final class CandleRepository: CandleRepositoryProtocol {
    private let candleDataSource: CandleDataSourceProtocol

    init(candleDataSource: CandleDataSourceProtocol) {
        self.candleDataSource = candleDataSource
    }

    // MARK: - fetch

    func fetchMinuteCandles(unit: Int, request: MinuteCandleRequest) async throws -> [MinuteCandle] {
        do {
            try await candleDataSource.fetchMinuteCandles(unit: unit, request: request)
        } catch {
            throw error
        }

        let minuteDTOs = candleDataSource.getMinuteCandles()
        let domains = minuteDTOs.map { $0.toDomain() }

        return domains
    }

    func fetchDayCandles(request: DayCandleRequest) async throws -> [DayCandle] {
        do {
            try await candleDataSource.fetchDayCandles(request: request)
        } catch {
            throw error
        }

        let dayDTOs = candleDataSource.getDayCandles()
        let domains = dayDTOs.map { $0.toDomain() }

        return domains
    }

}
