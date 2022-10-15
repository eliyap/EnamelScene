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
        gearPin.position = SCNVector3(x: -1.5, y: 0, z: 0)
        scene.rootNode.addChildNode(gearPin)
        
        let heartPin = pinNode(symbol: "􀊵", border: "􀊴", color: .systemPink)
        heartPin.position = SCNVector3(x: 1.5, y: 0, z: 0)
        scene.rootNode.addChildNode(heartPin)
        
        let gamePin = pinNode(symbol: "􀛹", border: "􀛸", color: .systemPurple)
        gamePin.position = SCNVector3(x: -4.5, y: 0, z: 0)
        scene.rootNode.addChildNode(gamePin)
        
        let bulbPin = pinNode(symbol: "􀛮", border: "􀛭", color: .systemYellow)
        bulbPin.position = SCNVector3(x: +6, y: -2.5, z: 0)
        scene.rootNode.addChildNode(bulbPin)
        
        let sofaPin = pinNode(symbol: "􁐳", border: "􁐲", color: .systemBrown)
        sofaPin.position = SCNVector3(x: -3, y: -2.5, z: 0)
        scene.rootNode.addChildNode(sofaPin)

        let brushPin = pinNode(symbol: "􀡧", border: "􀡦", color: .systemRed)
        brushPin.position = SCNVector3(x: 0, y: -2.5, z: 0)
        scene.rootNode.addChildNode(brushPin)

        let locPin = pinNode(symbol: "􀋒", border: "􀋑", color: .systemGreen)
        locPin.position = SCNVector3(x: 3, y: +2.5, z: 0)
        scene.rootNode.addChildNode(locPin)
        
        let ejectPin = pinNode(symbol: "􀆦", border: "􀆥", color: .systemOrange)
        ejectPin.position = SCNVector3(x: -3, y: +2.5, z: 0)
        scene.rootNode.addChildNode(ejectPin)
        
        let fishPin = pinNode(symbol: "􁖑", border: "􁖐", color: .systemCyan)
        fishPin.position = SCNVector3(x: 0, y: +2.5, z: 0)
        scene.rootNode.addChildNode(fishPin)
        
        let volPin = pinNode(symbol: "􀚅", border: "􀇴", color: .systemCyan)
        volPin.position = SCNVector3(x: 6, y: +2.5, z: 0)
        scene.rootNode.addChildNode(volPin)
        
        let hammerPin = pinNode(symbol: "􀙅", border: "􀙄", color: .systemGray)
        hammerPin.position = SCNVector3(x: -6, y: +2.5, z: 0)
        scene.rootNode.addChildNode(hammerPin)
        
        let maskPin = pinNode(symbol: "􁃍", border: "􁃌", color: .systemCyan)
        maskPin.position = SCNVector3(x: 3, y: -2.5, z: 0)
        scene.rootNode.addChildNode(maskPin)
        
        let pawPin = pinNode(symbol: "􀾟", border: "􀾞", color: .systemBrown)
        pawPin.position = SCNVector3(x: 4.5, y: 0, z: 0)
        scene.rootNode.addChildNode(pawPin)
        
        let tapPin = pinNode(symbol: "􀬂", border: "􀬁", color: .systemCyan)
        tapPin.position = SCNVector3(x: -6, y: -2.5, z: 0)
        scene.rootNode.addChildNode(tapPin)
        
        
//        let yPin = pinNode(symbol: "􀈖", border: "􀈕", color: .systemPink)
//        yPin.position = SCNVector3(x: 3, y: +2.5, z: 0)
//        scene.rootNode.addChildNode(yPin)
        
//        let brushPin = pinNode(symbol: "􀈠", border: "􀈟", color: .systemOrange)
//        brushPin.position = SCNVector3(x: 0, y: -1.5, z: 0)
//        scene.rootNode.addChildNode(brushPin)

//        let brushPin = pinNode(symbol: "􀈬", border: "􀈫", color: .systemOrange)
//        brushPin.position = SCNVector3(x: 0, y: -1, z: 0)
//        scene.rootNode.addChildNode(brushPin)

//        let clipPin = pinNode(symbol: "􀶷", border: "􀶶", color: .systemBrown)
//        clipPin.position = SCNVector3(x: 0, y: -2, z: 0)
//        scene.rootNode.addChildNode(clipPin)

        
//        let cloudPin = pinNode(symbol: "􀙋", border: "􀙊", color: .systemGreen)
//        cloudPin.position = SCNVector3(x: -2.5, y: 2, z: 0)
//        scene.rootNode.addChildNode(cloudPin)
        
//        let trashPin = pinNode(symbol: "􀈒", border: "􀈑", color: .darkGray)
//        trashPin.position = SCNVector3(x: -2.5, y: +2, z: 0)
//        scene.rootNode.addChildNode(trashPin)
//
//        let trashPin = pinNode(symbol: "􀪏", border: "􀩼", color: .darkGray)
//        trashPin.position = SCNVector3(x: -2.5, y: +2, z: 0)
//        scene.rootNode.addChildNode(trashPin)
//
//        let boxPin = pinNode(symbol: "􀐛", border: "􀐚", color: .systemBrown)
//        boxPin.position = SCNVector3(x: +2.5, y: 0, z: 0)
//        scene.rootNode.addChildNode(boxPin)

        initShadowPlane()
        initAmbientLight(intensity: 200)
        initDirectionalLight(intensity: 1000)
        initAreaLight(intensity: 1000)
        initCamera(distance: 5.5)
    }
    
    func initShadowPlane() {
        let plane = SCNPlane(width: 30, height: 30)
        let material = SCNMaterial()
        if plane.materials.isEmpty {
            plane.insertMaterial(material, at: 0)
        } else {
            plane.materials[0] = material
        }
        material.diffuse.contents = UIColor.white
        let node = SCNNode(geometry: plane)
        node.position = .init(x: 0, y: 0, z: -0.25)
        scene.rootNode.addChildNode(node)
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
