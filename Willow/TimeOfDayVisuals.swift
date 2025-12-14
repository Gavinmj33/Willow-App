//
//  TimeOfDayVisuals.swift
//  Willow
//
//  Created by Matthew Gavin on 12/12/25.
//

import SwiftUI

// MARK: - Main Visual Container

struct TimeOfDayVisuals: View {
    let period: Quote.TimePeriod
    
    var body: some View {
        switch period {
        case .morning:
            MorningVisuals()
        case .day:
            DayVisuals()
        case .evening:
            EveningVisuals()
        case .night:
            NightVisuals()
        }
    }
}

// MARK: - Morning Visuals

struct MorningVisuals: View {
    @State private var sunOffset: CGFloat = 50
    @State private var rayRotation: Double = 0
    @State private var cloudProgress1: CGFloat = 0
    @State private var cloudProgress2: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                // Sun rays
                ForEach(0..<8) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 4, height: 40)
                        .offset(y: -70)
                        .rotationEffect(.degrees(Double(i) * 45 + rayRotation))
                }
                .position(x: screenWidth * 0.65, y: geometry.size.height * 0.25 + sunOffset)
                
                // Sun
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, Color(red: 1, green: 0.9, blue: 0.6)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .orange.opacity(0.5), radius: 20)
                    .position(x: screenWidth * 0.65, y: geometry.size.height * 0.25 + sunOffset)
                
                // Clouds
                CloudShape()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 120, height: 50)
                    .position(
                        x: -150 + cloudProgress1 * (screenWidth + 300),
                        y: geometry.size.height * 0.15
                    )
                
                CloudShape()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 80, height: 35)
                    .position(
                        x: -100 + cloudProgress2 * (screenWidth + 200),
                        y: geometry.size.height * 0.35
                    )
            }
            .onAppear {
                withAnimation(.easeOut(duration: 2)) {
                    sunOffset = 0
                }
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rayRotation = 360
                }
                withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                    cloudProgress1 = 1
                }
                withAnimation(.linear(duration: 45).repeatForever(autoreverses: false).delay(5)) {
                    cloudProgress2 = 1
                }
            }
        }
    }
}

// MARK: - Day Visuals

struct DayVisuals: View {
    @State private var rayRotation: Double = 0
    @State private var cloudProgress1: CGFloat = 0
    @State private var cloudProgress2: CGFloat = 0
    @State private var cloudProgress3: CGFloat = 0
    @State private var birdProgress1: CGFloat = 0
    @State private var birdProgress2: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let sunX = screenWidth * 0.75
            let sunY = geometry.size.height * 0.15
            
            ZStack {
                // Sun rays
                ForEach(0..<8) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 4, height: 40)
                        .offset(y: -70)
                        .rotationEffect(.degrees(Double(i) * 45 + rayRotation))
                }
                .position(x: sunX, y: sunY)
                
                // Sun
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, Color(red: 1, green: 0.9, blue: 0.6)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .orange.opacity(0.5), radius: 20)
                    .position(x: sunX, y: sunY)
                
                // Clouds
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 140, height: 60)
                    .position(
                        x: -200 + cloudProgress1 * (screenWidth + 400),
                        y: geometry.size.height * 0.12
                    )
                
                CloudShape()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 100, height: 45)
                    .position(
                        x: -150 + cloudProgress2 * (screenWidth + 350),
                        y: geometry.size.height * 0.25
                    )
                
                CloudShape()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 120, height: 50)
                    .position(
                        x: -180 + cloudProgress3 * (screenWidth + 380),
                        y: geometry.size.height * 0.4
                    )
                
                // Birds
                BirdGroup()
                    .position(
                        x: -100 + birdProgress1 * (screenWidth + 200),
                        y: geometry.size.height * 0.18
                    )
                
                BirdShape()
                    .stroke(Color(red: 0.2, green: 0.35, blue: 0.5).opacity(0.6), lineWidth: 2)
                    .frame(width: 20, height: 10)
                    .position(
                        x: -80 + birdProgress2 * (screenWidth + 180),
                        y: geometry.size.height * 0.32
                    )
            }
            .onAppear {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rayRotation = 360
                }
                withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                    cloudProgress1 = 1
                }
                withAnimation(.linear(duration: 35).repeatForever(autoreverses: false).delay(3)) {
                    cloudProgress2 = 1
                }
                withAnimation(.linear(duration: 40).repeatForever(autoreverses: false).delay(8)) {
                    cloudProgress3 = 1
                }
                withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                    birdProgress1 = 1
                }
                withAnimation(.linear(duration: 15).repeatForever(autoreverses: false).delay(4)) {
                    birdProgress2 = 1
                }
            }
        }
    }
}

