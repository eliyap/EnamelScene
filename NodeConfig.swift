//
//  NodeConfig.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 14/10/22.
//

import Foundation
import UIKit
import SceneKit

struct NodeConfig {
    let symbol: NSString                        /// SF Symbol to draw.
    let fontName: String                        /// Variant of San Francisco font to use.
    
    let color: UIColor                          /// Node fill color.
    let scale: CGFloat                          /// Node size.
    let extrusionDepth: CGFloat
    var position = SCNVector3(x: 0, y: 0, z: 0) /// Node offset.
    let flatness: CGFloat                       /// Lower = more detail.
    let chamferRadius: CGFloat
    let material: () -> SCNMaterial
    var castsShadow = false
}
