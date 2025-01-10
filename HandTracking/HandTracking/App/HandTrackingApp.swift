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
        .windowResizability(.contentSize)
        
        ImmersiveSpace(id: "HandTrackingScene") {
            HandTrackingView()
        }
    }
}
