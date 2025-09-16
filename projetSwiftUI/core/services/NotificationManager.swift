//
//  NotificationManager.swift
//  projetSwiftUI
//
//  Created by Fabrice Kouonang on 2025-09-15.
//

import Foundation
import UserNotifications
@Observable
class NotificationManager{
    static let shared = NotificationManager() // permet d'avoir un element goblal qui sera accessible partout
    func requestPermission() async{
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            print("Permission notification \(granted) \(granted ? "granted" : "denied")")
        } catch {
            print("Erreur de notification \(error)")
        }
    }
    //func sheduledNotification(title: String, body: String, date: Date)
    func sheduledNotification(){
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification_title") //title
        content.body = String(localized: "notification_body") //body
        content.sound = UNNotificationSound.default
        let trigger=UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request=UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
    func cancelAllNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removeNotification(identifier: String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["localNotification"])
    }
    
    
    func scheduleDailyReminder(hour: Int = 9, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "💡 Petit rappel"
        content.body = "Ouvre ton app pour suivre tes dépenses."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur ajout notif répétée: \(error)")
            }
        }
    }
}

