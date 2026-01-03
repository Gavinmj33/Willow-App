//
//  NotificationManager.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//

import Foundation
import UserNotifications

class NotificationManager: NotificationScheduling {
    static let shared = NotificationManager()
    
    enum TimePeriod: String, CaseIterable {
        case morning = "morning"
        case day = "day"
        case evening = "evening"
        case night = "night"
        
        var title: String {
            switch self {
            case .morning: return "Good Morning ☀️"
            case .day: return "Afternoon Pause🌤️"
            case .evening: return "Evening Thoughts 🌅"
            case .night: return "Nightly Reflection 🌙"
            }
        }
        
        var body: String {
            switch self {
            case .morning: return "Start your day with a positive mantra"
            case .day: return "Take a moment to pause and refocus"
            case .evening: return "Wind down with an evening affirmation"
            case .night: return "End your day with a peaceful reflection"
            }
        }
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for period: TimePeriod, at time: Date) {
        // Remove existing notification for this period
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [period.rawValue])
        
        // Create the content
        let content = UNMutableNotificationContent()
        content.title = period.title
        content.body = period.body
        content.sound = .default
        
        // Extract hour and minute from the chosen time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        // Create a daily trigger
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create and add the request
        let request = UNNotificationRequest(
            identifier: period.rawValue,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling \(period.rawValue) notification: \(error.localizedDescription)")
            } else {
                print("\(period.rawValue.capitalized) notification scheduled for \(hour):\(String(format: "%02d", minute))")
            }
        }
    }
    
    func cancelNotification(for period: TimePeriod) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [period.rawValue])
        print("\(period.rawValue.capitalized) notification cancelled")
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
