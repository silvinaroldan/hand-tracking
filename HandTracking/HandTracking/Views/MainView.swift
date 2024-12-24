//
//  ContentView.swift
//  HandTracking
//
//  Created by Silvina Roldan on 19/12/2024.
//

import SwiftUI

struct MainView: View {
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    @State var handsTrackingEnabled = false

    var body: some View {
        Button {
            handsTrackingEnabled.toggle()
            Task {
                if handsTrackingEnabled {
                    await openImmersiveSpace(id: "HandTrackingScene")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        } label: {
            Text(handsTrackingEnabled ? "Close hands detection" : "Open hands detection")
        }
    }
}

#Preview(windowStyle: .automatic) {
    MainView()
}
