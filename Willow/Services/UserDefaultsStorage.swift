//
//  UserDefaultsStorage.swift
//  Willow
//
//  Single responsibility: Persisting settings to UserDefaults.
//

import Foundation

final class UserDefaultsStorage: SettingsStoring {
    static let shared = UserDefaultsStorage()

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func bool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func double(forKey key: String) -> Double {
        defaults.double(forKey: key)
    }

    func set(_ value: Bool, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func set(_ value: Double, forKey key: String) {
        defaults.set(value, forKey: key)
    }
}
