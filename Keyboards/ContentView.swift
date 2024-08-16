//
//  ContentView.swift
//  Keyboards
//
//  Created by Hoie Kim on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var profileText = ""
    @FocusState private var isTestAreaFocused: Bool

    var body: some View {
        Section {
            Text("Hoikey")
                .font(.system(size: 34, weight: .bold))
                .frame(alignment: Alignment.center)
                .padding(.top, 30.0)
                .padding(.bottom, 30.0)
            Text("Have you setup Hoikey yet?")
                .frame(alignment: Alignment.center)
                .padding(.bottom, 20.0)
            Text("Add a new keyboard in:")
                .font(.system(size: 14, weight: .light))
                .frame(alignment: Alignment.center)
                .padding(.bottom, 5.0)
            Text("Settings → General → Keyboard → Keyboards")
                .font(.system(size: 14, weight: .light))
                .frame(alignment: Alignment.center)
                .padding(.bottom, 20.0)
        }

        List {
            Section {
                Button(action: openSettings) {
                    Label("Open Settings", systemImage: "gearshape")
                        .labelStyle(.titleAndIcon)
                }
            }
            Section {
                Label("Test your keyboards here!", systemImage: "arrow.down")
                    .labelStyle(.titleAndIcon)
                TextEditor(text: $profileText)
                    .focused($isTestAreaFocused, equals: true)
                    .foregroundColor(.black)
            }
            .onAppear {
                isTestAreaFocused = true
            }
        }
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    ContentView()
}
