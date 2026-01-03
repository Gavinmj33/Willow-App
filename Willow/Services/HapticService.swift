//
//  HapticService.swift
//  Willow
//
//  Single responsibility: Haptic feedback generation.
//

import UIKit

final class HapticService: HapticFeedbackProviding {
    static let shared = HapticService()

    private init() {}

    func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
