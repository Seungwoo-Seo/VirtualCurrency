//
//  Market.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/02.
//

import Foundation

struct MarketDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case code = "market"
        case krName = "korean_name"
        case egName = "english_name"
    }
    let code: String?
    let krName: String?
    let egName: String?
}

extension MarketDTO {
    func toDomain() -> Market {
        return Market(
            market: code ?? "코드없음",
            krName: krName ?? "한글이름없음",
            egName: egName ?? "영문이름없음"
        )
    }
}
