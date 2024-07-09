//
//  View.Extension.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/22/24.
//

import Foundation
import SwiftUI

// MARK: Hidden view
extension View {
    @ViewBuilder
    func isHidden(_ hidden: Bool, remove: Bool = false, animation: Animation = .default) -> some View {
        if hidden {
            if !remove {
                withAnimation(animation) {
                    self.hidden()
                }
            }
        } else {
            withAnimation(animation) {
                self
            }
        }
    }
}
