//
//  SettingsView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                morningSection
                daySection
                eveningSection
                nightSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Morning Section

    private var morningSection: some View {
        Section {
            Toggle("Morning Reminder", isOn: $viewModel.morningEnabled)

            if viewModel.morningEnabled {
                DatePicker(
                    "Time",
                    selection: viewModel.morningTimeBinding(clampedTo: viewModel.morningRange),
                    in: viewModel.morningRange,
                    displayedComponents: .hourAndMinute
                )
            }
        } header: {
            Label("Morning", systemImage: "sunrise.fill")
        } footer: {
            Text("Available: 6:00 AM – 11:59 AM")
        }
    }

    // MARK: - Day Section

    private var daySection: some View {
        Section {
            Toggle("Afternoon Reminder", isOn: $viewModel.dayEnabled)

            if viewModel.dayEnabled {
                DatePicker(
                    "Time",
                    selection: viewModel.dayTimeBinding(clampedTo: viewModel.dayRange),
                    in: viewModel.dayRange,
                    displayedComponents: .hourAndMinute
                )
            }
        } header: {
            Label("Afternoon", systemImage: "sun.max.fill")
        } footer: {
            Text("Available: 12:00 PM – 4:59 PM")
        }
    }

    // MARK: - Evening Section

    private var eveningSection: some View {
        Section {
            Toggle("Evening Reminder", isOn: $viewModel.eveningEnabled)

            if viewModel.eveningEnabled {
                DatePicker(
                    "Time",
                    selection: viewModel.eveningTimeBinding(clampedTo: viewModel.eveningRange),
                    in: viewModel.eveningRange,
                    displayedComponents: .hourAndMinute
                )
            }
        } header: {
            Label("Evening", systemImage: "sunset.fill")
        } footer: {
            Text("Available: 5:00 PM – 8:59 PM")
        }
    }

    // MARK: - Night Section

    private var nightSection: some View {
        Section {
            Toggle("Night Reminder", isOn: $viewModel.nightEnabled)

            if viewModel.nightEnabled {
                DatePicker(
                    "Time",
                    selection: viewModel.nightTimeBinding(clampedTo: viewModel.nightRange),
                    in: viewModel.nightRange,
                    displayedComponents: .hourAndMinute
                )
            }
        } header: {
            Label("Night", systemImage: "moon.fill")
        } footer: {
            Text("Available: 9:00 PM – 11:59 PM")
        }
    }
}

#Preview {
    SettingsView()
}
