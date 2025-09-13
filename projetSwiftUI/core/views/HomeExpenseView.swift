//
//  HomeExpenseView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI
import FirebaseAuth

struct HomeExpenseView: View {
    let currentUser: FirebaseAuth.User?
    @State private var auth = AuthService.shared
    @State private var selectedTab = 0
    @State private var isLoggedOut = false
    @State var expenseService = ExpenseDataBaseService.shared

    var body: some View {
        NavigationStack {
            VStack {
                welcomeUser
                
                TabView(selection: $selectedTab) {
                    
                    
                    
                    Tab("Expenses",systemImage: "list.bullet", value: 0){
                        ListExpenseView()
                    }
                    .badge(ExpenseDataBaseService.shared.expenses.count)
                        
                    
                    Tab("Ranking",systemImage: "list.bullet", value: 1){
                        RankingView()
                        ChartViewRanking()
                    }
                    .badge(expenseService.ranking.count)
                        
                    Tab("Settings",systemImage: "gear", value: 2){
                        SettingsView()
                    }
                    
                    Tab("Météo", systemImage: "cloud.sun", value: 3) {
                        LocationInputView()
                    }

                   
                   
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                toolBarItemLogOut
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                LoginView()
            }
        }
    }
    
    @ViewBuilder
    var welcomeUser: some View {
        Text(currentUser?.email != nil
             ? "Welcome \(currentUser?.email ?? "")"
             : "wecolme !")
            .font(.headline)
           
    }
    
  
    var toolBarItemLogOut: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                Task {
                    try? await auth.logout()
                    isLoggedOut = true
                }
            }) {
                Image(systemName: "power.circle.fill")
                    .foregroundStyle(.green.opacity(0.8))
                    .font(.system(size: 28))
            }
        }
    }
}


#Preview {
    HomeExpenseView(currentUser: nil)
}
