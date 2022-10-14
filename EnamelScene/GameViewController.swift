//
//  GameViewController.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 13/10/22.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView!
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = view as! SCNView
        self.scene = SCNScene(named: "MainScene.scn")!
        sceneView.scene = scene
                
        let square = UIBezierPath(
            roundedRect: CGRect(x: -0.5, y: -0.5, width: 1, height: 1),
            cornerRadius: 0.05
        )
        let shape = SCNShape(path: square, extrusionDepth: 0.1)
        shape.chamferRadius = 0.05
        shape.chamferMode = .front
        
        var material = SCNMaterial()
        if shape.materials.isEmpty {
            shape.insertMaterial(material, at: 0)
        } else {
            material = shape.materials[0]
        }
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.red
        material.clearCoat.contents = UIColor(white: 1, alpha: 0.1)
        material.clearCoat.intensity = 0.1
        material.clearCoatNormal.contents = UIColor(white: 1, alpha: 0.1)
        material.clearCoatNormal.intensity = 1.0
     
        let node = SCNNode(geometry: shape)
        scene.rootNode.addChildNode(node)
        
        let light = SCNLight()
        light.type = .area
        light.intensity = 5000
        light.temperature = CGFloat(3500)
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0.25, y: 0.25, z: 0.25)
        scene.rootNode.addChildNode(lightNode)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
