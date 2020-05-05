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

struct ContentView: View {

    // magic numbers galore
    @State private var backgroundOffsetY: CGFloat = 75
    @State private var backgroundOffsetX: CGFloat = -20
    @State private var foregroundOffsetY: CGFloat = 65
    @State private var foregroundOffsetX: CGFloat = -110
    
    var body: some View {
        return ZStack {
            Wave(graphWidth: 1, amplitude: 0.025, offset: 0)
                .foregroundColor(Color(red: 0, green: 0.68, blue: 0.85))
                .offset(x: backgroundOffsetX, y: backgroundOffsetY)
                .onAppear {
                        self.backgroundOffsetY = 70
                        self.backgroundOffsetX = 0
                }
                
            Wave(graphWidth: 1, amplitude: 0.03, offset: 0)
                .foregroundColor(Color(red: 0, green: 0.8, blue: 1))
                .offset(x: foregroundOffsetX, y: foregroundOffsetY)
                .onAppear {
                        self.foregroundOffsetY = 70
                        self.foregroundOffsetX = -75
                }
            
        }.animation(repeatingAnimation)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
