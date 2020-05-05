//
//  ContentView.swift
//  DihydrogenMonoxideMonitor
//
//  Created by ariez on 30.04.20.
//  Code copied + adapted from https://medium.com/flawless-app-stories/fast-app-prototyping-with-swiftui-39ae03ab3eaa

import SwiftUI

struct Wave: Shape {
    let graphWidth: CGFloat
    let amplitude: CGFloat
    let offset: CGFloat
    
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width * 1.3
        let height = rect.height

        let origin = CGPoint(x: 0, y: height * 0.50)

        var path = Path()
        path.move(to: origin)

        var endY: CGFloat = 0.0
        let step = 5.0
        for pos in stride(from: 0, through: Double(width) * (step * step), by: step) {
            let x = origin.x + CGFloat((pos + Double(offset))/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin((pos + Double(offset))/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
            endY = y
        }
        path.addLine(to: CGPoint(x: width, y: endY))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: origin.y))

        return path
    }
}

private var repeatingAnimation: Animation {
    Animation
        .easeInOut
        .speed(0.1)
        .repeatForever()
}

struct WavesBg: View {
    // magic numbers galore
    @State private var backgroundOffsetY1: CGFloat = 75
    @State private var backgroundOffsetY2: CGFloat = 60
    
    @State private var backgroundOffsetX1: CGFloat = -20
    @State private var backgroundOffsetX2: CGFloat = 10
    
    @State private var foregroundOffsetY1: CGFloat = 65
    @State private var foregroundOffsetY2: CGFloat = 75
    
    @State private var foregroundOffsetX1: CGFloat = -90
    @State private var foregroundOffsetX2: CGFloat = -115
    
    var body: some View {
        return ZStack {
                Wave(graphWidth: 1, amplitude: 0.1, offset: 0)
                    .foregroundColor(Color(red: 0, green: 0.68, blue: 0.85))
                    .offset(x: backgroundOffsetX1, y: backgroundOffsetY1)
                    .onAppear {
                        self.backgroundOffsetY1 = self.backgroundOffsetY2
                        self.backgroundOffsetX1 = self.backgroundOffsetX2
                    }.frame(width: UIScreen.main.bounds.size.width, height: 200)
                    
                Wave(graphWidth: 1, amplitude: 0.15, offset: 0)
                    .foregroundColor(Color(red: 0, green: 0.8, blue: 1))
                    .offset(x: foregroundOffsetX1, y: foregroundOffsetY1)
                    .onAppear {
                        self.foregroundOffsetY1 = self.foregroundOffsetY2
                        self.foregroundOffsetX1 = self.foregroundOffsetX2
                }.frame(width: UIScreen.main.bounds.size.width, height: 200)
                
            }.animation(repeatingAnimation)
        }
}

struct DrinkButton: View {
    var text: String
    var action: () -> Void
    var body: some View {
        Button(action: {
            withAnimation { self.action() }
        }) {
            HStack(spacing: 20) {
                Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                Text(text)
                .font(.system(size: 30, design: .rounded))
            }
            .accentColor(Color.white.opacity(0.8))
        }
        .frame(width: 180, height: 70)
        .background(Color.black.opacity(0.5))
        .cornerRadius(420.69)
    }
}

struct ContentView: View {
    @State private var drank: CGFloat = 0
    var step: CGFloat = 10
    
    var body: some View {
        return ZStack {
            VStack {
                WavesBg()
                
                Rectangle()
                .frame(width: UIScreen.main.bounds.size.width, height: drank)
                    .foregroundColor(Color(red: 0, green: 0.8, blue: 1))
            }
            
            DrinkButton(text: String(Int(step)) + "ml") {
                self.drank += CGFloat(self.step)
                print("8=✊=D" + String(repeating: "💦", count: Int(self.drank/self.step)))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
