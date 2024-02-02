//
//  Ticker.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation
import SwiftUI

struct Ticker {
    /// 종목 구분 코드
    let code: String
    /// 시가
    let openPrice: Double
    /// 고가
    let highPrice: Double
    /// 저가
    let lowPrice: Double
    /// 종가(현재가)
    let currentPrice: Double
    /// 종목 가격 상태
    let priceState: PriceState
    /// 부호가 있는 변화율
    let changeRate: Double
    /// 가장 최근 거래량
    let tradeVolume: Double
    /// 부호가 있는 변화액
    let changeAmount: Double
    /// 24시간 누적 거래대금
    let transactionAmount24: Double

    /// 24시간 누적 거래량
    let tradeVolume24: Double
    /// 52주 최고가
    let highest52WeekPrice: Double
    /// 52주 최고가 달성일
    let highest52WeekDate: String
    /// 52주 최저가
    let lowest52WeekPrice: Double
    /// 52주 최저가 달성일
    let lowest52WeekDate: String
    /// 전일 종가
    let prevClosingPrice: Double
    /// 타임스탬프 (millisecond)
    let timestamp: Int64

    var color: Color {
        switch priceState {
        case .even: return .black
        case .rise: return .red
        case .fall: return .blue
        }
    }
}
