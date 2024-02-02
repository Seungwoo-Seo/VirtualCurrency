//
//  TickerDTO+Mapping.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation

/// 현재가
struct TickerDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case code = "market"
        case openPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case currentPrice = "trade_price"
        case priceState = "change"
        case changeRate = "signed_change_rate"
        case tradeVolume = "trade_volume"
        case changeAmount = "signed_change_price"
        case transactionAmount24 = "acc_trade_price_24h"

        case tradeVolume24 = "acc_trade_volume_24h"
        case highest52WeekPrice = "highest_52_week_price"
        case highest52WeekDate = "highest_52_week_date"
        case lowest52WeekPrice = "lowest_52_week_price"
        case lowest52WeekDate = "lowest_52_week_date"
        case prevClosingPrice = "prev_closing_price"
        case timestamp
    }
    /// 마켓 코드 (ex. KRW-BTC)
    let code: String?
    /// 시가
    let openPrice: Double?
    /// 고가
    let highPrice: Double?
    /// 저가
    let lowPrice: Double?
    /// 현재가
    let currentPrice: Double?
    /// 전일 대비
    let priceState: PriceState?
    /// 전일 대비 등락율
    let changeRate: Double?
    /// 가장 최근 거래량
    let tradeVolume: Double?
    /// 전일 대비 값
    let changeAmount: Double?
    /// 24시간 누적 거래대금
    let transactionAmount24: Double?

    /// 24시간 누적 거래량
    let tradeVolume24: Double?
    /// 52주 최고가
    let highest52WeekPrice: Double?
    /// 52주 최고가 달성일
    let highest52WeekDate: String?
    /// 52주 최저가
    let lowest52WeekPrice: Double?
    /// 52주 최저가 달성일
    let lowest52WeekDate: String?
    /// 전일 종가
    let prevClosingPrice: Double?
    /// 타임스탬프 (millisecond)
    let timestamp: Int64?
}

extension TickerDTO {
    func toDomain() -> Ticker {
        return Ticker(
            code: code ?? "코드없음",
            openPrice: openPrice ?? 0,
            highPrice: highPrice ?? 0,
            lowPrice: lowPrice ?? 0,
            currentPrice: currentPrice ?? 0,
            priceState: priceState ?? .even,
            changeRate: changeRate ?? 0,
            tradeVolume: tradeVolume ?? 0,
            changeAmount: changeAmount ?? 0,
            transactionAmount24: transactionAmount24 ?? 0,
            tradeVolume24: tradeVolume24 ?? 0,
            highest52WeekPrice: highest52WeekPrice ?? 0,
            highest52WeekDate: highest52WeekDate ?? "날짜없음",
            lowest52WeekPrice: lowest52WeekPrice ?? 0,
            lowest52WeekDate: lowest52WeekDate ?? "날짜없음",
            prevClosingPrice: prevClosingPrice ?? 0,
            timestamp: timestamp ?? 0
        )
    }
}

/// EVEN : 보합, RISE : 상승, FALL : 하락
enum PriceState: String, Decodable {
    case even = "EVEN"
    case rise = "RISE"
    case fall = "FALL"
}
