//
//  GameViewController.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 13/10/22.
//

import UIKit
import SceneKit
import CoreText

class GameViewController: UIViewController {

    var sceneView: SCNView!
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = view as! SCNView
        self.scene = SCNScene(named: "MainScene.scn")!
        sceneView.scene = scene

        if let borderNode = borderNode(symbol: "􀣋") {
            scene.rootNode.addChildNode(borderNode)
        }
        if let colorNode = colorNode(symbol: "􀣌") {
            scene.rootNode.addChildNode(colorNode)
        }
        if let speechNode = speechNode(symbol: "􀌩") {
            scene.rootNode.addChildNode(speechNode)
        }
        if let speechBorderNode = speechBorderNode(symbol: "􀌨") {
            scene.rootNode.addChildNode(speechBorderNode)
        }
        
        let plane = SCNPlane(width: 3, height: 3)
        let material = SCNMaterial()
        if plane.materials.isEmpty {
            plane.insertMaterial(material, at: 0)
        } else {
            plane.materials[0] = material
        }
        material.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: plane)
        node.position = .init(x: 0, y: 0, z: -0.4)
        scene.rootNode.addChildNode(node)
        

        initAmbientLight()
//        initDirectionalLight()
        initAreaLight(intensity: 2000)
        initCamera()
    }
    
    func initAmbientLight() {
        let light = SCNLight()
        light.type = .ambient
        light.intensity = 100
        light.temperature = CGFloat(7000)
//        light.shadowRadius = 0

        let lightNode = SCNNode()
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)
    }
    
    func initDirectionalLight() {
        let light = SCNLight()
        light.type = .directional
        light.spotInnerAngle = 10
        light.spotOuterAngle = 145
        light.intensity = 1000
        light.temperature = CGFloat(7000)
        
        /// Defaults to `false`, set `true` to cast shadows.
        light.castsShadow = true
        light.shadowMode = .forward
        light.shadowSampleCount = 512
        light.shadowBias = 7.0
        light.shadowRadius = 75

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 0, z: 1)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func initAreaLight(intensity: CGFloat) {
        let width: CGFloat = 10
        let height: CGFloat = 5
        
        let light = SCNLight()
        light.type = .area
        light.areaType = .polygon
        light.areaPolygonVertices = [
            NSValue(cgPoint: CGPoint(x: -width/2, y: 0)),
            NSValue(cgPoint: CGPoint(x: +width/2, y: 0)),
            NSValue(cgPoint: CGPoint(x: +width/2, y: height)),
            NSValue(cgPoint: CGPoint(x: -width/2, y: height)),
        ]
        light.intensity = intensity
        light.temperature = CGFloat(7000)
        light.castsShadow = false

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 0, z: 1)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func initCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        cameraNode.position = SCNVector3(0, 0, 5)
    }
    
    func borderNode(symbol: NSString) -> SCNNode? {
        let config = NodeConfig(
            symbol: "􀣋",
            fontName: "SFPro-Regular",
            color: .black,
            scale: 1,
            extrusionDepth: 0.2,
            flatness: 0.015,
            chamferRadius: 0.1,
            material: { .glossy() },
            category: (1 << 1)
        )
        
        return symbolNode(config: config)
    }
    
    func colorNode(symbol: NSString) -> SCNNode? {
        let config = NodeConfig(
            symbol: "􀣌",
            fontName: "SFPro-Regular",
            color: UIColor(red: 69.0/256, green: 148.0/256, blue: 233.0/256, alpha: 1),
            scale: 1,
            extrusionDepth: 0.15,
            flatness: 0.05,
            chamferRadius: 0,
            material: { .glossy() },
            category: (1 << 1)
        )
        
        return symbolNode(config: config)
    }
    
    func speechBorderNode(symbol: NSString) -> SCNNode? {
        let config = NodeConfig(
            symbol: "􀌨",
            fontName: "SFPro-Thin",
            color: .black,
            scale: 2,
            extrusionDepth: 0.2,
            position: SCNVector3(x: 0, y: -0.15, z: 0),
            flatness: 0.015,
            chamferRadius: 0.1,
            material: { .glossy() },
            category: (1 << 1)
        )
        
        return symbolNode(config: config)
    }
    
    
    func speechNode(symbol: NSString) -> SCNNode? {
        let config = NodeConfig(
            symbol: "􀌩",
            fontName: "SFPro-Thin",
            color: .white,
            scale: 2,
            extrusionDepth: 0.1,
            position: SCNVector3(x: 0, y: -0.15, z: 0),
            flatness: 0.05,
            chamferRadius: 0,
            material: { SCNMaterial() },
            category: (1 << 1)
        )
        
        return symbolNode(config: config)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
