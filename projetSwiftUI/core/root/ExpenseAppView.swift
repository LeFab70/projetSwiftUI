//
//  ContentView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ExpenseAppView: View {
    @State private var auth=AuthService.shared
    var body: some View {
       Group{
           if let user = auth.user{
               HomeExpenseView(currentUser:user)
           }else{
               AuthGateView()
           }
        }
        .padding()
    }
}

#Preview {
    ExpenseAppView()
}
