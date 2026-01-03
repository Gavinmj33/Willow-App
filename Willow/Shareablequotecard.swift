//
//  Shareablequotecard.swift
//  Willow
//
//  Created by Matthew Gavin on 1/1/26.
//

import SwiftUI

// MARK: - Shareable Quote Card

struct ShareableQuoteCard: View {
    let quote: Quote
    let period: Quote.TimePeriod

    private var theme: Theme {
        Theme.forPeriod(period)
    }

    var body: some View {
        ZStack {
            theme.background

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "quote.opening")
                    .font(.system(size: 32))
                    .foregroundStyle(theme.text.opacity(0.3))

                Text(quote.text)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(theme.text)
                    .padding(.horizontal, 32)

                Text("— \(quote.author)")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(theme.text.opacity(0.7))

                Spacer()

                Text("Willow")
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(theme.text.opacity(0.4))
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
