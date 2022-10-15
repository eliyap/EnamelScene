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

        let gearPin = pinNode(symbol: "􀣌", border: "􀣋", color: .systemBlue)
        gearPin.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(gearPin)
        
        let heartPin = pinNode(symbol: "􀊵", border: "􀊴", color: .systemRed)
        heartPin.position = SCNVector3(x: 2.5, y: 0, z: 0)
        scene.rootNode.addChildNode(heartPin)
        
        let gamePin = pinNode(symbol: "􀛹", border: "􀛸", color: .systemPurple)
        gamePin.position = SCNVector3(x: -2.5, y: 0, z: 0)
        scene.rootNode.addChildNode(gamePin)
        
        let trashPin = pinNode(symbol: "􀈒", border: "􀈑", color: .systemRed)
        trashPin.position = SCNVector3(x: -2.5, y: +2, z: 0)
        scene.rootNode.addChildNode(trashPin)
        
        let boxPin = pinNode(symbol: "􀐛", border: "􀐚", color: .systemBrown)
        boxPin.position = SCNVector3(x: +2.5, y: +2, z: 0)
        scene.rootNode.addChildNode(boxPin)
        
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
        light.shadowCascadeCount = 4 /// Maximum value
        
        let lightNode = SCNNode()
        lightNode.light = light
        
        let angle: Float = -.pi / 8
        lightNode.eulerAngles.x = angle
        
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
