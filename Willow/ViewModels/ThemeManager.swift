//
//  ThemeManager.swift
//  Willow
//
//  Centralizes all theme-related logic following SOLID principles.
//

import SwiftUI

// MARK: - Theme

struct Theme {
    let background: LinearGradient
    let solidBackground: Color
    let text: Color
    let accent: Color
    let circle: Color

    static func forPeriod(_ period: Quote.TimePeriod) -> Theme {
        switch period {
        case .morning:
            return Theme(
                background: LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.6, blue: 0.45),
                        Color(red: 0.95, green: 0.75, blue: 0.5),
                        Color(red: 0.98, green: 0.85, blue: 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                solidBackground: Color(red: 0.98, green: 0.85, blue: 0.7),
                text: Color(red: 0.25, green: 0.15, blue: 0.1),
                accent: Color(red: 0.9, green: 0.4, blue: 0.3),
                circle: Color(red: 1, green: 0.85, blue: 0.7)
            )
        case .day:
            return Theme(
                background: LinearGradient(
                    colors: [
                        Color(red: 0.68, green: 0.85, blue: 0.95),
                        Color(red: 0.75, green: 0.88, blue: 0.98),
                        Color(red: 0.85, green: 0.93, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                solidBackground: Color(red: 0.85, green: 0.93, blue: 1.0),
                text: Color(red: 0.15, green: 0.25, blue: 0.35),
                accent: Color(red: 0.3, green: 0.55, blue: 0.75),
                circle: Color(red: 0.85, green: 0.93, blue: 1.0)
            )
        case .evening:
            return Theme(
                background: LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.5, blue: 0.4),
                        Color(red: 0.85, green: 0.35, blue: 0.5),
                        Color(red: 0.6, green: 0.3, blue: 0.55)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                solidBackground: Color(red: 0.6, green: 0.3, blue: 0.55),
                text: Color(red: 1.0, green: 0.95, blue: 0.95),
                accent: Color(red: 0.95, green: 0.6, blue: 0.5),
                circle: Color(red: 1.0, green: 0.75, blue: 0.7)
            )
        case .night:
            return Theme(
                background: LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.1, blue: 0.25),
                        Color(red: 0.25, green: 0.15, blue: 0.35),
                        Color(red: 0.1, green: 0.1, blue: 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                solidBackground: Color(red: 0.1, green: 0.1, blue: 0.2),
                text: Color(red: 0.95, green: 0.92, blue: 0.98),
                accent: Color(red: 0.6, green: 0.4, blue: 0.9),
                circle: Color(red: 0.7, green: 0.6, blue: 0.9)
            )
        }
    }
}

// MARK: - ThemeManager

@MainActor
final class ThemeManager: ObservableObject, ThemeProviding {
    static let shared = ThemeManager()

    @Published private(set) var currentPeriod: Quote.TimePeriod
    @Published private(set) var currentTheme: Theme

    private let timeProvider: TimeProviding

    init(timeProvider: TimeProviding = TimeProvider.shared) {
        self.timeProvider = timeProvider
        let period = Self.calculatePeriod(from: timeProvider.currentHour())
        self.currentPeriod = period
        self.currentTheme = Theme.forPeriod(period)
    }

    func refreshTheme() {
        let period = Self.calculatePeriod(from: timeProvider.currentHour())
        if period != currentPeriod {
            currentPeriod = period
            currentTheme = Theme.forPeriod(period)
        }
    }

    func theme(for period: Quote.TimePeriod) -> Theme {
        Theme.forPeriod(period)
    }

    private static func calculatePeriod(from hour: Int) -> Quote.TimePeriod {
        switch hour {
        case 6..<12:
            return .morning
        case 12..<17:
            return .day
        case 17..<21:
            return .evening
        default:
            return .night
        }
    }
}
