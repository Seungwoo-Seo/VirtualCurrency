//
//  VirtualCurrencyInteractor.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/03.
//

import Combine
import Foundation

protocol VirtualCurrencyUseCase {
    func execute() -> Future<[VirtualCurrency], Error>
}

/// 원화(KRW)로 매수/매도할 수 있는 가상화폐 가져오기
final class VirtualCurrencyInteractor: VirtualCurrencyUseCase {
    private let repository: VirtualCurrencyRepositoryProtocol

    init(repository: VirtualCurrencyRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Future<[VirtualCurrency], Error> {
        return Future { [weak self] (promixe) in
            guard let self else {return}

            Task {
                do {
                    let items = try await self.repository.getVirtualCurrencys()
                    promixe(.success(items))
                } catch {
                    promixe(.failure(error))
                }
            }
        }
    }
}
