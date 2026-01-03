//
//  AffirmationsViewModel.swift
//  Willow
//
//  ViewModel for affirmations/quotes functionality following SOLID principles.
//

import SwiftUI

@MainActor
final class AffirmationsViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published private(set) var currentQuote: Quote?
    @Published private(set) var currentPeriod: Quote.TimePeriod
    @Published private(set) var theme: Theme
    @Published var showSettings = false
    @Published var showShareSheet = false
    @Published var shareImage: UIImage?

    // MARK: - Private Properties (Protocol-based Dependencies)

    private let quoteProvider: QuoteProviding
    private let themeProvider: ThemeProviding

    // MARK: - Initialization (Dependency Injection)

    init(
        quoteProvider: QuoteProviding = QuoteManager.shared,
        themeProvider: ThemeProviding = ThemeManager.shared
    ) {
        self.quoteProvider = quoteProvider
        self.themeProvider = themeProvider
        self.currentPeriod = themeProvider.currentPeriod
        self.theme = themeProvider.currentTheme
        refreshQuote()
    }

    // MARK: - Public Methods

    func refreshQuote() {
        let period = quoteProvider.getCurrentPeriod()
        currentPeriod = period
        currentQuote = quoteProvider.getTodaysQuote(for: period)
    }

    func refreshTheme() {
        themeProvider.refreshTheme()
        currentPeriod = themeProvider.currentPeriod
        theme = themeProvider.currentTheme
        refreshQuote()
    }

    func shareQuote(_ quote: Quote) {
        if let image = renderQuoteCard(quote: quote, period: currentPeriod) {
            shareImage = image
        }
    }

    func dismissShareSheet() {
        shareImage = nil
    }
}
