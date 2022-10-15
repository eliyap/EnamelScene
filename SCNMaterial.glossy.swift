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
        var material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.metalness.contents = UIColor.white
        material.metalness.intensity = 1.0
        material.roughness.intensity = 0
        return material
    }
}
