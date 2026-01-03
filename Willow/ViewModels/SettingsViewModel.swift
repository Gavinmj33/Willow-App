//
//  SettingsViewModel.swift
//  Willow
//
//  ViewModel for settings/notifications functionality following MVVM principles.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties (Notification Toggles)

    @Published var morningEnabled: Bool {
        didSet {
            UserDefaults.standard.set(morningEnabled, forKey: "morningEnabled")
            handleToggle(enabled: morningEnabled, period: .morning, time: morningTimeStored)
        }
    }

    @Published var dayEnabled: Bool {
        didSet {
            UserDefaults.standard.set(dayEnabled, forKey: "dayEnabled")
            handleToggle(enabled: dayEnabled, period: .day, time: dayTimeStored)
        }
    }

    @Published var eveningEnabled: Bool {
        didSet {
            UserDefaults.standard.set(eveningEnabled, forKey: "eveningEnabled")
            handleToggle(enabled: eveningEnabled, period: .evening, time: eveningTimeStored)
        }
    }

    @Published var nightEnabled: Bool {
        didSet {
            UserDefaults.standard.set(nightEnabled, forKey: "nightEnabled")
            handleToggle(enabled: nightEnabled, period: .night, time: nightTimeStored)
        }
    }

    // MARK: - Published Properties (Notification Times)

    @Published var morningTimeStored: Double {
        didSet {
            UserDefaults.standard.set(morningTimeStored, forKey: "morningTime")
            if morningEnabled {
                scheduleNotification(for: .morning, at: morningTimeStored)
            }
        }
    }

    @Published var dayTimeStored: Double {
        didSet {
            UserDefaults.standard.set(dayTimeStored, forKey: "dayTime")
            if dayEnabled {
                scheduleNotification(for: .day, at: dayTimeStored)
            }
        }
    }

    @Published var eveningTimeStored: Double {
        didSet {
            UserDefaults.standard.set(eveningTimeStored, forKey: "eveningTime")
            if eveningEnabled {
                scheduleNotification(for: .evening, at: eveningTimeStored)
            }
        }
    }

    @Published var nightTimeStored: Double {
        didSet {
            UserDefaults.standard.set(nightTimeStored, forKey: "nightTime")
            if nightEnabled {
                scheduleNotification(for: .night, at: nightTimeStored)
            }
        }
    }

    // MARK: - Time Ranges

    var morningRange: ClosedRange<Date> {
        timeRange(startHour: 6, startMinute: 0, endHour: 11, endMinute: 59)
    }

    var dayRange: ClosedRange<Date> {
        timeRange(startHour: 12, startMinute: 0, endHour: 16, endMinute: 59)
    }

    var eveningRange: ClosedRange<Date> {
        timeRange(startHour: 17, startMinute: 0, endHour: 20, endMinute: 59)
    }

    var nightRange: ClosedRange<Date> {
        timeRange(startHour: 21, startMinute: 0, endHour: 23, endMinute: 59)
    }

    // MARK: - Private Properties

    private let notificationManager: NotificationManager

    // MARK: - Initialization

    init(notificationManager: NotificationManager = .shared) {
        self.notificationManager = notificationManager

        // Load stored values
        self.morningEnabled = UserDefaults.standard.bool(forKey: "morningEnabled")
        self.dayEnabled = UserDefaults.standard.bool(forKey: "dayEnabled")
        self.eveningEnabled = UserDefaults.standard.bool(forKey: "eveningEnabled")
        self.nightEnabled = UserDefaults.standard.bool(forKey: "nightEnabled")

        self.morningTimeStored = UserDefaults.standard.double(forKey: "morningTime").nonZeroOr(Self.defaultTime(hour: 7, minute: 0))
        self.dayTimeStored = UserDefaults.standard.double(forKey: "dayTime").nonZeroOr(Self.defaultTime(hour: 12, minute: 0))
        self.eveningTimeStored = UserDefaults.standard.double(forKey: "eveningTime").nonZeroOr(Self.defaultTime(hour: 18, minute: 0))
        self.nightTimeStored = UserDefaults.standard.double(forKey: "nightTime").nonZeroOr(Self.defaultTime(hour: 21, minute: 0))
    }

    // MARK: - Public Methods

    func morningTimeBinding(clampedTo range: ClosedRange<Date>) -> Binding<Date> {
        createTimeBinding(for: \.morningTimeStored, clampedTo: range)
    }

    func dayTimeBinding(clampedTo range: ClosedRange<Date>) -> Binding<Date> {
        createTimeBinding(for: \.dayTimeStored, clampedTo: range)
    }

    func eveningTimeBinding(clampedTo range: ClosedRange<Date>) -> Binding<Date> {
        createTimeBinding(for: \.eveningTimeStored, clampedTo: range)
    }

    func nightTimeBinding(clampedTo range: ClosedRange<Date>) -> Binding<Date> {
        createTimeBinding(for: \.nightTimeStored, clampedTo: range)
    }

    // MARK: - Private Methods

    private func handleToggle(enabled: Bool, period: NotificationManager.TimePeriod, time: Double) {
        if enabled {
            notificationManager.requestPermission()
            notificationManager.scheduleNotification(for: period, at: Date(timeIntervalSince1970: time))
        } else {
            notificationManager.cancelNotification(for: period)
        }
    }

    private func scheduleNotification(for period: NotificationManager.TimePeriod, at time: Double) {
        notificationManager.scheduleNotification(for: period, at: Date(timeIntervalSince1970: time))
    }

    private func timeRange(startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) -> ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()

        var startComponents = calendar.dateComponents([.year, .month, .day], from: now)
        startComponents.hour = startHour
        startComponents.minute = startMinute

        var endComponents = calendar.dateComponents([.year, .month, .day], from: now)
        endComponents.hour = endHour
        endComponents.minute = endMinute

        let startDate = calendar.date(from: startComponents) ?? now
        let endDate = calendar.date(from: endComponents) ?? now

        return startDate...endDate
    }

    private func createTimeBinding(
        for keyPath: ReferenceWritableKeyPath<SettingsViewModel, Double>,
        clampedTo range: ClosedRange<Date>
    ) -> Binding<Date> {
        Binding(
            get: { [weak self] in
                guard let self = self else { return Date() }
                let date = Date(timeIntervalSince1970: self[keyPath: keyPath])
                if date < range.lowerBound {
                    return range.lowerBound
                } else if date > range.upperBound {
                    return range.upperBound
                }
                return date
            },
            set: { [weak self] newValue in
                self?[keyPath: keyPath] = newValue.timeIntervalSince1970
            }
        )
    }

    static func defaultTime(hour: Int, minute: Int) -> Double {
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute)
        return calendar.date(from: components)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }
}

// MARK: - Double Extension

private extension Double {
    func nonZeroOr(_ defaultValue: Double) -> Double {
        self == 0 ? defaultValue : self
    }
}
