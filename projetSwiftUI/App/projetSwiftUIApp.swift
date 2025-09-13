//
//  projetSwiftUIApp.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-08.
//

import SwiftUI
import SwiftData
import FirebaseCore
//import Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
@main
struct projetSwiftUIApp: App {
    
    let container: ModelContainer = {
        let schema=Schema([UserLocation.self])
        let container=try! ModelContainer(for:schema,configurations: [])
        return container
    }()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ExpenseAppView()
                    .modelContainer(container)
            }
          
        }
    }
}
