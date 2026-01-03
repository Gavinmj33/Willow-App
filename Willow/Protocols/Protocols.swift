//
//  Protocols.swift
//  Willow
//
//  Protocol abstractions following SOLID principles (Interface Segregation + Dependency Inversion).
//

import SwiftUI

// MARK: - Theme Providing

protocol ThemeProviding {
    var currentPeriod: Quote.TimePeriod { get }
    var currentTheme: Theme { get }
    func refreshTheme()
    func theme(for period: Quote.TimePeriod) -> Theme
}

// MARK: - Quote Providing

protocol QuoteProviding {
    func getCurrentPeriod() -> Quote.TimePeriod
    func getTodaysQuote(for period: Quote.TimePeriod) -> Quote?
}

// MARK: - Notification Scheduling

protocol NotificationScheduling {
    func requestPermission()
    func scheduleNotification(for period: NotificationManager.TimePeriod, at date: Date)
    func cancelNotification(for period: NotificationManager.TimePeriod)
}

// MARK: - Settings Storage

protocol SettingsStoring {
    func bool(forKey key: String) -> Bool
    func double(forKey key: String) -> Double
    func set(_ value: Bool, forKey key: String)
    func set(_ value: Double, forKey key: String)
}

// MARK: - Haptic Feedback

protocol HapticFeedbackProviding {
    func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType)
}

// MARK: - Time Providing

protocol TimeProviding {
    func currentHour() -> Int
}
