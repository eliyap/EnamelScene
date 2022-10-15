//
//  SCNMaterial.glossy.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 14/10/22.
//

import SceneKit

extension SCNMaterial {
    /// A "glossy" material that reflects an area light's edges.
    static func glossy() -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.roughness.intensity = 0
        return material
    }
}
