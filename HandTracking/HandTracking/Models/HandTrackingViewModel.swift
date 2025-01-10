//
//  HandTrackingviewModel.swift
//  HandTracking
//
//  Created by Silvina Roldan on 22/12/2024.
//

import ARKit
import RealityKit
import RealityKitContent
import SwiftUI

@Observable
final class HandTrackingViewModel {
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()
    
    private var contentEntity = Entity()
    
    private var fingerEntities = [HandAnchor.Chirality: Entity]()
    
    func setupContentEntity() async -> Entity {
        fingerEntities[.right] = await createFingerTip()
        for entity in fingerEntities.values {
            await contentEntity.addChild(entity)
        }
        return contentEntity
    }
    
    func startARKitSession() async throws {
        let result = await session.requestAuthorization(for: [.handTracking])
        if let handAuthorization = result[.handTracking], handAuthorization == .allowed {
            try await session.run([handTracking])
        } else {
            print("ARKit is not supported or not authorized.")
        }
    }
    
    func removeEntities() {
        contentEntity.children.removeAll()
    }
    
    @MainActor func processHands() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .updated:
                
                let anchor = update.anchor
                guard anchor.isTracked else { continue }
                
                let fingerIndex = anchor.handSkeleton?.joint(.middleFingerIntermediateTip)
                guard (fingerIndex?.isTracked) != nil else { continue }
                
                let origin = anchor.originFromAnchorTransform
                
                let wristFromIndex = fingerIndex?.anchorFromJointTransform
                let originFromIndex = origin * wristFromIndex!
                
                fingerEntities[anchor.chirality]?.setTransformMatrix(originFromIndex, relativeTo: nil)
                
            default: ()
            }
        }
    }
    
    @MainActor
    private func createFingerTip() async -> Entity {
        let animScene = try! await Entity(named: "butterfly", in: realityKitContentBundle)
        
        animScene.components.set(PhysicsBodyComponent(mode: .kinematic))
        animScene.components.set(OpacityComponent(opacity: 1.0))
        
        if let animation = animScene.availableAnimations.first {
            animScene.playAnimation(animation.repeat())
        }

        return animScene
    }
}
