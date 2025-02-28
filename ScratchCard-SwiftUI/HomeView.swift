//
//  HomeView.swift
//  ScratchCard-SwiftUI
//
//  Created by MacMini6 on 28/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // App title and icon
                    VStack(spacing: 10) {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("Scratch & Win")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    // Information card
                    VStack(alignment: .leading, spacing: 15) {
                        Text("How to Play")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        InfoRow(icon: "hand.draw.fill", text: "Scratch the card with your finger")
                        InfoRow(icon: "dollarsign.circle.fill", text: "Reveal matching symbols to win")
                        InfoRow(icon: "gift.fill", text: "Each card has different prizes!")
                        
                        Text("Try both of our exciting scratch card games and test your luck!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 5)
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Navigation cards
                    VStack(spacing: 20) {
                        NavigationLink(destination: ContentView()) {
                            GameCard(
                                title: "Classic Scratch",
                                description: "Traditional scratch card with cash prizes",
                                systemImage: "banknote.fill",
                                color: .green
                            )
                        }
                        
                        NavigationLink(destination: ScratchView()) {
                            GameCard(
                                title: "Lucky Symbols",
                                description: "Match symbols to win exciting rewards",
                                systemImage: "star.fill",
                                color: .orange
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Supporting views
struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 18))
            
            Text(text)
                .font(.body)
        }
    }
}

struct GameCard: View {
    let title: String
    let description: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Spacer()
            
            Image(systemName: systemImage)
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.gradient)
                .shadow(radius: 5)
        )
    }
}

#Preview {
    HomeView()
}
