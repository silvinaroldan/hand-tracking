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
    private let fingerEntities: [HandAnchor.Chirality: ModelEntity] = [.left: .createFingerTip(), .right: .createFingerTip()]
    
    func setupContentEntity() -> Entity {
        for entity in fingerEntities.values {
            contentEntity.addChild(entity)
        }
        return contentEntity
    }

    func startARKitSession() async throws {
        let result = await session.requestAuthorization(for: [.handTracking])
        if let handAuthorization = result[.handTracking],
           handAuthorization == .allowed
        {
            try await session.run([handTracking])
        } else {
            print("ARKit is not supported or not authorized.")
        }
    }
    
    @MainActor func processHands() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
                case .added, .updated:
          
                    let anchor = update.anchor
                    guard anchor.isTracked else { continue }
                
                    let fingertip = anchor.handSkeleton?.joint(.indexFingerTip)
                    guard (fingertip?.isTracked) != nil else { continue }
                
                    let origin = anchor.originFromAnchorTransform
                    let wristFromIndex = fingertip?.anchorFromJointTransform
                    let originFromIndex = origin * wristFromIndex!
                
                    fingerEntities[anchor.chirality]?.setTransformMatrix(originFromIndex, relativeTo: nil)
                    
                    
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
