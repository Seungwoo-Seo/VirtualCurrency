//
//  CandleInteractor.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Combine
import Foundation

/// 캔들 사용할 때
protocol CandleUseCase {
    /// 분(unit) 단위 캔들이 필요해~
    func fetchMinuteCandles(
        code: String,
        unit: Int,
        to: String?,
        count: Int?
    ) -> Future<[MinuteCandle], Error>

    /// 일 단위 캔들이 필요해~
    func fetchDayCandles(
        code: String,
        to: String?,
        count: Int?,
        convertingPriceUnit: String?
    ) -> Future<[DayCandle], Error>

    /// 주 단위 캔들이 필요해~
    func fetchWeekCandles() -> Future<[MinuteCandle], Error>

    /// 월 단위 캔들이 필요해~
    func fetchMonthCandles() -> Future<[MinuteCandle], Error>

    func calculateMovingAverage(data: [Double], windowSize: Int) -> [Double]
}

final class CandleInteractor: CandleUseCase {
    private let repository: CandleRepositoryProtocol

    init(repository: CandleRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - fetch

    func fetchMinuteCandles(
        code: String,
        unit: Int,
        to: String?,
        count: Int?
    ) -> Future<[MinuteCandle], Error> {
        Future { [weak self] (promixe) in
            guard let self else {return}

            Task {
                do {
                    let request = MinuteCandleRequest(market: code, to: to, count: count)
                    let items = try await self.repository.fetchMinuteCandles(unit: unit, request: request)
                    promixe(.success(items))

                } catch {
                    promixe(.failure(error))
                }
            }
        }
    }

    func fetchDayCandles(
        code: String,
        to: String?,
        count: Int?,
        convertingPriceUnit: String?
    ) -> Future<[DayCandle], Error> {
        Future { [weak self] promixe in
            guard let self else {return}

            Task {
                do {
                    let request = DayCandleRequest(market: code, to: to, count: count, convertingPriceUnit: convertingPriceUnit)
                    let items = try await self.repository.fetchDayCandles(request: request)
                    promixe(.success(items))
                } catch {
                    promixe(.failure(error))
                }
            }
        }
    }

    func fetchWeekCandles() -> Future<[MinuteCandle], Error> {
        Future { [weak self] promixe in
            guard let self else {return}
        }
    }

    func fetchMonthCandles() -> Future<[MinuteCandle], Error> {
        Future { [weak self] promixe in
            guard let self else {return}
        }
    }


//    1. 슬라이딩 윈도우 (Sliding Window) 기법 사용:
//    60일 간의 이동평균을 계산할 때 슬라이딩 윈도우 기법을 사용합니다. 이 기법은 윈도우를 이동시키면서 계산을 수행하여 시간복잡도를 줄입니다.

//    2. 순환 구조 (Iterative Approach) 사용:
//    순환 구조를 사용하여 60일 간의 데이터를 반복적으로 처리합니다. 이때, 새로운 데이터가 들어올 때마다 이전 데이터를 제거하고 새로운 데이터를 추가하여 이동평균을 업데이트합니다.

//    3. 동적 프로그래밍 (Dynamic Programming) 기법 사용:
//    동적 프로그래밍을 사용하여 중복 계산을 피하고 계산 속도를 향상시킵니다. 이를 통해 중간 결과를 저장하고 재활용함으로써 계산량을 줄일 수 있습니다.
    /// 이동평균선 구하는 메서드
    func calculateMovingAverage(data: [Double], windowSize: Int) -> [Double] {
        guard data.count >= windowSize else { return [] }

        var result: [Double] = []
        var windowSum = 0.0

        // 초기 윈도우의 합 구하기
        for i in 0..<windowSize {
            windowSum += data[i]
        }

        // 초기 이동평균 구하기
        result.append(windowSum / Double(windowSize))

        // 슬라이딩 윈도우 이동하면서 이동평균 계산
        for i in windowSize..<data.count {
            windowSum += data[i] - data[i - windowSize] // 새로운 값 추가, 이전 값 제거
            result.append(windowSum / Double(windowSize))
        }

        return result
    }

}
