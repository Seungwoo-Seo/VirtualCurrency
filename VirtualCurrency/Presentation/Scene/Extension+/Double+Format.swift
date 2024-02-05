//
//  Double+Format.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

extension Double {

    /// 자동
    var formatToString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        let integerPart = Int(self)
        let decimalPart = self - Double(integerPart)

        if integerPart <= 0 && decimalPart > 0 {
            // 정수 자리가 0이고 소숫점만 있는 경우 소숫점 자릿수를 그대로 보여줌
            return String(format: "%.\(String(decimalPart).count - 2)f", self)
        } else if decimalPart == 0 {
            // 소수점이 없을 경우 정수처럼 보여줌
            return formatter.string(from: NSNumber(value: integerPart)) ?? ""
        } else {
            // 소수점이 있을 경우 최대 소숫점 자릿수까지 보여줌
            let formattedIntegerPart = formatter.string(from: NSNumber(value: integerPart)) ?? ""
            return "\(formattedIntegerPart).\(String(format: "%.1f", decimalPart).suffix(1))"
        }
    }

    /// 소숫점 자리수를 파라미터로 전달받는 메서드
    func toString(seat: Int) -> String {
        return String(format: "%.\(seat)f", self)
    }

    var multiplyBy100AndAddPercentage: String {
        let result = String(format: "%.2f", self * 100.0)
        return "\(result)%"
    }

    /// 백만 단위로 표시
    var convertToMillionFormat: String {
        let millionValue = Int(self / 1_000_000.0)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter.string(from: NSNumber(value: millionValue))?.appending("백만") ?? ""
    }
}
