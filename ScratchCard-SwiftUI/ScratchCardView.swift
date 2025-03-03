import SwiftUI

struct ScratchView: View {
    @State private var isFlipped = false
    @State private var scratchProgress: CGFloat = 0
    @State private var scratchPoints: [CGPoint] = []
    @State private var showSurprise = false
    @State private var isCardAnimating = false
    @State private var confettiCounter = 0
    @State private var rewardAmount = ""
    @State private var rewardOptions = ["₹50", "₹100", "₹150", "₹200", "₹500"]
    
    // Card dimensions
    let cardWidth: CGFloat = 300
    let cardHeight: CGFloat = 200
    
    // Colors
    let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "FF6B6B"), Color(hex: "FF9E80")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    let backCardGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "4568DC"), Color(hex: "B06AB3")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Animation properties
    let springAnimation = Animation.spring(response: 0.6, dampingFraction: 0.7)
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "F0F4F8")
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header
                Text("Scratch & Win!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "4568DC"), Color(hex: "B06AB3")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.top)
                
                // Card container with shadow and pulse animation
                ZStack {
                    // Animated glow effect
                    Circle()
                        .fill(Color(hex: "FF9E80").opacity(0.3))
                        .frame(width: cardWidth * 1.2, height: cardHeight * 1.2)
                        .blur(radius: 20)
                        .scaleEffect(isCardAnimating ? 1.1 : 0.9)
                        .opacity(isFlipped ? 0 : 1)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isCardAnimating)
                        .onAppear {
                            isCardAnimating = true
                        }
                    
                    // Card content
                    cardContent
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .animation(springAnimation, value: isFlipped)
                }
                .padding(.horizontal)
                
                .frame(width: cardWidth, height: cardHeight)
                .onTapGesture {
                    if !isFlipped {
                        playHapticFeedback()
                        withAnimation {
                            isFlipped.toggle()
                            // Randomly select a reward when card is flipped
                            rewardAmount = rewardOptions.randomElement() ?? "₹100"
                        }
                    }
                }
                
                // Instructions
                Text(isFlipped ? "Scratch to reveal your reward!" : "Tap the card to flip")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "556B7F"))
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: isFlipped)
                
                if isFlipped && showSurprise {
                    // Reward announcement
                    VStack(spacing: 15) {
                        Text("🎉 Congratulations! 🎉")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "4568DC"))
                        
                        Text("You won \(rewardAmount) CASHBACK!")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "FF6B6B"), Color(hex: "FF9E80")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .padding(.bottom, 5)
                        
                        // CTA Button
                        Button(action: {
                            // Action for claiming reward
                        }) {
                            Text("Claim Now")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "4568DC"), Color(hex: "B06AB3")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: Color(hex: "4568DC").opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(), value: showSurprise)
                }
                
                // Reset button
                if scratchProgress > 0.5 {
                    Button(action: {
                        playHapticFeedback()
                        withAnimation {
                            isFlipped = false
                            scratchProgress = 0
                            scratchPoints = []
                            showSurprise = false
                            confettiCounter += 1
                        }
                    }) {
                        Text("Try Again")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "556B7F"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .stroke(Color(hex: "556B7F"), lineWidth: 1.5)
                            )
                    }
                    .transition(.opacity)
                    .animation(.easeIn, value: scratchProgress > 0.5)
                    .padding(.top)
                }
                
                Spacer()
            }
            .padding()
            
            // Confetti effect when prize is revealed
            if showSurprise {
                ConfettiView(counter: confettiCounter)
            }
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
            RoundedRectangle(cornerRadius: 20)
                .fill(cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .blendMode(.overlay)
                )
                .shadow(color: Color(hex: "FF6B6B").opacity(0.5), radius: 15, x: 0, y: 10)
            
            // Card content
            VStack {
                HStack {
                    // Logo area
                    HStack(spacing: 5) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("REWARDS")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Center graphic
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "gift.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                
                Spacer()
                
                // Bottom text
                Text("Tap to reveal your surprise")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            
            // Decorative elements
            ForEach(0..<8) { i in
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 10, height: 10)
                    .offset(x: offsetFor(index: i, radius: cardWidth * 0.4).width,
                            y: offsetFor(index: i, radius: cardHeight * 0.4).height)
            }
        }
    }
    
    var cardBack: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(backCardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .blendMode(.overlay)
                )
                .shadow(color: Color(hex: "4568DC").opacity(0.5), radius: 15, x: 0, y: 10)
            
            // Scratch underlay (Reward content)
            VStack(spacing: 10) {
                Image(systemName: "crown.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                
                Text(rewardAmount)
                    .font(.system(size: 40, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                
                Text("CASHBACK")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
            
            // Scratch layer
            Canvas { context, size in
                // Draw the scratch layer with pattern
                context.fill(
                    Path(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 20),
                    with: .linearGradient(
                        Gradient(colors: [Color(hex: "808080"), Color(hex: "A0A0A0")]),
                        startPoint: CGPoint(x: 0, y: 0),
                        endPoint: CGPoint(x: size.width, y: size.height)
                    )
                )
                
                // Draw scratch pattern
                for x in stride(from: 0, to: size.width, by: 10) {
                    for y in stride(from: 0, to: size.height, by: 10) {
                        if (Int(x) + Int(y)) % 2 == 0 {
                            context.fill(
                                Path(ellipseIn: CGRect(x: x, y: y, width: 3, height: 3)),
                                with: .color(Color.white.opacity(0.2))
                            )
                        }
                    }
                }
                
                // Create eraser for scratch effect
                context.blendMode = .clear
                
                // Apply scratch effect based on user's gestures
                for point in scratchPoints {
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - 25, y: point.y - 25, width: 50, height: 50)),
                        with: .color(.clear)
                    )
                }
                
                // Calculate scratch progress
                let totalPixels = size.width * size.height
                let scratchedPixels = CGFloat(scratchPoints.count) * (50 * 50 * .pi)
                let newProgress = min(scratchedPixels / totalPixels * 4, 1.0) // Multiplier for faster reveal
                
                // Update scratch progress
                DispatchQueue.main.async {
                    scratchProgress = newProgress
                    if scratchProgress > 0.5 && !showSurprise {
                        playHapticFeedback(style: .heavy)
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
                        playHapticFeedback(style: .heavy)
                    }
            )
            
            // Scratch instructions
            if scratchProgress < 0.1 {
                VStack {
                    Image(systemName: "hand.draw.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    
                    Text("Scratch here")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                }
                .transition(.opacity)
                .animation(.easeOut, value: scratchProgress < 0.1)
            }
        }
    }
    
    // Helper to calculate positions in a circle
    func offsetFor(index: Int, radius: CGFloat) -> CGSize {
        let angle = Double(index) * (360.0 / 8.0) * .pi / 180.0
        return CGSize(
            width: radius * CGFloat(cos(angle)),
            height: radius * CGFloat(sin(angle))
        )
    }
    
    // Haptic feedback function
    func playHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

// Confetti View
struct ConfettiView: View {
    let counter: Int
    let colors: [Color] = [
        Color(hex: "FF6B6B"), Color(hex: "4568DC"),
        Color(hex: "B06AB3"), Color(hex: "FF9E80"),
        Color.yellow, Color.green
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<100, id: \.self) { i in
                ConfettiPiece(counter: counter, index: i, colors: colors)
            }
        }
    }
}

