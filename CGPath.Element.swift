//
//  CGPath.Element.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 14/10/22.
//

import UIKit

extension CGPath {
    enum Element {
        case move(to: CGPoint)
        case line(to: CGPoint)
        case quadCurve(to: CGPoint, control: CGPoint)
        case curve(to: CGPoint, control1: CGPoint, control2: CGPoint)
        case closeSubpath
    }
}

extension UIBezierPath {
    var pathElements: [CGPath.Element] {
        var elements: [CGPath.Element] = []
        self.cgPath.applyWithBlock { element in
            switch element.pointee.type {
            case .moveToPoint:
                elements.append(.move(to: element.pointee.points[0]))
            case .addLineToPoint:
                elements.append(.line(to: element.pointee.points[0]))
            case .addQuadCurveToPoint:
                elements.append(.quadCurve(to: element.pointee.points[1], control: element.pointee.points[0]))
            case .addCurveToPoint:
                elements.append(.curve(to: element.pointee.points[2], control1: element.pointee.points[0], control2: element.pointee.points[1]))
            case .closeSubpath:
                elements.append(.closeSubpath)
            @unknown default:
                assert(false, "Unknown CGPathElementType")
            }
        }
        return elements
    }
}
