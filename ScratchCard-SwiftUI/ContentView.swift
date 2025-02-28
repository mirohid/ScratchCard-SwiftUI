//
//  ContentView.swift
//  ScratchCard-SwiftUI
//
//  Created by MacMini6 on 28/02/25.
//


import SwiftUI

struct ScratchCardView: View {
    @State private var isFlipped = false
    @State private var scratchProgress: CGFloat = 0
    @State private var scratchPoints: [CGPoint] = []
    @State private var showSurprise = false
    
    // Card dimensions
    let cardWidth: CGFloat = 300
    let cardHeight: CGFloat = 180
    
    // Surprise reward
    let surpriseReward = "₹100 CASHBACK!"
    
    var body: some View {
        VStack {
            Text("Tap to flip, then scratch to reveal your surprise!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            ZStack {
                // Card content
                cardContent
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
            .frame(width: cardWidth, height: cardHeight)
            .onTapGesture {
                withAnimation(.spring()) {
                    isFlipped.toggle()
                }
            }
            
            if isFlipped && showSurprise {
                Text("Congratulations! You won \(surpriseReward)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.scale.combined(with: .opacity))
            }
            
            Button("Reset Card") {
                withAnimation {
                    isFlipped = false
                    scratchProgress = 0
                    scratchPoints = []
                    showSurprise = false
                }
            }
            .padding()
            .opacity(scratchProgress > 0.5 ? 1 : 0)
        }
    }
    
    var cardContent: some View {
        ZStack {
            // Front of card
            cardFront
                .opacity(isFlipped ? 0 : 1)
            
            // Back of card (with scratch area)
            cardBack
                .rotation3DEffect(
                    .degrees(180),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .opacity(isFlipped ? 1 : 0)
        }
    }
    
    var cardFront: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(radius: 5)
            
            VStack {
                HStack {
                    Text("REWARDS")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                
                Image(systemName: "gift.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Tap to reveal")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
    
    var cardBack: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
            
            // Surprise content (underneath scratch layer)
            VStack {
                Text(surpriseReward)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Image(systemName: "party.popper.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.orange)
            }
            
            // Scratch layer
            Canvas { context, size in
                // Draw the scratch layer
                context.fill(
                    Path(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 12),
                    with: .color(Color.gray.opacity(0.9))
                )
                
                // Draw patterns on scratch layer to make it look like a scratch card
                for x in stride(from: 5, to: size.width, by: 10) {
                    for y in stride(from: 5, to: size.height, by: 10) {
                        context.fill(
                            Path(ellipseIn: CGRect(x: x, y: y, width: 2, height: 2)),
                            with: .color(Color.black.opacity(0.3))
                        )
                    }
                }
                
                // Create eraser for scratch effect
                let eraser = GraphicsContext.Shading.color(.clear)
                context.blendMode = .clear
                
                // Apply scratch effect based on user's gestures
                for point in scratchPoints {
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - 20, y: point.y - 20, width: 40, height: 40)),
                        with: eraser
                    )
                }
                
                // Calculate scratch progress
                let totalPixels = size.width * size.height
                let scratchedPixels = CGFloat(scratchPoints.count) * (40 * 40 * .pi)
                let newProgress = min(scratchedPixels / totalPixels * 5, 1.0) // Multiplier to make it faster to reveal
                
                // Update scratch progress on main thread
                DispatchQueue.main.async {
                    scratchProgress = newProgress
                    if scratchProgress > 0.5 && !showSurprise {
                        withAnimation(.spring()) {
                            showSurprise = true
                        }
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let position = value.location
                        scratchPoints.append(position)
                    }
            )
            
            // Instructions
            if scratchProgress < 0.1 {
                Text("Scratch here to reveal")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Scratch Card Rewards")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            ScratchCardView()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

#Preview{
    ContentView()
}