struct ConfettiPiece: View {
    let counter: Int
    let index: Int
    let colors: [Color]
    
    @State private var xPosition: CGFloat = 0
    @State private var yPosition: CGFloat = -400
    @State private var rotation: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(colors[index % colors.count])
            .frame(width: randomSize(), height: randomSize() * 0.2)
            .position(x: xPosition, y: yPosition)
            .rotationEffect(.degrees(rotation))
            .opacity(yPosition > 300 ? 0 : 1)
            .onAppear {
                withAnimation(.none) {
                    xPosition = CGFloat.random(in: 0..<UIScreen.main.bounds.width)
                    yPosition = -100 - CGFloat.random(in: 0..<300)
                    rotation = Double.random(in: 0..<360)
                }
                
                withAnimation(Animation.linear(duration: randomDuration()).delay(randomDelay())) {
                    yPosition = 700 + CGFloat.random(in: 0..<300)
                    rotation += Double.random(in: 180..<360)
                }
            }
            .id("\(counter)-\(index)")
    }
    
    // Helper functions
    func randomSize() -> CGFloat {
        return CGFloat.random(in: 5..<15)
    }
    
    func randomDuration() -> Double {
        return Double.random(in: 2..<4)
    }
    
    func randomDelay() -> Double {
        return Double.random(in: 0..<0.5)
    }
}

// Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview
struct ScratchCardApp: View {
    var body: some View {
        ScratchView()
    }
}

struct ScratchCardApp_Previews: PreviewProvider {
    static var previews: some View {
        ScratchCardApp()
    }
}
