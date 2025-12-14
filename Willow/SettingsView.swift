//
//  SettingsView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//

import SwiftUI

struct SettingsView: View {
    // Morning
    @AppStorage("morningEnabled") private var morningEnabled = false
    @AppStorage("morningTime") private var morningTimeStored: Double = defaultTime(hour: 7, minute: 0)
    
    // Day
    @AppStorage("dayEnabled") private var dayEnabled = false
    @AppStorage("dayTime") private var dayTimeStored: Double = defaultTime(hour: 12, minute: 0)
    
    // Evening
    @AppStorage("eveningEnabled") private var eveningEnabled = false
    @AppStorage("eveningTime") private var eveningTimeStored: Double = defaultTime(hour: 18, minute: 0)
    
    // Night
    @AppStorage("nightEnabled") private var nightEnabled = false
    @AppStorage("nightTime") private var nightTimeStored: Double = defaultTime(hour: 21, minute: 0)
    
    // Time ranges for each period
    private var morningRange: ClosedRange<Date> {
        timeRange(startHour: 6, startMinute: 0, endHour: 11, endMinute: 59)
    }
    
    private var dayRange: ClosedRange<Date> {
        timeRange(startHour: 12, startMinute: 0, endHour: 16, endMinute: 59)
    }
    
    private var eveningRange: ClosedRange<Date> {
        timeRange(startHour: 17, startMinute: 0, endHour: 20, endMinute: 59)
    }
    
    private var nightRange: ClosedRange<Date> {
        timeRange(startHour: 21, startMinute: 0, endHour: 23, endMinute: 59)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Morning Section
                Section {
                    Toggle("Morning Reminder", isOn: $morningEnabled)
                        .onChange(of: morningEnabled) { _, newValue in
                            handleToggle(enabled: newValue, period: .morning, time: morningTimeStored)
                        }
                    
                    if morningEnabled {
                        DatePicker(
                            "Time",
                            selection: binding(for: $morningTimeStored, clampedTo: morningRange),
                            in: morningRange,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: morningTimeStored) { _, newValue in
                            NotificationManager.shared.scheduleNotification(for: .morning, at: Date(timeIntervalSince1970: newValue))
                        }
                    }
                } header: {
                    Label("Morning", systemImage: "sunrise.fill")
                } footer: {
                    Text("Available: 6:00 AM – 11:59 AM")
                }
                
                // Day Section
                Section {
                    Toggle("Afternoon Reminder", isOn: $dayEnabled)
                        .onChange(of: dayEnabled) { _, newValue in
                            handleToggle(enabled: newValue, period: .day, time: dayTimeStored)
                        }
                    
                    if dayEnabled {
                        DatePicker(
                            "Time",
                            selection: binding(for: $dayTimeStored, clampedTo: dayRange),
                            in: dayRange,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: dayTimeStored) { _, newValue in
                            NotificationManager.shared.scheduleNotification(for: .day, at: Date(timeIntervalSince1970: newValue))
                        }
                    }
                } header: {
                    Label("Afternoon", systemImage: "sun.max.fill")
                } footer: {
                    Text("Available: 12:00 PM – 4:59 PM")
                }
                
                // Evening Section
                Section {
                    Toggle("Evening Reminder", isOn: $eveningEnabled)
                        .onChange(of: eveningEnabled) { _, newValue in
                            handleToggle(enabled: newValue, period: .evening, time: eveningTimeStored)
                        }
                    
                    if eveningEnabled {
                        DatePicker(
                            "Time",
                            selection: binding(for: $eveningTimeStored, clampedTo: eveningRange),
                            in: eveningRange,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: eveningTimeStored) { _, newValue in
                            NotificationManager.shared.scheduleNotification(for: .evening, at: Date(timeIntervalSince1970: newValue))
                        }
                    }
                } header: {
                    Label("Evening", systemImage: "sunset.fill")
                } footer: {
                    Text("Available: 5:00 PM – 8:59 PM")
                }
                
                // Night Section
                Section {
                    Toggle("Night Reminder", isOn: $nightEnabled)
                        .onChange(of: nightEnabled) { _, newValue in
                            handleToggle(enabled: newValue, period: .night, time: nightTimeStored)
                        }
                    
                    if nightEnabled {
                        DatePicker(
                            "Time",
                            selection: binding(for: $nightTimeStored, clampedTo: nightRange),
                            in: nightRange,
                            displayedComponents: .hourAndMinute
                        )
                        .onChange(of: nightTimeStored) { _, newValue in
                            NotificationManager.shared.scheduleNotification(for: .night, at: Date(timeIntervalSince1970: newValue))
                        }
                    }
                } header: {
                    Label("Night", systemImage: "moon.fill")
                } footer: {
                    Text("Available: 9:00 PM – 11:59 PM")
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    // Helper to create default times
    private static func defaultTime(hour: Int, minute: Int) -> Double {
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute)
        return calendar.date(from: components)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }
    
    // Helper to create a time range
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
    
    // Helper to create binding for DatePicker with clamping
    private func binding(for storedTime: Binding<Double>, clampedTo range: ClosedRange<Date>) -> Binding<Date> {
        Binding(
            get: {
                let date = Date(timeIntervalSince1970: storedTime.wrappedValue)
                // Clamp to range if outside bounds
                if date < range.lowerBound {
                    return range.lowerBound
                } else if date > range.upperBound {
                    return range.upperBound
                }
                return date
            },
            set: { storedTime.wrappedValue = $0.timeIntervalSince1970 }
        )
    }
    
    // Helper to handle toggle changes
    private func handleToggle(enabled: Bool, period: NotificationManager.TimePeriod, time: Double) {
        if enabled {
            NotificationManager.shared.requestPermission()
            NotificationManager.shared.scheduleNotification(for: period, at: Date(timeIntervalSince1970: time))
        } else {
            NotificationManager.shared.cancelNotification(for: period)
        }
    }
}

#Preview {
    SettingsView()
}
