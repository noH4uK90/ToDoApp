//
//  Slider.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/9/24.
//

import SwiftUI

struct Slider: View {
    @Binding var sliderProgress: CGFloat
    @Binding var tint: Color
    
    @State private var progress: CGFloat = .zero
    @State private var dragOffset: CGFloat = .zero
    @State private var lastDragOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { reader in
            let size = reader.size
            let height = size.height
            let progressValue = (max(progress, .zero)) * height
            
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.fill)
                
                Rectangle()
                    .fill(tint.opacity(progress))
                    .frame(height: progressValue)
                
                Image(systemName: "sun.max.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.title)
                    .padding(20)
                    .frame(width: size.width, height: size.height, alignment: .bottom)
            }
            .clipShape(.rect(cornerRadius: 15))
            .contentShape(.rect(cornerRadius: 15))
            .optionalSizingModifiers(size: size, progress: progress, height: height)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        let translation = val.translation
                        let movement = -translation.height + lastDragOffset
                        dragOffset = movement
                        calculateProgress(height: height)
                    }
                    .onEnded { _ in
                        withAnimation(.smooth) {
                            dragOffset = dragOffset > height ? height : (dragOffset < 0 ? 0 : dragOffset)
                            calculateProgress(height: height)
                        }
                        
                        lastDragOffset = dragOffset
                    }
            )
            .frame(
                maxWidth: size.width,
                maxHeight: size.height,
                alignment: progress < 0 ? .top : .bottom
            )
            .onChange(of: sliderProgress, initial: true) { oldValue, newValue in
                guard sliderProgress != progress, (sliderProgress > 0 && sliderProgress < 1) else { return }
                progress = max(min(sliderProgress, 1.0), .zero)
                dragOffset = progress * height
                lastDragOffset = dragOffset
            }
        }
        .frame(width: 60, height: 180)
        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 10)
        .onChange(of: progress) { oldValue, newValue in
            sliderProgress = max(min(progress, 1.0), .zero)
        }
    }
    
    private func calculateProgress(height: CGFloat) {
        let topExcessOffset = height + (dragOffset - height) * 0.1
        let bottomExcessOffset = dragOffset < 0 ? (dragOffset * 0.1) : dragOffset
        let progress = (dragOffset > height ? topExcessOffset : bottomExcessOffset) / height
        self.progress = progress
    }
}

fileprivate extension View {
    @ViewBuilder
    func optionalSizingModifiers(size: CGSize, progress: CGFloat, height: CGFloat) -> some View {
        self
            .frame(
                height: progress < 0 ? size.height + (-progress * size.height) : nil
            )
    }
}

#Preview {
    Slider(sliderProgress: Binding<CGFloat>.constant(0.999), tint: Binding<Color>.constant(.blue))
}
