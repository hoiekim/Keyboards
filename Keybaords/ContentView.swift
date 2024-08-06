//
//  ContentView.swift
//  Keybaords
//
//  Created by Hoie Kim on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isToggleOn = true

    var body: some View {
        NavigationSplitView {
            List {
                Toggle(isOn: $isToggleOn) {
                    Text("Testing toggle")
                }
            }
            .navigationTitle("Keyboards")

        } detail: {
            Text("Configuration")
        }
    }
}

#Preview {
    ContentView()
}
