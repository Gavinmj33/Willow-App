//
//  MainTabView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

//
//  MainTabView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var theme: (background: Color, text: Color, accent: Color) {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12:   // Morning
            return (
                background: Color(red: 0.98, green: 0.85, blue: 0.7),
                text: Color(red: 0.25, green: 0.15, blue: 0.1),
                accent: Color(red: 0.9, green: 0.4, blue: 0.3)
            )
        case 12..<17:  // Day
            return (
                background: Color(red: 0.85, green: 0.93, blue: 1.0),
                text: Color(red: 0.15, green: 0.25, blue: 0.35),
                accent: Color(red: 0.3, green: 0.55, blue: 0.75)
            )
        case 17..<21:  // Evening
            return (
                background: Color(red: 0.6, green: 0.3, blue: 0.55),
                text: Color(red: 1.0, green: 0.95, blue: 0.95),
                accent: Color(red: 0.95, green: 0.6, blue: 0.5)
            )
        default:       // Night
            return (
                background: Color(red: 0.1, green: 0.1, blue: 0.2),
                text: Color(red: 0.95, green: 0.92, blue: 0.98),
                accent: Color(red: 0.6, green: 0.4, blue: 0.9)
            )
        }
    }
    
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
        .tint(theme.accent)
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(theme.background)
        
        // Unselected state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(theme.text.opacity(0.5))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(theme.text.opacity(0.5))
        ]
        
        // Selected state
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
