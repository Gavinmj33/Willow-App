//
//  BreathingExerciseView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.


import SwiftUI
import Combine

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
    let duration: Int // seconds
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

// MARK: - Breathing Exercise View

struct BreathingExerciseView: View {
    @State private var selectedPattern: BreathingPattern = .relaxed
    @State private var selectedDuration: SessionDuration = .oneMinute
    @State private var isActive = false
    @State private var isPaused = false
    @State private var currentPhaseIndex = 0
    @State private var phaseTimeRemaining = 0
    @State private var totalTimeRemaining = 0
    @State private var circleScale: CGFloat = 0.5
    @State private var showCompletion = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var theme: (background: LinearGradient, text: Color, accent: Color, circle: Color) {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:   // Morning
            return (
                background: LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.6, blue: 0.45),
                        Color(red: 0.95, green: 0.75, blue: 0.5),
                        Color(red: 0.98, green: 0.85, blue: 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                text: Color(red: 0.25, green: 0.15, blue: 0.1),
                accent: Color(red: 0.9, green: 0.4, blue: 0.3),
                circle: Color(red: 1, green: 0.85, blue: 0.7)
            )
        case 12..<17:  // Day
            return (
                background: LinearGradient(
                    colors: [
                        Color(red: 0.68, green: 0.85, blue: 0.95),
                        Color(red: 0.75, green: 0.88, blue: 0.98),
                        Color(red: 0.85, green: 0.93, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                text: Color(red: 0.15, green: 0.25, blue: 0.35),
                accent: Color(red: 0.3, green: 0.55, blue: 0.75),
                circle: Color(red: 0.85, green: 0.93, blue: 1.0)
            )
        case 17..<21:  // Evening
            return (
                background: LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.5, blue: 0.4),
                        Color(red: 0.85, green: 0.35, blue: 0.5),
                        Color(red: 0.6, green: 0.3, blue: 0.55)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                text: Color(red: 1.0, green: 0.95, blue: 0.95),
                accent: Color(red: 0.95, green: 0.6, blue: 0.5),
                circle: Color(red: 1.0, green: 0.75, blue: 0.7)
            )
        default:       // Night
            return (
                background: LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.1, blue: 0.25),
                        Color(red: 0.25, green: 0.15, blue: 0.35),
                        Color(red: 0.1, green: 0.1, blue: 0.2)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                text: Color(red: 0.95, green: 0.92, blue: 0.98),
                accent: Color(red: 0.6, green: 0.4, blue: 0.9),
                circle: Color(red: 0.7, green: 0.6, blue: 0.9)
            )
        }
    }
    
    var currentPhase: BreathingPhase {
        selectedPattern.phases[currentPhaseIndex]
    }
    
    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                Text("Breathe")
                    .font(.headline)
                    .foregroundStyle(theme.text)
                    .padding(.top)
                
