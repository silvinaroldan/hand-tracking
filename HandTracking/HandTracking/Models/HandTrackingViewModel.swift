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
    
    let session = ARKitSession()
    let handProvider = HandTrackingProvider()
    
    let contentEntity = Entity()
    
    func startARKitSession() async throws {
        let result = await session.requestAuthorization(for: [.handTracking])
        if let handAuthorization = result[.handTracking],
           handAuthorization == .allowed {
            try await session.run([handProvider])
        } else {
            print("ARKit is not supported or not authorized.")
        }
    }
    
    @MainActor func processHands() async {
        for await update in handProvider.anchorUpdates {
            switch update.event {
                case .added, .updated:
          
                let anchor = update.anchor
                guard anchor.isTracked else { continue }
                
                let handPart = anchor.handSkeleton?.joint(.ringFingerIntermediateBase)
                guard ((handPart?.isTracked) != nil) else { continue }
                
                let origin = anchor.originFromAnchorTransform
                let wristFromIndex = handPart?.anchorFromJointTransform
                let originFromIndex = origin * wristFromIndex!
                
                // Maybe is more performant to load the entity in reality composer pro package
                let entity = try! await Entity(named: "ball")
              
                entity.setTransformMatrix(originFromIndex, relativeTo: nil)
                contentEntity.addChild(entity)
                default: ()
            }
        }
    }
    
    
//    func updateHandEntity(anchor: HandAnchor) {
//        guard anchor.isTracked,
//              let skeleton = anchor.handSkeleton else { return }
//        for joint in skeleton.allJoints {
//            let name = "\(anchor.chirality.description)\(joint.name)"
//         //   print(name + "\n")
//         //   let name = HandSkeleton.JointName.middleFingerMetacarpal
//            if let entity = contentEntity.findEntity(named: name) {
//                if joint.isTracked {
//                    entity.setTransformMatrix(anchor.originFromAnchorTransform * joint.anchorFromJointTransform, relativeTo: nil)
//                    entity.isEnabled = true
//                } else {
//                    entity.isEnabled = false
//                }
//            } else {
//                guard joint.isTracked else { continue }
//               //let entity = ModelEntity(mesh: .generateBox(size: 0.01, cornerRadius: 0.02),
//     //                                    materials: [SimpleMaterial(color: .purple, isMetallic: false)])
//                let entity = try! Entity.load(named: "ball")
//                entity.name = name
//                entity.setTransformMatrix(anchor.originFromAnchorTransform * joint.anchorFromJointTransform, relativeTo: nil)
//                contentEntity.addChild(entity)
//            }
//        }
//    }
}
