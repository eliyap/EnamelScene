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
        material.diffuse.contents = UIColor.blue
        material.roughness.intensity = 0 /// Makes material perfectly "glossy", reflecting light's shape
     
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

func path() -> CGPath? {
    let fontSize: CGFloat = 24
    
    /// Get SF Pro font containing SF Symbols.
    guard let fontURL = Bundle.main.url(forResource: "SF-Pro", withExtension: "ttf") else {
        return nil
    }
    let fontDescriptor = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as! [CTFontDescriptor]
    let ctFont = CTFontCreateWithFontDescriptor(fontDescriptor[0], fontSize, nil)
    
    /// Get `CGGlyph`s from SF Symbol.
    let str: NSString = "􁝁"
    let unichars: [unichar] = makeUnichars(from: str as NSString)
    var glyphs = [CGGlyph](repeating: .zero, count: str.length)
    guard CTFontGetGlyphsForCharacters(ctFont, unichars, &glyphs, str.length) else {
        return nil
    }
    
    /// Create and transform glyph `CGPath`.
    /// It is normalized to 1x1 and centered.
    guard var glyphPath = CTFontCreatePathForGlyph(ctFont, glyphs[0], nil) else {
        return nil
    }
    var scaleDown = CGAffineTransform(scaleX: 1/fontSize, y: 1/fontSize)
    guard let scaledDown = glyphPath.copy(using: &scaleDown) else {
        return nil
    }
    
    glyphPath = scaledDown
    let box = glyphPath.boundingBox
    var center = CGAffineTransform(translationX: -box.midX, y: -box.midY)
    guard let centered = glyphPath.copy(using: &center) else {
        return nil
    }
    glyphPath = centered
    
    return glyphPath
}
