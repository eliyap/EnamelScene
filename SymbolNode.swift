//
//  SymbolNode.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 14/10/22.
//

import Foundation
import SceneKit

func symbolNode(config: NodeConfig) -> SCNNode? {
    guard let cgPath = path(config) else { return nil }

    let path = UIBezierPath(cgPath: cgPath)
    path.flatness = config.flatness
    let shape = SCNShape(path: path, extrusionDepth: config.extrusionDepth)
    shape.chamferRadius = config.chamferRadius
    shape.chamferMode = .both
    
    let material = config.material()
    if shape.materials.isEmpty {
        shape.insertMaterial(material, at: 0)
    } else {
        shape.materials[0] = material
    }
    material.diffuse.contents = config.color
    
    let node = SCNNode(geometry: shape)
    node.castsShadow = true
    node.position = config.position
    node.categoryBitMask = config.category
    return node
}

func path(_ config: NodeConfig) -> CGPath? {
    let fontSize: CGFloat = 24
    
    /// Get SF Pro font containing SF Symbols.
    guard let fontURL = Bundle.main.url(forResource: "SF-Pro", withExtension: "ttf") else {
        return nil
    }
    let fontDescriptors = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL) as! [CTFontDescriptor]
    let fontDescriptor = fontDescriptors.first { desc in
        let attrs = CTFontDescriptorCopyAttributes(desc)
        return NSDictionary(dictionary: attrs)["NSFontNameAttribute"] as? NSString == config.fontName as NSString
    }!
        
    let ctFont = CTFontCreateWithFontDescriptor(fontDescriptor, fontSize, nil)
    
    /// Get `CGGlyph`s from SF Symbol.
    let unichars: [unichar] = makeUnichars(from: config.symbol)
    var glyphs = [CGGlyph](repeating: .zero, count: config.symbol.length)
    guard CTFontGetGlyphsForCharacters(ctFont, unichars, &glyphs, config.symbol.length) else {
        return nil
    }
    
    /// Create and transform glyph `CGPath`.
    /// It is normalized to 1x1 and centered.
    guard var glyphPath = CTFontCreatePathForGlyph(ctFont, glyphs[0], nil) else {
        return nil
    }
    
    var scaleDown = CGAffineTransform(scaleX: config.scale/fontSize, y: config.scale/fontSize)
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
