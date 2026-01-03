//
//  AffirmationsView.swift
//  Willow
//

import SwiftUI

struct AffirmationsView: View {
    @StateObject private var viewModel = AffirmationsViewModel()

    var body: some View {
        ZStack {
            viewModel.theme.background
                .ignoresSafeArea()

            TimeOfDayVisuals(period: viewModel.currentPeriod)

            VStack(spacing: 20) {
                HStack {
                    Spacer()

                    if let quote = viewModel.currentQuote {
                        Button {
                            viewModel.shareQuote(quote)
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundStyle(viewModel.theme.text.opacity(0.7))
                        }
                    }

                    Button {
                        viewModel.showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(viewModel.theme.text.opacity(0.7))
                    }
                }
                .padding()

                Spacer()

                if let quote = viewModel.currentQuote {
                    Text("\"\(quote.text)\"")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .foregroundStyle(viewModel.theme.text)

                    Text("— \(quote.author)")
                        .font(.subheadline)
                        .foregroundStyle(viewModel.theme.text.opacity(0.7))
                } else {
                    Text("No quote available")
                        .foregroundStyle(viewModel.theme.text)
                }

                Spacer()
            }
        }
        .onAppear {
            viewModel.refreshTheme()
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $viewModel.showShareSheet, onDismiss: {
            viewModel.dismissShareSheet()
        }) {
            if let image = viewModel.shareImage {
                ShareSheet(items: [image])
            }
        }
        .onChange(of: viewModel.shareImage) { _, newImage in
            if newImage != nil {
                viewModel.showShareSheet = true
            }
        }
    }
}

#Preview {
    AffirmationsView()
}
