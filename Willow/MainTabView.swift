//
//  MainTabView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var themeManager = ThemeManager.shared

    var body: some View {
        TabView(selection: $selectedTab) {
            AffirmationsView()
                .tag(0)
                .tabItem {
                    Label("Affirmations", systemImage: "quote.opening")
                }

            BreathingExerciseView()
                .tag(1)
                .tabItem {
                    Label("Breathe", systemImage: "wind")
                }
        }
        .tint(themeManager.currentTheme.accent)
        .onAppear {
            themeManager.refreshTheme()
            configureTabBarAppearance()
        }
    }

    private func configureTabBarAppearance() {
        let theme = themeManager.currentTheme
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(theme.solidBackground)

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(theme.text.opacity(0.5))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(theme.text.opacity(0.5))
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(theme.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accent)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
