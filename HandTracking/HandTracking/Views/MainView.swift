//
//  ContentView.swift
//  HandTracking
//
//  Created by Silvina Roldan on 19/12/2024.
//

import SwiftUI


struct MainView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        
        Button("Enable Hand Tracking") {
            Task {
                await openImmersiveSpace(id: "HandTrackingScene")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    MainView()
}
