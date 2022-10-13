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
                
        let square = UIBezierPath(rect: CGRect(x: -0.5, y: -0.5, width: 1, height: 1))
        let shape = SCNShape(path: square, extrusionDepth: 0.1)
        shape.chamferRadius = 0.05
        
        var material = SCNMaterial()
        if shape.materials.isEmpty {
            shape.insertMaterial(material, at: 0)
        } else {
            material = shape.materials[0]
        }
        material.diffuse.contents = UIColor.red
        material.specular.contents = UIColor.white
        material.shininess = 0.1
     
        let node = SCNNode(geometry: shape)
        scene.rootNode.addChildNode(node)
        
        let light = SCNLight()
        light.type = .omni
        light.intensity = 5000
        light.temperature = CGFloat(3500)
        
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
        scene.rootNode.addChildNode(lightNode)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
