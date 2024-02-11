//
//  ContentView.swift
//  VirtualCurrency
//
//  Created by 서승우 on 2024/01/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ExchangeView(viewModel: DIContainer.exChangeInject())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
