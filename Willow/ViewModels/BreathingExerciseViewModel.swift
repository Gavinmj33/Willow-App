//
//  BreathingExerciseViewModel.swift
//  Willow
//
//  ViewModel for breathing exercise functionality following SOLID principles.
//

import SwiftUI
import Combine

// MARK: - Breathing Phase

struct BreathingPhase {
    enum PhaseType {
        case inhale
        case holdIn
        case exhale
        case holdOut

        var instruction: String {
            switch self {
            case .inhale: return "Breathe In"
            case .holdIn: return "Hold"
            case .exhale: return "Breathe Out"
            case .holdOut: return "Hold"
            }
        }
    }

    let type: PhaseType
    let duration: Int
}

// MARK: - Breathing Pattern

enum BreathingPattern: String, CaseIterable {
    case relaxed = "Relaxed"
    case boxBreathing = "Box Breathing"
    case fourSevenEight = "4-7-8"

    var phases: [BreathingPhase] {
        switch self {
        case .relaxed:
            return [
                BreathingPhase(type: .inhale, duration: 4),
                BreathingPhase(type: .exhale, duration: 6)
            ]
        case .boxBreathing:
            return [
                BreathingPhase(type: .inhale, duration: 4),
                BreathingPhase(type: .holdIn, duration: 4),
                BreathingPhase(type: .exhale, duration: 4),
                BreathingPhase(type: .holdOut, duration: 4)
            ]
        case .fourSevenEight:
            return [
                BreathingPhase(type: .inhale, duration: 4),
                BreathingPhase(type: .holdIn, duration: 7),
                BreathingPhase(type: .exhale, duration: 8)
            ]
        }
    }

    var description: String {
        switch self {
        case .relaxed:
            return "Gentle breathing for calm"
        case .boxBreathing:
            return "Equal phases for focus"
        case .fourSevenEight:
            return "Deep relaxation technique"
        }
    }

    var cycleDuration: Int {
        phases.reduce(0) { $0 + $1.duration }
    }
}

// MARK: - Session Duration

enum SessionDuration: Int, CaseIterable {
    case oneMinute = 60
    case threeMinutes = 180
    case fiveMinutes = 300

    var label: String {
        switch self {
        case .oneMinute: return "1 min"
        case .threeMinutes: return "3 min"
        case .fiveMinutes: return "5 min"
        }
    }
}

// MARK: - BreathingExerciseViewModel

@MainActor
final class BreathingExerciseViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var selectedPattern: BreathingPattern = .relaxed
    @Published var selectedDuration: SessionDuration = .oneMinute
    @Published private(set) var isActive = false
    @Published var isPaused = false
    @Published private(set) var currentPhaseIndex = 0
    @Published private(set) var phaseTimeRemaining = 0
    @Published private(set) var totalTimeRemaining = 0
    @Published private(set) var circleScale: CGFloat = 0.5
    @Published private(set) var showCompletion = false
    @Published private(set) var theme: Theme

    // MARK: - Private Properties (Protocol-based Dependencies)

    private var timerCancellable: AnyCancellable?
    private let themeProvider: ThemeProviding
    private let hapticService: HapticFeedbackProviding

    // MARK: - Computed Properties

    var currentPhase: BreathingPhase {
        selectedPattern.phases[currentPhaseIndex]
    }

    var formattedTimeRemaining: String {
        let minutes = totalTimeRemaining / 60
        let seconds = totalTimeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Initialization (Dependency Injection)

    init(
        themeProvider: ThemeProviding = ThemeManager.shared,
        hapticService: HapticFeedbackProviding = HapticService.shared
    ) {
        self.themeProvider = themeProvider
        self.hapticService = hapticService
        self.theme = themeProvider.currentTheme
    }

    // MARK: - Session Control

    func startSession() {
        currentPhaseIndex = 0
        phaseTimeRemaining = currentPhase.duration
        totalTimeRemaining = selectedDuration.rawValue
        isActive = true
        isPaused = false
        showCompletion = false

        updateCircleScale(for: currentPhase.type, duration: currentPhase.duration)
        hapticService.triggerImpact(style: .light)
        startTimer()
    }

    func stopSession() {
        stopTimer()
        isActive = false
        isPaused = false
        currentPhaseIndex = 0
        circleScale = 0.5
    }

    func resetSession() {
        stopTimer()
        showCompletion = false
        isActive = false
        isPaused = false
        currentPhaseIndex = 0
        circleScale = 0.5
    }

    func togglePause() {
        isPaused.toggle()
    }

    func refreshTheme() {
        themeProvider.refreshTheme()
        theme = themeProvider.currentTheme
    }

    // MARK: - Private Methods

    private func startTimer() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func tick() {
        guard isActive && !isPaused else { return }

        totalTimeRemaining -= 1
        phaseTimeRemaining -= 1

        if totalTimeRemaining <= 0 {
            completeSession()
            return
        }

        if phaseTimeRemaining <= 0 {
            advanceToNextPhase()
        }
    }

    private func completeSession() {
        stopTimer()
        isActive = false
        showCompletion = true
        hapticService.triggerNotification(type: .success)
    }

    private func advanceToNextPhase() {
        currentPhaseIndex = (currentPhaseIndex + 1) % selectedPattern.phases.count
        phaseTimeRemaining = currentPhase.duration
        updateCircleScale(for: currentPhase.type, duration: currentPhase.duration)
        hapticService.triggerImpact(style: .light)
    }

    private func updateCircleScale(for phaseType: BreathingPhase.PhaseType, duration: Int) {
        let targetScale: CGFloat
        switch phaseType {
        case .inhale, .holdIn:
            targetScale = 1.0
        case .exhale, .holdOut:
            targetScale = 0.5
        }

        withAnimation(.easeInOut(duration: Double(duration))) {
            circleScale = targetScale
        }
    }
}
