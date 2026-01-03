//
//  BreathingExerciseView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

import SwiftUI

// MARK: - Breathing Exercise View

struct BreathingExerciseView: View {
    @StateObject private var viewModel = BreathingExerciseViewModel()

    var body: some View {
        ZStack {
            viewModel.theme.background
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Breathe")
                    .font(.headline)
                    .foregroundStyle(viewModel.theme.text)
                    .padding(.top)

                if !viewModel.isActive && !viewModel.showCompletion {
                    setupView
                } else if viewModel.showCompletion {
                    completionView
                } else {
                    activeBreathingView
                }
            }
        }
        .onAppear {
            viewModel.refreshTheme()
        }
    }

    // MARK: - Setup View

    private var setupView: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 12) {
                Text("Pattern")
                    .font(.subheadline)
                    .foregroundStyle(viewModel.theme.text.opacity(0.7))

                HStack(spacing: 12) {
                    ForEach(BreathingPattern.allCases, id: \.self) { pattern in
                        patternButton(pattern)
                    }
                }

                Text(viewModel.selectedPattern.description)
                    .font(.caption)
                    .foregroundStyle(viewModel.theme.text.opacity(0.6))
            }

            VStack(spacing: 12) {
                Text("Duration")
                    .font(.subheadline)
                    .foregroundStyle(viewModel.theme.text.opacity(0.7))

                HStack(spacing: 12) {
                    ForEach(SessionDuration.allCases, id: \.self) { duration in
                        durationButton(duration)
                    }
                }
            }

            Spacer()

            Button {
                viewModel.startSession()
            } label: {
                Text("Begin")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.theme.text)
                    .frame(width: 160, height: 56)
                    .background(viewModel.theme.circle.opacity(0.5))
                    .clipShape(Capsule())
            }

            Spacer()
        }
    }

    // MARK: - Active Breathing View

    private var activeBreathingView: some View {
        VStack(spacing: 30) {
            Text(viewModel.formattedTimeRemaining)
                .font(.title3)
                .monospacedDigit()
                .foregroundStyle(viewModel.theme.text.opacity(0.7))

            Spacer()

            ZStack {
                Circle()
                    .stroke(viewModel.theme.circle.opacity(0.3), lineWidth: 2)
                    .frame(width: 220, height: 220)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                viewModel.theme.circle.opacity(0.8),
                                viewModel.theme.circle.opacity(0.4)
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(viewModel.circleScale)

                VStack(spacing: 8) {
                    Text(viewModel.currentPhase.type.instruction)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(viewModel.theme.text)

                    Text("\(viewModel.phaseTimeRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .monospacedDigit()
                        .foregroundStyle(viewModel.theme.text.opacity(0.8))
                }
            }

            Spacer()

            HStack(spacing: 40) {
                Button {
                    viewModel.stopSession()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.theme.text.opacity(0.7))
                        .frame(width: 60, height: 60)
                        .background(viewModel.theme.circle.opacity(0.3))
                        .clipShape(Circle())
                }

                Button {
                    viewModel.togglePause()
                } label: {
                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)
                        .foregroundStyle(viewModel.theme.text)
                        .frame(width: 70, height: 70)
                        .background(viewModel.theme.circle.opacity(0.5))
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
                .foregroundStyle(viewModel.theme.accent)

            Text("Well Done")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.theme.text)

            Text("Take this calm with you")
                .font(.subheadline)
                .foregroundStyle(viewModel.theme.text.opacity(0.7))

            Spacer()

            Button {
                viewModel.resetSession()
            } label: {
                Text("Done")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.theme.text)
                    .frame(width: 160, height: 56)
                    .background(viewModel.theme.circle.opacity(0.5))
                    .clipShape(Capsule())
            }

            Spacer()
        }
    }

    // MARK: - Helper Views

    private func patternButton(_ pattern: BreathingPattern) -> some View {
        Button {
            viewModel.selectedPattern = pattern
        } label: {
            Text(pattern.rawValue)
                .font(.caption)
                .fontWeight(viewModel.selectedPattern == pattern ? .semibold : .regular)
                .foregroundStyle(viewModel.theme.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(viewModel.selectedPattern == pattern ? viewModel.theme.circle.opacity(0.5) : viewModel.theme.circle.opacity(0.2))
                )
        }
    }

    private func durationButton(_ duration: SessionDuration) -> some View {
        Button {
            viewModel.selectedDuration = duration
        } label: {
            Text(duration.label)
                .font(.subheadline)
                .fontWeight(viewModel.selectedDuration == duration ? .semibold : .regular)
                .foregroundStyle(viewModel.theme.text)
                .frame(width: 70, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.selectedDuration == duration ? viewModel.theme.circle.opacity(0.5) : viewModel.theme.circle.opacity(0.2))
                )
        }
    }
}

#Preview {
    BreathingExerciseView()
}
