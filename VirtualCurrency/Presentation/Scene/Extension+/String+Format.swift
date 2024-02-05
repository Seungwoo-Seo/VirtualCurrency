//
//  String+Format.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/05.
//

import Foundation

extension String {

    /// "문자열 날짜"를 년/월/일 문자열로 포맷하는 메서드
    func formatStringDateToYMDString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = formatter.date(from: self) else {
            return self
        }
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }

}
