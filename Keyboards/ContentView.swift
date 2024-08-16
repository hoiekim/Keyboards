//
//  ContentView.swift
//  Keyboards
//
//  Created by Hoie Kim on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isToggleOn = true
    @State private var profileText = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Haven't setup Keyboards yet?")
                    Text("Settings → General → Keyboard → Keyboards → Add New Keyboard...")
                        .font(.system(size: 14, weight: .light))
                    Button(action: openSettings) {
                        Label("Open Settings", systemImage: "gearshape")
                            .labelStyle(.titleAndIcon)
                    }
                }
                Section {
                    Label("Test your keyboards here!", systemImage: "arrow.down")
                        .labelStyle(.titleAndIcon)
                    TextEditor(text: $profileText)
                        .foregroundColor(.black)
                }
            }
            .navigationTitle("Keyboards")
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
