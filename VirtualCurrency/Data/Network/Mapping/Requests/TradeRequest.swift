//
//  TradeRequest.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/08.
//

import Foundation

struct TradeRequest {
    /// 마켓 코드 (ex. KRW-BTC)
    let market: String
    /// 마지막 체결 시각. 형식 : [HHmmss 또는 HH:mm:ss]. 비워서 요청시 가장 최근 데이터
    let to: String?
    /// 체결 개수
    let count: Int?
    /// 페이지네이션 커서 (sequentialId)
    let cursor: CLong?
    /// 최근 체결 날짜 기준 7일 이내의 이전 데이터 조회 가능. 비워서 요청 시 가장 최근 체결 날짜 반환. (범위: 1 ~ 7))
    let daysAgo: Int?
}

extension TradeRequest {
    func toQueryParameters() -> [String: Any] {
        var parameters: [String: Any] = ["market": market]

        if let to {
            parameters.updateValue(to, forKey: "to")
        }

        if let count {
            parameters.updateValue(count, forKey: "count")
        }

        if let cursor {
            parameters.updateValue(cursor, forKey: "cursor")
        }

        if let daysAgo {
            parameters.updateValue(daysAgo, forKey: "daysAgo")
        }

        return parameters
    }
}
