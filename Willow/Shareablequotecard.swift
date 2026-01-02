//
//  Shareablequotecard.swift
//  Willow
//
//  Created by Matthew Gavin on 1/1/26.
//

//
//  ShareableQuoteCard.swift
//  Willow
//

import SwiftUI

// MARK: - Shareable Quote Card

struct ShareableQuoteCard: View {
    let quote: Quote
    let period: Quote.TimePeriod
    
    private var gradient: LinearGradient {
        switch period {
        case .morning:
            return LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.6, blue: 0.45),
                    Color(red: 0.95, green: 0.75, blue: 0.5),
                    Color(red: 0.98, green: 0.85, blue: 0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .day:
            return LinearGradient(
                colors: [
                    Color(red: 0.68, green: 0.85, blue: 0.95),
                    Color(red: 0.75, green: 0.88, blue: 0.98),
                    Color(red: 0.85, green: 0.93, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .evening:
            return LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.5, blue: 0.4),
                    Color(red: 0.85, green: 0.35, blue: 0.5),
                    Color(red: 0.6, green: 0.3, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .night:
            return LinearGradient(
                colors: [
                    Color(red: 0.15, green: 0.1, blue: 0.25),
                    Color(red: 0.25, green: 0.15, blue: 0.35),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var textColor: Color {
        switch period {
        case .morning:
            return Color(red: 0.25, green: 0.15, blue: 0.1)
        case .day:
            return Color(red: 0.15, green: 0.25, blue: 0.35)
        case .evening, .night:
            return Color(red: 0.95, green: 0.92, blue: 0.98)
        }
    }
    
    var body: some View {
        ZStack {
            gradient
            
            VStack(spacing: 24) {
                Spacer()
                
                // Quote mark
                Image(systemName: "quote.opening")
                    .font(.system(size: 32))
                    .foregroundStyle(textColor.opacity(0.3))
                
                // Quote text
                Text(quote.text)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(textColor)
                    .padding(.horizontal, 32)
                
                // Author
                Text("— \(quote.author)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(textColor.opacity(0.7))
                
                Spacer()
                
                // Subtle branding
                Text("Willow")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(textColor.opacity(0.4))
                    .padding(.bottom, 24)
            }
        }
        .frame(width: 400, height: 400)
    }
}

// MARK: - Share Helper

@MainActor
func renderQuoteCard(quote: Quote, period: Quote.TimePeriod) -> UIImage? {
    let card = ShareableQuoteCard(quote: quote, period: period)
    let renderer = ImageRenderer(content: card)
    
    // Set scale for crisp rendering
    renderer.scale = 3.0
    
    return renderer.uiImage
}

// MARK: - Share Sheet Presenter

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview

#Preview {
    ShareableQuoteCard(
        quote: Quote(
            text: "Waking up this morning, I smile. Twenty-four brand new hours are before me.",
            author: "Thich Nhat Hanh",
            period: .morning
        ),
        period: .morning
    )
}
