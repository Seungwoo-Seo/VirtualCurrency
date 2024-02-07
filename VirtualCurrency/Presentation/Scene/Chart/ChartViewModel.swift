//
//  ChartViewModel.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/07.
//

import Combine
import Foundation

final class ChartViewModel: ViewModelable {
    enum Action {
        // View
        case contentViewOnAppear
        case candlePagination
        // ViewModel
        case httpTrigger
    }

    enum State {
        case dayCandles([DayCandle])
        case error(String)
        case none
    }

    @Published var state: State

    private var cancellable = Set<AnyCancellable>()

    // MARK: - UseCase
    private let candleInteractor: CandleUseCase
    private var realtimeTickerInteractor: WebSocketUseCase?

    // 초기값
    private var dayCandles: [DayCandle] = []

    var virtualCurrency: VirtualCurrency

    init(virtualCurrency: VirtualCurrency, candleUseCase: CandleUseCase, realtimeTickerInteractor: WebSocketUseCase?) {
        self.state = .none
        self.virtualCurrency = virtualCurrency
        self.candleInteractor = candleUseCase
        self.realtimeTickerInteractor = realtimeTickerInteractor
    }

    func action(_ action: Action) {
        switch action {
        case .contentViewOnAppear:
            candleInteractor.fetchDayCandles(
                code: virtualCurrency.code,
                to: nil,
                count: 20,
                convertingPriceUnit: nil
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (items) in
                guard let self else {return}
                self.dayCandles = items
                self.updateState()
                self.realtimeTickerInteractor?.execute(type: .ticker, codes: [self.virtualCurrency.code])
            }
            .store(in: &cancellable)

            // 실시간 현재가
            realtimeTickerInteractor?.realtimeDataSbj
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [weak self] (data) in
                    guard let self else {return}

                    do {
                        let realtimeTickerDTO = try JSONDecoder().decode(RealtimeTickerDTO.self, from: data)
                        let ticker = realtimeTickerDTO.toDomain()

                        if let first = self.dayCandles.first?.timestamp {
                            if self.isSameDay(firstMillis: first, secondMillis: ticker.timestamp) {
                                self.dayCandles[0].openPrice = ticker.openPrice
                                self.dayCandles[0].closePrice = ticker.currentPrice
                                self.dayCandles[0].highPrice = ticker.highPrice
                                self.dayCandles[0].lowPrice = ticker.lowPrice
                                self.dayCandles[0].timestamp = ticker.timestamp
                                print("👋👋👋👋👋")

                            } else {
                                self.action(.httpTrigger)
                            }

                            print("1", self.dayCandles.count)
                            self.updateState()
                            print("2", self.dayCandles.count)
                        }
                    } catch {
                        print("❌")
                    }
                }
                .store(in: &cancellable)


        case .candlePagination:
            candleInteractor.fetchDayCandles(
                code: virtualCurrency.code,
                to: dayCandles.last?.utcTime,
                count: 20,
                convertingPriceUnit: nil
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (items) in
                guard let self else {return}
                self.dayCandles += items
                self.updateState()
            }
            .store(in: &cancellable)

        case .httpTrigger:
            candleInteractor.fetchDayCandles(
                code: virtualCurrency.code,
                to: nil,
                count: 1,
                convertingPriceUnit: nil
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] (items) in
                guard let self else {return}
                self.dayCandles.insert(items[0], at: 0)
                self.updateState()
            }
            .store(in: &cancellable)
        }
    }

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

    func updateAverages(data: [Double], windowSize: Int)  {
        let averages = calculateMovingAverage(data: data, windowSize: windowSize)
        for (index, average) in averages.enumerated() {
            if windowSize == 5 {
                dayCandles[index].average5 = average
            } else if windowSize == 10 {
                dayCandles[index].average10 = average
            } else if windowSize == 20 {
                dayCandles[index].average20 = average
            } else if windowSize == 60 {
                dayCandles[index].average60 = average
            } else if windowSize == 120 {
                dayCandles[index].average120 = average
            }
        }
    }

    func updateTradeVolumeMovingAverage(data: [Double], windowSize: Int)  {
        let averages = calculateMovingAverage(data: data, windowSize: windowSize)
        for (index, average) in averages.enumerated() {
            if windowSize == 5 {
                dayCandles[index].tradeVolumeAverage5 = average
            } else if windowSize == 10 {
                dayCandles[index].tradeVolumeAverage10 = average
            } else if windowSize == 20 {
                dayCandles[index].tradeVolumeAverage20 = average
            }
        }
    }

    func updateState() {
        let closePrices = dayCandles.map { $0.closePrice }
        [5, 10, 20, 60, 120].forEach { updateAverages(data: closePrices, windowSize: $0) }

        let tradeVolumes = dayCandles.map { $0.tradeVolume }
        [5, 10, 20].forEach { updateTradeVolumeMovingAverage(data: tradeVolumes, windowSize: $0) }

        self.state = .dayCandles(dayCandles)
    }

    // 두 개의 밀리초가 초를 제외하고 년, 월, 일이 동일한지 판별하는 메서드. 즉, 일(Day) 단위
    func isSameDay(firstMillis: Int64, secondMillis: Int64) -> Bool {
        let firstDate = Date(timeIntervalSince1970: TimeInterval(firstMillis / 1000))
        let secondDate = Date(timeIntervalSince1970: TimeInterval(secondMillis / 1000))

        let calendar = Calendar.current
        let firstComponents = calendar.dateComponents([.year, .month, .day], from: firstDate)
        let secondComponents = calendar.dateComponents([.year, .month, .day], from: secondDate)

        return firstComponents == secondComponents
    }

    // 최고값(highPrice)과 최소값(lowPrice)을 찾는 메서드
    func findMinMaxPrices() -> [Double] {
        guard let firstCandle = dayCandles.first else {
            return [0, 0]
        }

        // 초기값으로 첫 번째 캔들의 highPrice와 lowPrice를 설정
        var maxHighPrice = firstCandle.highPrice
        var minLowPrice = firstCandle.lowPrice

        // 배열을 순회하면서 최대값과 최소값을 갱신
        for candle in dayCandles {
            maxHighPrice = max(maxHighPrice, candle.highPrice)
            minLowPrice = min(minLowPrice, candle.lowPrice)
        }

        return [minLowPrice, maxHighPrice]
    }

    // 최고 거래량과 최소 거래량을 찾는 메서드
    func findMinMaxTradeVolume() -> [Double] {
        guard let firstCandle = dayCandles.first else {
            return [0, 0]
        }

        // 초기값으로 첫 번째 캔들의 maxTradeVolume와 minTradeVolume를 설정
        var maxTradeVolume = firstCandle.tradeVolume
        var minTradeVolume = firstCandle.tradeVolume

        // 배열을 순회하면서 최대값과 최소값을 갱신
        for candle in dayCandles {
            maxTradeVolume = max(maxTradeVolume, candle.tradeVolume)
            minTradeVolume = min(minTradeVolume, candle.tradeVolume)
        }

        return [minTradeVolume, maxTradeVolume]
    }


}
