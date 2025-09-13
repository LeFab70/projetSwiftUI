//
//  DarkModeView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-12.
//

import SwiftUI

struct DarkModeView: View {
    @State private var isDarkModeEnabled: Bool = false
    var body: some View {
        VStack {
            Toggle(isDarkModeEnabled ? "Mode Sombre Activé 🌙" : "Mode Clair ☀️", isOn: $isDarkModeEnabled)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
        } .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
      
    }
       
}

#Preview {
    DarkModeView()
}
