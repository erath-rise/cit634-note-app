//
//  ContentView.swift
//  MyNote
//
//  Created by YINGLIAN DENG on 14/11/2025.
//

import SwiftUI

/// 主容器
struct ContentView: View {
    @StateObject private var viewModel = FormViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            FormView()
                .environmentObject(viewModel)
        }
        .environmentObject(viewModel)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
