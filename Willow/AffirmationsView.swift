//
//  AffirmationsView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

//
//  AffirmationsView.swift
//  Willow
//
//  Created by Matthew Gavin on 12/14/25.
//

import SwiftUI

struct AffirmationsView: View {
    @State private var showSettings = false
    @StateObject private var quoteManager = QuoteManager.shared
    
    var currentQuote: Quote? {
        let period = quoteManager.getCurrentPeriod()
        return quoteManager.getTodaysQuote(for: period)
    }
    
    var currentPeriod: Quote.TimePeriod {
        quoteManager.getCurrentPeriod()
    }
    
    var theme: (background: LinearGradient, text: Color, accent: Color) {
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
                accent: Color(red: 0.9, green: 0.4, blue: 0.3)
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
                accent: Color(red: 0.3, green: 0.55, blue: 0.75)
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
                accent: Color(red: 0.95, green: 0.6, blue: 0.5)
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
                accent: Color(red: 0.6, green: 0.4, blue: 0.9)
            )
        }
    }
    
    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()
            
            // Time of day visuals
            TimeOfDayVisuals(period: currentPeriod)
            
            VStack(spacing: 20) {
                // Header with settings button
                HStack {
                    Spacer()
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(theme.text.opacity(0.7))
                    }
                }
                .padding()
                
                Spacer()
                
                if let quote = currentQuote {
                    Text("\"\(quote.text)\"")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .foregroundStyle(theme.text)
                    
                    Text("— \(quote.author)")
                        .font(.subheadline)
                        .foregroundStyle(theme.text.opacity(0.7))
                } else {
                    Text("No quote available")
                        .foregroundStyle(theme.text)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    AffirmationsView()
}