// MARK: - Evening Visuals

struct EveningVisuals: View {
    @State private var glowPulse: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                // Subtle horizon glow
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 1, green: 0.8, blue: 0.5).opacity(0.3 + glowPulse * 0.1),
                                Color(red: 1, green: 0.6, blue: 0.4).opacity(0.15),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: screenWidth * 1.0, height: 250)
                    .position(x: screenWidth * 0.5, y: screenHeight * 0.75)
                
                // Floating particles
                FloatingParticles()
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    glowPulse = 1
                }
            }
        }
    }
}

// MARK: - Floating Particles

struct FloatingParticles: View {
    var body: some View {
        ZStack {
            ForEach(0..<15) { i in
                FloatingParticle(
                    index: i,
                    size: CGFloat.random(in: 3...6),
                    startX: CGFloat.random(in: 0.1...0.9),
                    duration: Double.random(in: 8...15)
                )
            }
        }
    }
}

// MARK: - Single Floating Particle

struct FloatingParticle: View {
    let index: Int
    let size: CGFloat
    let startX: CGFloat
    let duration: Double
    
    @State private var progress: CGFloat = 0
    @State private var opacity: Double = 0
    
    private let particleColors: [Color] = [
        Color(red: 1, green: 0.85, blue: 0.5),
        Color(red: 1, green: 0.75, blue: 0.4),
        Color(red: 1, green: 0.7, blue: 0.5),
        Color(red: 1, green: 0.8, blue: 0.6)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            Circle()
                .fill(particleColors[index % particleColors.count])
                .frame(width: size, height: size)
                .blur(radius: 1)
                .opacity(opacity)
                .position(
                    x: screenWidth * startX + sin(progress * .pi * 2) * 20,
                    y: screenHeight * 0.85 - progress * screenHeight * 0.6
                )
                .onAppear {
                    let delay = Double(index) * 0.5
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        animateParticle()
                    }
                }
        }
    }
    
    private func animateParticle() {
        // Fade in
        withAnimation(.easeIn(duration: 1)) {
            opacity = Double.random(in: 0.4...0.7)
        }
        
        // Float upward
        withAnimation(.easeInOut(duration: duration)) {
            progress = 1
        }
        
        // Fade out near the end
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.7) {
            withAnimation(.easeOut(duration: duration * 0.3)) {
                opacity = 0
            }
        }
        
        // Reset and repeat
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            progress = 0
            animateParticle()
        }
    }
}

// MARK: - Night Visuals

struct NightVisuals: View {
    @State private var starsOpacity: [Double] = Array(repeating: 0.3, count: 20)
    @State private var moonGlow: Double = 0.3
    
    private let starPositions: [(CGFloat, CGFloat)] = [
        (0.1, 0.1), (0.3, 0.05), (0.5, 0.12), (0.7, 0.08), (0.9, 0.15),
        (0.15, 0.25), (0.4, 0.2), (0.6, 0.28), (0.85, 0.22), (0.25, 0.35),
        (0.45, 0.38), (0.65, 0.32), (0.8, 0.4), (0.1, 0.45), (0.35, 0.5),
        (0.55, 0.48), (0.75, 0.52), (0.2, 0.58), (0.5, 0.55), (0.9, 0.6)
    ]
    
    private let starSizes: [CGFloat] = [
        2, 3, 2.5, 3.5, 2, 3, 2.5, 4, 2, 3,
        2.5, 3, 2, 3.5, 2.5, 3, 2, 3.5, 2.5, 3
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Stars
                ForEach(0..<20) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: starSizes[i], height: starSizes[i])
                        .opacity(starsOpacity[i])
                        .position(
                            x: starPositions[i].0 * geometry.size.width,
                            y: starPositions[i].1 * geometry.size.height
                        )
                }
                
                // Moon glow
                Circle()
                    .fill(Color.white.opacity(moonGlow))
                    .frame(width: 120, height: 120)
                    .blur(radius: 30)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.15)
                
                // Moon
                ZStack {
                    Circle()
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.9))
                        .frame(width: 60, height: 60)
                    
                    // Moon craters
                    Circle()
                        .fill(Color(red: 0.85, green: 0.85, blue: 0.8))
                        .frame(width: 12, height: 12)
                        .offset(x: -10, y: -8)
                    
                    Circle()
                        .fill(Color(red: 0.88, green: 0.88, blue: 0.83))
                        .frame(width: 8, height: 8)
                        .offset(x: 15, y: 10)
                    
                    Circle()
                        .fill(Color(red: 0.87, green: 0.87, blue: 0.82))
                        .frame(width: 6, height: 6)
                        .offset(x: 5, y: -15)
                }
                .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.15)
                
                // Shooting star (occasional)
                ShootingStar()
                    .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.10)
            }
        }
        .onAppear {
            // Twinkling stars
            for i in 0..<20 {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 1...3))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2))
                ) {
                    starsOpacity[i] = Double.random(in: 0.5...1.0)
                }
            }
            
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                moonGlow = 0.5
            }
        }
    }
}

