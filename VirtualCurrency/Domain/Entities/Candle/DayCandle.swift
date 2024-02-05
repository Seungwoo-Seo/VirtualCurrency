//
//  DayCandle.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

struct DayCandle: Hashable, Identifiable {
    let id = UUID()
    /// 마켓명
    let code: String
    /// 캔들 기준 시각(UTC 기준)
    /// 포맷: yyyy-MM-dd'T'HH:mm:ss
    let utcTime: String
    /// 캔들 기준 시각(KST 기준)
    /// 포맷: yyyy-MM-dd'T'HH:mm:ss
    let kstTime: String
    /// 시가
    var openPrice: Double
    /// 고가
    var highPrice: Double
    /// 저가
    var lowPrice: Double
    /// 종가
    var closePrice: Double
    /// 누적 거래량
    var tradeVolume: Double
    /// 해당 캔들에서 마지막 틱이 저장된 시각
    var timestamp: Int64

    var average5: Double?
    var average10: Double?
    var average20: Double?
    var average60: Double?
    var average120: Double?

    var tradeVolumeAverage5: Double?
    var tradeVolumeAverage10: Double?
    var tradeVolumeAverage20: Double?
}
