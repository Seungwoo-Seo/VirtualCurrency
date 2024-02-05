//
//  CandleRepositoryProtocol.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

protocol CandleRepositoryProtocol {
    func fetchMinuteCandles(unit: Int, request: MinuteCandleRequest) async throws -> [MinuteCandle]
    func fetchDayCandles(request: DayCandleRequest) async throws -> [DayCandle]
}