// MARK: - Shooting Star

struct ShootingStar: View {
    @State private var show = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.white, .white.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 60, height: 2)
            .rotationEffect(.degrees(-35))
            .opacity(show ? 1 : 0)
            .offset(x: -offset, y: offset * 0.7)
            .onAppear {
                animateShootingStar()
            }
    }
    
    private func animateShootingStar() {
        // Random delay before shooting star appears
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3...8)) {
            withAnimation(.easeOut(duration: 0.8)) {
                show = true
                offset = 120
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                show = false
                offset = 0
                animateShootingStar() // Repeat
            }
        }
    }
}

// MARK: - Helper Shapes

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Main cloud body made of overlapping circles
        path.addEllipse(in: CGRect(x: width * 0.1, y: height * 0.4, width: width * 0.35, height: height * 0.6))
        path.addEllipse(in: CGRect(x: width * 0.25, y: height * 0.15, width: width * 0.4, height: height * 0.7))
        path.addEllipse(in: CGRect(x: width * 0.5, y: height * 0.3, width: width * 0.4, height: height * 0.6))
        path.addEllipse(in: CGRect(x: width * 0.0, y: height * 0.5, width: width * 0.3, height: height * 0.45))
        path.addEllipse(in: CGRect(x: width * 0.65, y: height * 0.45, width: width * 0.3, height: height * 0.45))
        
        return path
    }
}

struct BirdShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Simple bird silhouette (like a checkmark/V shape)
        path.move(to: CGPoint(x: 0, y: height * 0.3))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control: CGPoint(x: width * 0.25, y: height * 0.6)
        )
        path.addQuadCurve(
            to: CGPoint(x: width, y: height * 0.3),
            control: CGPoint(x: width * 0.75, y: height * 0.6)
        )
        
        return path
    }
}

struct BirdGroup: View {
    var body: some View {
        ZStack {
            BirdShape()
                .stroke(Color(red: 0.2, green: 0.35, blue: 0.5).opacity(0.7), lineWidth: 2)
                .frame(width: 25, height: 12)
            
            BirdShape()
                .stroke(Color(red: 0.2, green: 0.35, blue: 0.5).opacity(0.5), lineWidth: 2)
                .frame(width: 18, height: 9)
                .offset(x: -30, y: 15)
            
            BirdShape()
                .stroke(Color(red: 0.2, green: 0.35, blue: 0.5).opacity(0.6), lineWidth: 2)
                .frame(width: 20, height: 10)
                .offset(x: 25, y: 20)
        }
    }
}

struct BirdFormation: View {
    var body: some View {
        ZStack {
            // V formation of birds
            ForEach(0..<5) { i in
                BirdShape()
                    .stroke(Color.white.opacity(0.7), lineWidth: 1.5)
                    .frame(width: 15, height: 8)
                    .offset(
                        x: CGFloat(i - 2) * 20,
                        y: abs(CGFloat(i - 2)) * 12
                    )
            }
        }
    }
}

#Preview("Morning") {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.6, blue: 0.45),
                Color(red: 0.95, green: 0.75, blue: 0.5),
                Color(red: 0.98, green: 0.85, blue: 0.7)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        TimeOfDayVisuals(period: .morning)
    }
}

#Preview("Day") {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.68, green: 0.85, blue: 0.95),
                Color(red: 0.75, green: 0.88, blue: 0.98),
                Color(red: 0.85, green: 0.93, blue: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        TimeOfDayVisuals(period: .day)
    }
}

#Preview("Evening") {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.95, green: 0.5, blue: 0.4),
                Color(red: 0.85, green: 0.35, blue: 0.5),
                Color(red: 0.6, green: 0.3, blue: 0.55)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        TimeOfDayVisuals(period: .evening)
    }
}

#Preview("Night") {
    ZStack {
        LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.1, blue: 0.25),
                Color(red: 0.25, green: 0.15, blue: 0.35),
                Color(red: 0.1, green: 0.1, blue: 0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        TimeOfDayVisuals(period: .night)
    }
}
