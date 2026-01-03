//
//  TimeProvider.swift
//  Willow
//
//  Single responsibility: Providing current time information.
//

import Foundation

final class TimeProvider: TimeProviding {
    static let shared = TimeProvider()

    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func currentHour() -> Int {
        calendar.component(.hour, from: Date())
    }
}
