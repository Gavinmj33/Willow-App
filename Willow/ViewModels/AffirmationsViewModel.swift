//
//  AffirmationsViewModel.swift
//  Willow
//
//  ViewModel for affirmations/quotes functionality following MVVM principles.
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

    // MARK: - Private Properties

    private let quoteManager: QuoteManager
    private let themeManager: ThemeManager

    // MARK: - Initialization

    init(quoteManager: QuoteManager = .shared, themeManager: ThemeManager = .shared) {
        self.quoteManager = quoteManager
        self.themeManager = themeManager
        self.currentPeriod = themeManager.currentPeriod
        self.theme = themeManager.currentTheme
        refreshQuote()
    }

    // MARK: - Public Methods

    func refreshQuote() {
        let period = quoteManager.getCurrentPeriod()
        currentPeriod = period
        currentQuote = quoteManager.getTodaysQuote(for: period)
    }

    func refreshTheme() {
        themeManager.refreshTheme()
        currentPeriod = themeManager.currentPeriod
        theme = themeManager.currentTheme
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
