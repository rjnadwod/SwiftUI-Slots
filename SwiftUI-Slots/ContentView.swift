//
//  ContentView.swift
//  SwiftUI-Slots
//
//  Created by Riley Nadwodny on 1/8/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userCredits = 1000
    @State private var symbols = ["apple", "star", "cherry"]
    @State private var numbers = Array(repeating: 0, count: 9)
    @State private var backgrounds = Array(repeating: Color.white, count: 9)
    private var betAmount = 5
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(red: 200/255, green: 143/255, blue: 32/255))
                .ignoresSafeArea()
            Rectangle()
                .foregroundColor(Color(red: 288/255, green: 195/255, blue: 76/255))
                .rotationEffect(Angle(degrees:45))
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text("SwiftUI Slots!")
                        .bold()
                        .foregroundColor(.white)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }.scaleEffect(2)
                
                Spacer()
                
                Text("Credits: \(userCredits)")
                    .foregroundColor(.black)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[0]], background: $backgrounds[0])
                        CardView(symbol: $symbols[numbers[1]], background: $backgrounds[1])
                        CardView(symbol: $symbols[numbers[2]], background: $backgrounds[2])
                        
                        Spacer()
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[3]], background: $backgrounds[3])
                        CardView(symbol: $symbols[numbers[4]], background: $backgrounds[4])
                        CardView(symbol: $symbols[numbers[5]], background: $backgrounds[5])
                        
                        Spacer()
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                    
                    HStack {
                        Spacer()
                        
                        CardView(symbol: $symbols[numbers[6]], background: $backgrounds[6])
                        CardView(symbol: $symbols[numbers[7]], background: $backgrounds[7])
                        CardView(symbol: $symbols[numbers[8]], background: $backgrounds[8])
                        
                        Spacer()
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            
                            //Process a single spin
                            self.processResults()
                            
                        }, label: {
                            Text("Spin")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .frame(width: 120.0, height: 40.0)
                                .background(Color.red)
                                .cornerRadius(24.0)
                           })
                        Text("\(betAmount) Credits")
                            .padding(.top, 10)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            
                            //Process max spin
                            self.processResults(true)
                            
                        }, label: {
                            Text("Max Spin")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .frame(width: 120.0, height: 40.0)
                                .background(Color.red)
                                .cornerRadius(24.0)
                        })
                        Text("\(betAmount * 5) Credits")
                            .padding(.top, 10)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                }
                Spacer()
                }
            }
        }
    
    func processResults( _ isMax:Bool = false) {
        //Set backgrounds to white using map
        self.backgrounds = self.backgrounds.map({ _ in Color.white})
        
        if isMax {
            //Spin all cards
            //Change all images using map
            self.numbers = self.numbers.map({ _ in Int.random(in: 0...self.symbols.count - 1)})
        }
        else {
            //Spin the middle row
            //Change images in the middle row
            self.numbers[3] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[4] = Int.random(in: 0...self.symbols.count - 1)
            self.numbers[5] = Int.random(in: 0...self.symbols.count - 1)
        }
        
        //Check winnings
        processWin(isMax)
    }
    
    func isMatch(_ index1:Int, _ index2:Int, _ index3:Int) -> Bool {
        if self.numbers[index1] == self.numbers[index2] && self.numbers[index2] == self.numbers[index3] {
            
            self.backgrounds[index1] = Color.green
            self.backgrounds[index2] = Color.green
            self.backgrounds[index3] = Color.green
            
            return true
        }
        
        return false;
    }
    
    func processWin(_ isMax:Bool = false) {
        
        var matches = 0
        
        if !isMax {
            //Process for single spin
            //Check to see if user wins
            if isMatch(3, 4, 5) {matches += 1}
            else {
                userCredits -= betAmount
            }
        }
        else {
            //Processing for max spin
            
            //Top row
            if isMatch(0, 1, 2) {matches += 1}
            
            //Middle row
            if isMatch(3, 4, 5) {matches += 1}
            
            //Bottom row
            if isMatch(6, 7, 8) {matches += 1}
            
            //Diagonal top left to bottom right
            if isMatch(0, 4, 8) {matches += 1}
            
            //Diagontal top right to bottom left
            if isMatch(2, 4, 6) {matches += 1}
            
            //Check matches and distribute credits
            if matches > 0 {
                //At least 1 win
                self.userCredits += matches * betAmount * 2
            }
            else if !isMax {
                //0 wins, single spin
                self.userCredits -= betAmount
            }
            else {
                //0 wins, max spin
                self.userCredits -= betAmount * 5
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
