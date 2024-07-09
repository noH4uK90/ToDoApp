//
//  ColorPicker.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/9/24.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var selectionColor: Color
    @Binding var brightness: CGFloat
    
    @State private var startLocation: CGPoint? = .zero
    @State private var location: CGPoint? = .zero
    
    let radius: CGFloat = 100
    var diameter: CGFloat {
        radius * 2
    }
    
    var body: some View {
        picker
    }
    
    var picker: some View {
        GeometryReader { reader in
            ZStack {
                Circle()
                    .fill(
                        AngularGradient(gradient: Gradient(colors: [
                            Color(hue: 1.0, saturation: 1, brightness: brightness),
                            Color(hue: 0.9, saturation: 1, brightness: brightness),
                            Color(hue: 0.8, saturation: 1, brightness: brightness),
                            Color(hue: 0.7, saturation: 1, brightness: brightness),
                            Color(hue: 0.6, saturation: 1, brightness: brightness),
                            Color(hue: 0.5, saturation: 1, brightness: brightness),
                            Color(hue: 0.4, saturation: 1, brightness: brightness),
                            Color(hue: 0.3, saturation: 1, brightness: brightness),
                            Color(hue: 0.2, saturation: 1, brightness: brightness),
                            Color(hue: 0.1, saturation: 1, brightness: brightness),
                            Color(hue: 0.0, saturation: 1, brightness: brightness),
                        ]), center: .center)
                    )
                    .frame(width: diameter, height: diameter)
                    .overlay(
                        Circle()
                            .fill(
                                RadialGradient(gradient: Gradient(colors: [
                                    .white.opacity(0.5),
                                    .white.opacity(0.000001)
                                ]), center: .center, startRadius: 0, endRadius: radius)
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 8)
                    .gesture(dragGesture(in: reader.size))
                
                if startLocation != nil {
                
                    Circle()
                        .frame(width: 20, height: 20)
                        .position(location!)
                        .foregroundStyle(selectionColor)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color(hue: 1.0, saturation: 1, brightness: 1),
                                    Color(hue: 0.9, saturation: 1, brightness: 1),
                                    Color(hue: 0.8, saturation: 1, brightness: 1),
                                    Color(hue: 0.7, saturation: 1, brightness: 1),
                                    Color(hue: 0.6, saturation: 1, brightness: 1),
                                    Color(hue: 0.5, saturation: 1, brightness: 1),
                                    Color(hue: 0.4, saturation: 1, brightness: 1),
                                    Color(hue: 0.3, saturation: 1, brightness: 1),
                                    Color(hue: 0.2, saturation: 1, brightness: 1),
                                    Color(hue: 0.1, saturation: 1, brightness: 1),
                                    Color(hue: 0.0, saturation: 1, brightness: 1),
                                ]),
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 30, height: 30)
                        .position(location!)
                }
            }
            .onAppear {
                startLocation = CGPoint(x: reader.size.width / 2, y: reader.size.height / 2)
                location = startLocation
            }
        }
        .frame(maxWidth: diameter, maxHeight: diameter)
        .background(.white)
    }
    
    func dragGesture(in size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { val in
                let distanceX = val.location.x - startLocation!.x
                let distanceY = val.location.y - startLocation!.y
                
                let dir = CGPoint(x: distanceX, y: distanceY)
                var distance = sqrt(distanceX * distanceX + distanceY * distanceY)
                
                if distance < radius {
                    location = val.location
                } else {
                    let clampedX = dir.x / distance * radius
                    let clampedY = dir.y / distance * radius
                    location = CGPoint(
                        x: startLocation!.x + clampedX,
                        y: startLocation!.y + clampedY
                    )
                    distance = radius
                }
                
                if distance == 0 {
                    return
                }
                
                var angle = Angle(radians: -Double(atan(dir.y / dir.x)))
                if dir.x < 0 {
                    angle.degrees += 180
                } else if dir.x > 0 && dir.y > 0 {
                    angle.degrees += 360
                }
                
                let hue = angle.degrees / 360
                let saturation = Double(distance / radius)
                selectionColor = Color(hue: hue, saturation: saturation, brightness: brightness)
            }
    }
}

#Preview {
    ColorPicker(selectionColor: Binding<Color>.constant(.white), brightness: Binding<CGFloat>.constant(0.5))
}
