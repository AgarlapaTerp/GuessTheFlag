//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by user256510 on 2/22/24.
//

import SwiftUI

struct Flag: View {
    let countryName:String
    
    var body: some View {
        Image(countryName)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 5)
    }
}

struct BlueFont: ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
    
    
}

struct FlagAnimation: ViewModifier {
    let correctAns: Int
    let actualAns: Int
    let amount: Double
    let opacity: Double
    func body(content: Content) -> some View {
        if correctAns == actualAns{
            content
                .rotation3DEffect(
                    .degrees(amount),
                                          axis: (x: 0.0, y: 1.0, z: 0.0)
                )
        }
        else {
            content
                .scaleEffect(opacity)
        }
        
    }
}

extension View{
    func blueFont() -> some View {
        modifier(BlueFont())
    }
    
    func flagAnimation(correct:Int, actual:Int, amnt:Double, opacity: Double) -> some View {
        modifier(FlagAnimation(correctAns: correct, actualAns: actual, amount: amnt, opacity: opacity))
    }
}

struct ContentView: View {
    let maxRounds = 7
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    let labels = [
        "Estonia": "horizontal stripes. Blue, then black, then white",
        "France": "vertical stripes. blue, white, red",
        "Germany": "horizontal stripes. black, then red, then gold",
        "Ireland": "three vertical stripes. green, white, orange",
        "Italy": "three vertical stripes. green, white, then red",
        "Nigeria": "three vertical stripes. green, white, green",
        "Poland": "two horizontal stripes. white, then red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner.",
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 1
    @State private var restart = false
    
    
    @State private var spin = 0.0
    @State private var opacity = 1.0
    @State private var flag = -1
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue,.cyan], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .blueFont()
                Text("Round \(round)")
                    .foregroundStyle(.white)
                    .font(.title.weight(.bold))
                
                VStack(spacing:15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        }label: {
                            Flag(countryName: countries[number])
                                .flagAnimation(correct: flag, actual: number, amnt: spin, opacity: opacity)
                                .accessibilityLabel(labels[countries[number]] ?? "an ambigous flag")
//                                .modifier(FlagAnimation(correctAns: flag, actualAns: number, amount: spin, opacity: opacity))
//                                .animation(.default, value: spin)
                                
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thickMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            .padding()
        }
        .alert("Restart? Final Score is \(score)", isPresented: $restart){
            Button("Yes", role:.cancel,action: resetGame)
            Button("No", role:.destructive) { 
                //not sure how to end game
            }
        }
    }
    
    func flagTapped(_ number: Int){
        
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
                        
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            
            
        }
        
        showingScore = true
        flag = number
        
        withAnimation {
            spin += 360.0
            opacity = 0.0
        } completion: {
            askQuestion()
            opacity = 1.0
        }

        
        if round > maxRounds{
            restart = true
        }
        
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        round += 1
        flag = -1
        
    }
    
    func resetGame() {
        round = 1
        score = 0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

#Preview {
    ContentView()
}
