//
//  TradeView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/09.
//

import SwiftUI

struct TradeView: View {
    @StateObject var viewModel: TradeViewModel

    init(viewModel: TradeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        contentView
            .navigationTitle("\(viewModel.virtualCurrency.name) \(viewModel.virtualCurrency.code)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .toolbarBackground(Color.init("AppColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear { viewModel.action(.contentViewOnAppear) }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .trade(let trades):
            List {
                Section {
                    ForEach(trades) { item in
                        TradeRow(trade: item)
                            .alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
                            .onAppear {
                                if item.id == trades.last?.id {
                                    viewModel.action(.pagination)
                                }
                            }
                    }
                } header: {
                    HStack {
                        Text("체결시간")
                            .frame(width: 90)
                        Divider()
                            .overlay(Color.gray)

                        Spacer()
                        Text("체결가격")
                        Spacer()

                        Divider()
                            .overlay(Color.gray)
                        Text("체결량")
                            .frame(width: 90)
                    }
                    .foregroundColor(Color.gray)
                }
                .listRowBackground(Color.init("AppColor"))
                .listRowSeparatorTint(Color.gray)
            }
            .background(Color.init("AppColor"))
            .listStyle(.plain)
            
        case .none:
            ProgressView()
        }
    }

}
