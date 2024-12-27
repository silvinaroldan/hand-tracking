//
//  HandTrackingView.swift
//  HandTracking
//
//  Created by Silvina Roldan on 19/12/2024.
//

import ARKit
import RealityKit
import SwiftUI

struct HandTrackingView: View {
    @State private var vm = HandTrackingViewModel()

    var body: some View {
        RealityView { content in
            await content.add(vm.setupContentEntity())
        }
        .task {
            do {
                try await vm.startARKitSession()
            } catch {
                print("Error \(error)")
            }
        }
        .task(priority: .low) {
            await vm.processHands()
        }
    }
}
