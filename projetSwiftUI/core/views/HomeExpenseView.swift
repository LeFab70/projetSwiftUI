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

    var body: some View {
        NavigationStack {
            VStack {
                welcomeUser
                
                TabView(selection: $selectedTab) {
                    
                    ListExpenseView()
                        .tabItem {
                            
                            Label("Expenses", systemImage: "list.bullet")
                        }
                        .tag(0)
                        .badge(10)
                    
                   EmptyView()
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                        .tag(1)
                    
                  EmptyView()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(2)
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
            .padding()
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
