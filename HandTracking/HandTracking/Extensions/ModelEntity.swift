//
//  ModelEntity.swift
//  HandTracking
//
//  Created by Silvina Roldan on 26/12/2024.
//

import Foundation
import RealityKit

extension ModelEntity {
    
    class func createFingerTip() -> ModelEntity {
        let entity = ModelEntity(mesh: .generateSphere(radius: 0.01),
                                 materials: [UnlitMaterial(color: .cyan)],
                                 collisionShape: .generateSphere(radius: 0.005),
                                 mass: 0.1)
        
        entity.components.set(PhysicsBodyComponent(mode: .kinematic))
        entity.components.set(OpacityComponent(opacity: 1.0))
        return entity
    }
}
