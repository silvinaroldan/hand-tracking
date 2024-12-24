//
//  HandTrackingApp.swift
//  HandTracking
//
//  Created by Silvina Roldan on 19/12/2024.
//

import SwiftUI

@main
struct HandTrackingApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .defaultSize(width: 0.3, height: 0.35, depth: 0.0, in: .meters)
        
        ImmersiveSpace(id: "HandTrackingScene") {
            HandTrackingView()
        }
    }
}
