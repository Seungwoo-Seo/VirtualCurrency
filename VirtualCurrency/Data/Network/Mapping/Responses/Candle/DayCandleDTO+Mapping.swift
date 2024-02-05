//
//  DayCandleDTO+Mapping.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//
import Foundation

struct DayCandleDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case code = "market"
        case utcTime = "candle_date_time_utc"
        case kstTime = "candle_date_time_kst"
        case openPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case closePrice = "trade_price"
        case tradeVolume = "candle_acc_trade_volume"
        case timestamp
    }
    /// 마켓명
    let code: String?
    /// 캔들 기준 시각(UTC 기준)
    /// 포맷: yyyy-MM-dd'T'HH:mm:ss
    let utcTime: String?
    /// 캔들 기준 시각(KST 기준)
    /// 포맷: yyyy-MM-dd'T'HH:mm:ss
    let kstTime: String?
    /// 시가
    let openPrice: Double?
    /// 고가
    let highPrice: Double?
    /// 저가
    let lowPrice: Double?
    /// 종가
    let closePrice: Double?
    /// 누적 거래량
    let tradeVolume: Double?
    /// 해당 캔들에서 마지막 틱이 저장된 시각
    let timestamp: Int64?
}

extension DayCandleDTO {
    func toDomain() -> DayCandle {
        return DayCandle(
            code: code ?? "코드없음",
            utcTime: utcTime ?? "UTC 시간 없음",
            kstTime: kstTime ?? "KST 시간 없음",
            openPrice: openPrice ?? 0,
            highPrice: highPrice ?? 0,
            lowPrice: lowPrice ?? 0,
            closePrice: closePrice ?? 0,
            tradeVolume: tradeVolume ?? 0,
            timestamp: timestamp ?? 0
        )
    }
}
