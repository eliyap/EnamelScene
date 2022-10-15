//
//  GameViewController.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 13/10/22.
//

import UIKit
import SceneKit
import CoreText

let colorTemp: CGFloat = 6500

class GameViewController: UIViewController {

    var sceneView: SCNView!
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = view as! SCNView
        self.scene = SCNScene(named: "MainScene.scn")!
        sceneView.scene = scene

        if let borderNode = symbolNode(config: NodeConfig(
            symbol: "􀣋",
            fontName: "SFPro-Regular",
            color: .black,
            scale: 1,
            extrusionDepth: 0.2,
            flatness: 0.015,
            chamferRadius: 0.1,
            material: { .glossy() }
        )) {
            scene.rootNode.addChildNode(borderNode)
        }
        if let colorNode = symbolNode(config: NodeConfig(
            symbol: "􀣌",
            fontName: "SFPro-Regular",
            color: UIColor(red: 69.0/256, green: 148.0/256, blue: 233.0/256, alpha: 1),
            scale: 1,
            extrusionDepth: 0.15,
            flatness: 0.05,
            chamferRadius: 0,
            material: { .glossy() }
        )) {
            scene.rootNode.addChildNode(colorNode)
        }
        if let speechNode = symbolNode(config: NodeConfig(
            symbol: "􀌩",
            fontName: "SFPro-Thin",
            color: .white,
            scale: 2,
            extrusionDepth: 0.1,
            position: SCNVector3(x: 0, y: -0.15, z: 0),
            flatness: 0.05,
            chamferRadius: 0,
            material: { SCNMaterial() },
            /// Nodes cast shadows on each other; we only want the general shadow.
            castsShadow: true
        )) {
            scene.rootNode.addChildNode(speechNode)
        }
        if let speechBorderNode = symbolNode(config: NodeConfig(
            symbol: "􀌨",
            fontName: "SFPro-Thin",
            color: .black,
            scale: 2,
            extrusionDepth: 0.2,
            position: SCNVector3(x: 0, y: -0.15, z: 0),
            flatness: 0.015,
            chamferRadius: 0.1,
            material: { .glossy() }
        )) {
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
        initDirectionalLight()
        initAreaLight(intensity: 2000)
        initCamera()
    }
    
    /// Lights everything; helps keep shadow plane invisible.
    func initAmbientLight(intensity: CGFloat) {
        let light = SCNLight()
        light.type = .ambient
        light.intensity = intensity
        light.temperature = colorTemp

        let lightNode = SCNNode()
        lightNode.light = light
        scene.rootNode.addChildNode(lightNode)
    }
    
    func initDirectionalLight(intensity: CGFloat) {
        let light = SCNLight()
        light.type = .directional
        light.intensity = intensity
        light.temperature = colorTemp
        
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
        light.temperature = colorTemp
        light.castsShadow = false

        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 0, z: 1)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func initCamera(distance: Float) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        cameraNode.position = SCNVector3(0, 0, distance)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
