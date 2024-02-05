//
//  CandleDataSource.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

protocol CandleDataSourceProtocol {
    // fetch
    func fetchMinuteCandles(unit: Int, request: MinuteCandleRequest) async throws
    func fetchDayCandles(request: DayCandleRequest) async throws
    // get
    func getMinuteCandles() -> [MinuteCandleDTO]
    func getDayCandles() -> [DayCandleDTO]
}

final class CandleDataSource: CandleDataSourceProtocol {
    private var minuteCandles: [MinuteCandleDTO]
    private var dayCandles: [DayCandleDTO]

    private let httpManager: HTTPManager

    init(minuteCandles: [MinuteCandleDTO] = [], dayCandles: [DayCandleDTO] = [], httpManager: HTTPManager) {
        self.minuteCandles = minuteCandles
        self.dayCandles = dayCandles
        self.httpManager = httpManager
    }

    // MARK: - fetch

    func fetchMinuteCandles(unit: Int, request: MinuteCandleRequest) async throws {
        do {
            minuteCandles = try await httpManager.request(
                type: [MinuteCandleDTO].self,
                target: QuotationRouter.minuteCandle(unit, request)
            )
        } catch {
            throw error
        }
    }

    func fetchDayCandles(request: DayCandleRequest) async throws {
        do {
            dayCandles = try await httpManager.request(
                type: [DayCandleDTO].self,
                target: QuotationRouter.dayCandle(request)
            )
        } catch {
            throw error
        }
    }

    // MARK: - get

    func getMinuteCandles() -> [MinuteCandleDTO] {
        return minuteCandles
    }

    func getDayCandles() -> [DayCandleDTO] {
        return dayCandles
    }
}
