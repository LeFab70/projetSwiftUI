//
//  ContentView.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI

struct ExpenseAppView: View {
    @State private var auth=AuthService.shared
    @Environment(NotificationManager.self) var notificationManager
    var body: some View {
       Group{
//           Text("Hello, World!")
           if let user = auth.user{
               HomeExpenseView(currentUser:user)
              
           }else{
               AuthGateView()
           }
        }
       .onAppear {
                   Task {
                       await notificationManager.requestPermission()
                       notificationManager.scheduleDailyReminder(hour: 9) // rappel tous les jours à 9h
                   }
               }
       .ignoresSafeArea(.all)
       .edgesIgnoringSafeArea(.all)
       .padding(.top, 20)
    }
}

#Preview("English") {
    ExpenseAppView().environment(NotificationManager())
}
#Preview("French") {
    ExpenseAppView().environment(NotificationManager())
        .environment(\.locale, Locale(identifier: "fr"))
}