                if !isActive && !showCompletion {
                    // Setup View
                    setupView
                } else if showCompletion {
                    // Completion View
                    completionView
                } else {
                    // Active Breathing View
                    activeBreathingView
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive && !isPaused else { return }
            tick()
        }
    }
    
    // MARK: - Setup View
    
    private var setupView: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Pattern Selection
            VStack(spacing: 12) {
                Text("Pattern")
                    .font(.subheadline)
                    .foregroundStyle(theme.text.opacity(0.7))
                
                HStack(spacing: 12) {
                    ForEach(BreathingPattern.allCases, id: \.self) { pattern in
                        patternButton(pattern)
                    }
                }
                
                Text(selectedPattern.description)
                    .font(.caption)
                    .foregroundStyle(theme.text.opacity(0.6))
            }
            
            // Duration Selection
            VStack(spacing: 12) {
                Text("Duration")
                    .font(.subheadline)
                    .foregroundStyle(theme.text.opacity(0.7))
                
                HStack(spacing: 12) {
                    ForEach(SessionDuration.allCases, id: \.self) { duration in
                        durationButton(duration)
                    }
                }
            }
            
            Spacer()
            
            // Start Button
            Button {
                startSession()
            } label: {
                Text("Begin")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.text)
                    .frame(width: 160, height: 56)
                    .background(theme.circle.opacity(0.5))
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
    }
    
    // MARK: - Active Breathing View
    
    private var activeBreathingView: some View {
        VStack(spacing: 30) {
            // Time remaining
            Text(timeString(from: totalTimeRemaining))
                .font(.title3)
                .monospacedDigit()
                .foregroundStyle(theme.text.opacity(0.7))
            
            Spacer()
            
            // Breathing Circle
            ZStack {
                // Outer ring
                Circle()
                    .stroke(theme.circle.opacity(0.3), lineWidth: 2)
                    .frame(width: 220, height: 220)
                
                // Animated breathing circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                theme.circle.opacity(0.8),
                                theme.circle.opacity(0.4)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(circleScale)
                
                // Phase instruction
                VStack(spacing: 8) {
                    Text(currentPhase.type.instruction)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(theme.text)
                    
                    Text("\(phaseTimeRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .monospacedDigit()
                        .foregroundStyle(theme.text.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Controls
            HStack(spacing: 40) {
                // Stop button
                Button {
                    stopSession()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundStyle(theme.text.opacity(0.7))
                        .frame(width: 60, height: 60)
                        .background(theme.circle.opacity(0.3))
                        .clipShape(Circle())
                }
                
                // Pause/Resume button
                Button {
                    isPaused.toggle()
                } label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundStyle(theme.text)
                        .frame(width: 70, height: 70)
                        .background(theme.circle.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Completion View
    
    private var completionView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(theme.accent)
            
            Text("Well Done")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(theme.text)
            
            Text("Take this calm with you")
                .font(.subheadline)
                .foregroundStyle(theme.text.opacity(0.7))
            
            Spacer()
            
            Button {
                resetSession()
            } label: {
                Text("Done")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.text)
                    .frame(width: 160, height: 56)
                    .background(theme.circle.opacity(0.5))
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Views
    
    private func patternButton(_ pattern: BreathingPattern) -> some View {
        Button {
            selectedPattern = pattern
        } label: {
            Text(pattern.rawValue)
                .font(.caption)
                .fontWeight(selectedPattern == pattern ? .semibold : .regular)
                .foregroundStyle(theme.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(selectedPattern == pattern ? theme.circle.opacity(0.5) : theme.circle.opacity(0.2))
                )
        }
    }
    
    private func durationButton(_ duration: SessionDuration) -> some View {
        Button {
            selectedDuration = duration
        } label: {
            Text(duration.label)
                .font(.subheadline)
                .fontWeight(selectedDuration == duration ? .semibold : .regular)
                .foregroundStyle(theme.text)
                .frame(width: 70, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedDuration == duration ? theme.circle.opacity(0.5) : theme.circle.opacity(0.2))
                )
        }
    }
    
    // MARK: - Timer Logic
    
    private func startSession() {
        currentPhaseIndex = 0
        phaseTimeRemaining = currentPhase.duration
        totalTimeRemaining = selectedDuration.rawValue
        isActive = true
        isPaused = false
        showCompletion = false
        
        updateCircleScale(for: currentPhase.type, duration: currentPhase.duration)
        triggerHaptic()
    }
    
    private func stopSession() {
        isActive = false
        isPaused = false
        currentPhaseIndex = 0
        circleScale = 0.5
    }
    
    private func resetSession() {
        showCompletion = false
        isActive = false
        isPaused = false
        currentPhaseIndex = 0
        circleScale = 0.5
    }
    
    private func tick() {
        totalTimeRemaining -= 1
        phaseTimeRemaining -= 1
        
        if totalTimeRemaining <= 0 {
            // Session complete
            isActive = false
            showCompletion = true
            triggerHaptic(style: .success)
            return
        }
        
        if phaseTimeRemaining <= 0 {
            // Move to next phase
            currentPhaseIndex = (currentPhaseIndex + 1) % selectedPattern.phases.count
            phaseTimeRemaining = currentPhase.duration
            updateCircleScale(for: currentPhase.type, duration: currentPhase.duration)
            triggerHaptic()
        }
    }
    
    private func updateCircleScale(for phaseType: BreathingPhase.PhaseType, duration: Int) {
        let targetScale: CGFloat
        
        switch phaseType {
        case .inhale:
            targetScale = 1.0
        case .exhale:
            targetScale = 0.5
        case .holdIn:
            targetScale = 1.0
        case .holdOut:
            targetScale = 0.5
        }
        
        withAnimation(.easeInOut(duration: Double(duration))) {
            circleScale = targetScale
        }
    }
    
    private func triggerHaptic(style: UINotificationFeedbackGenerator.FeedbackType? = nil) {
        if let style = style {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(style)
        } else {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    BreathingExerciseView()
}
