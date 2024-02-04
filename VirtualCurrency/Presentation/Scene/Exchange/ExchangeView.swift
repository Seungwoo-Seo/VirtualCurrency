//
//  ExchangeView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/02/04.
//

import SwiftUI

struct ExchangeView: View {
    @StateObject var viewModel: ExchangeViewModel

    init(viewModel: ExchangeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named: "AppColor")

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.backward")
    }

    var body: some View {
        contentView
            .onAppear { viewModel.action(.contentViewOnAppear) }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .virtualCurrencys(let items):
            NavigationStack {
                List {
                    marketSectionView
                    virtualCurrencySectionView(items)
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("거래소")
                .accentColor(Color.white)
                .foregroundColor(Color.white)
                .background(Color.init("AppColor"))
                .toolbarBackground(Color.init("AppColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            } // Navigation

        case .none:
            ProgressView()
        }
    }

    @ViewBuilder
    private var marketSectionView: some View {
        Section {
            HStack(spacing: 0) {
                Button("KRW") {}
                    .foregroundColor(Color.blue)
                    .padding(4)
                    .padding([.leading, .trailing], 8)
                    .border(Color.blue)

                Button("BTC") {}
                    .foregroundColor(Color.gray)
                    .padding(4)
                    .padding([.leading, .trailing], 8)
                    .border(Color.gray)

                Button("USDT") {}
                    .foregroundColor(Color.gray)
                    .padding(4)
                    .padding([.leading, .trailing], 8)
                    .border(Color.gray)
            }
            .listRowBackground(Color.init("AppColor"))
        }
    }

    @ViewBuilder
    private func virtualCurrencySectionView(_ items: [VirtualCurrency]) -> some View {
        Section {
            ForEach(items) { item in
                ZStack {
                    NavigationLink {
                        ChartView(viewModel: DIContainer.chartInject(virtualCurrency: item))
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                    ExchangeRow(virtualCurrency: item, diffItem: viewModel.diffItem)
                }
            }
            .listRowBackground(Color.init("AppColor"))
        } header: {
            HStack(alignment: .top) {
                Text("한글명")

                Spacer()

                Text("현재가")
                Text("전일대비")
                    .frame(width: 60, alignment: .trailing)
                Text("거래대금")
                    .frame(width: 70, alignment: .trailing)
            }
            .foregroundColor(Color.gray)
        }
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button{
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .aspectRatio(contentMode: .fit)
        }
    }

}
