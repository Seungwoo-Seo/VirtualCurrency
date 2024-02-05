//
//  MinuteCandleRequest.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

struct MinuteCandleRequest {
    /// 마켓 코드 (ex. KRW-BTC)
    let market: String
    /// 마지막 캔들 시각 (exclusive).
    /// ISO8061 포맷 (yyyy-MM-dd'T'HH:mm:ss'Z' or yyyy-MM-dd HH:mm:ss). 기본적으로 UTC 기준 시간이며 2023-01-01T00:00:00+09:00 과 같이 KST 시간으로 요청 가능.
    /// 비워서 요청시 가장 최근 캔들
    let to: String?
    /// 캔들 개수(최대 200개까지 요청 가능)
    /// 비워서 요청할 시 1개
    let count: Int?
}

extension MinuteCandleRequest {
    func toQueryParameters() -> [String: Any] {
        var parameters: [String: Any] = ["market": market]

        if let to {
            parameters.updateValue(to, forKey: "to")
        }

        if let count {
            parameters.updateValue(count, forKey: "count")
        }

        return parameters
    }
}
