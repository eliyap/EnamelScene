//
//  BezierSmooth.swift
//  EnamelScene
//
//  Created by Secret Asian Man 3 on 14/10/22.
//

import UIKit

extension CGPathElementType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .moveToPoint:
            return "moveToPoint"
        case .addLineToPoint:
            return "addLineToPoint"
        case .addQuadCurveToPoint:
            return "addQuadCurveToPoint"
        case .addCurveToPoint:
            return "addCurveToPoint"
        case .closeSubpath:
            return "closeSubpath"
        }
    }
}

extension UIBezierPath {
    /// Reference: https://github.com/erica/iOS-6-Cookbook/blob/master/C01%20Gestures/08%20-%20Smoothed%20Drawing/UIBezierPath-Points.m
    var points: [CGPoint] {
        var bezierPoints = [CGPoint]()

        cgPath.applyWithBlock { (element: UnsafePointer<CGPathElement>) in
            print(element.pointee.type)
            if element.pointee.type != .closeSubpath {
                bezierPoints.append(element.pointee.points.pointee)

                if element.pointee.type != .addLineToPoint && element.pointee.type != .moveToPoint {
                    bezierPoints.append(element.pointee.points.advanced(by: 1).pointee)
                }
            }

            if element.pointee.type == .addCurveToPoint {
                bezierPoints.append(element.pointee.points.advanced(by: 2).pointee)
            }
        }

        return bezierPoints
    }

    /// reference: https://github.com/erica/iOS-6-Cookbook/blob/master/C01%20Gestures/08%20-%20Smoothed%20Drawing/UIBezierPath-Smoothing.m
    @discardableResult
    func smoothened(granularity: Int) -> UIBezierPath {
        
        var points = self.points
        guard points.count >= 4 else {
            return self
        }
        
        /// Add control points to make the math make sense
        /// Via Josh Weinberg
        points.insert(points.first!, at: 0)
        points.append(points.last!)
            
        let smoothed = copy() as! UIBezierPath
        smoothed.removeAllPoints()
        
        /// Copy traits
        smoothed.lineWidth = lineWidth
        
        var pts: [CGPoint] = []
        func selfIntersects(point: CGPoint) -> Bool {
            /// Require at least 1 line segment (2 points) plus another disconnected point.
            guard pts.count >= 3 else { return false }
            /// Last point is `count-3+1`, the second last element in the array.
            /// Final line segment excluded; it touches (intersects) the rest of the line.
            for index in 0...(pts.count-3) {
                if intersect(line1: (a: pts[index], b: pts[index+1]), line2: (a: pts.last!, b: point)) {
                    return true
                }
            }
            return false
        }
        
        func tryExtendLine(_ pt: CGPoint) {
            guard selfIntersects(point: pt) == false else {
                print("ERROR: SELF INTERSECTING")
                return
            }
            smoothed.addLine(to: pt)
            pts.append(pt)
        }
        
        /// Draw out the first 3 points `(0..2)`
        smoothed.move(to: points[0])
        smoothed.addLine(to: points[1])
        smoothed.addLine(to: points[2])
        pts += points[0...2]
        
        for index in 4 ..< points.count {
            let p0 = points[index - 3]
            let p1 = points[index - 2]
            let p2 = points[index - 1]
            let p3 = points[index - 0]

            /// now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for i in 1..<granularity {
                if index % 4 != 2 { break }
                
                let t = Double(i) / Double(granularity)
                let tt = t * t
                let ttt = tt * t
                    
                /// Intermediate point
                let interpolated = CGPoint(
                    x: 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt),
                    y: 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt)
                )
                if selfIntersects(point: interpolated) {
                    print("ERROR: SELF INTERSECTING")
                } else {
                    smoothed.addLine(to: interpolated)
                    pts.append(interpolated)
                    print("pi", interpolated)
                }
                
            }
                
            /// Now add p2.
            if selfIntersects(point: p2) {
                print("ERROR: SELF INTERSECTING")
            } else {
                smoothed.addLine(to: p2)
                pts.append(p2)
                print("p2", p2)
            }
            
        }
            
        /// Finish by adding the last point.
        if selfIntersects(point: points.last!) {
            print("ERROR: SELF INTERSECTING")
        }
        smoothed.addLine(to: points.last!)
        
        return smoothed
    }
}

func intersect(line1: (a: CGPoint, b: CGPoint), line2: (a: CGPoint, b: CGPoint)) -> Bool {

//    let distance = (line1.b.x - line1.a.x) * (line2.b.y - line2.a.y) - (line1.b.y - line1.a.y) * (line2.b.x - line2.a.x)
//    if distance == 0 {
//        /// parallel lines.
//        return false
//    }
//
//    let u = ((line2.a.x - line1.a.x) * (line2.b.y - line2.a.y) - (line2.a.y - line1.a.y) * (line2.b.x - line2.a.x)) / distance
//    let v = ((line2.a.x - line1.a.x) * (line1.b.y - line1.a.y) - (line2.a.y - line1.a.y) * (line1.b.x - line1.a.x)) / distance
//
//    return (0...1).contains(u) && (0...1).contains(v)
    
    
    return lineIntersection(p0: line1.a, p1: line1.b, p2: line2.a, p3: line2.b) != nil
}

func lineIntersection(
    p0: CGPoint, p1: CGPoint,
    p2: CGPoint, p3: CGPoint
) -> CGPoint? {
    let s1 = CGPoint(
        x: p1.x - p0.x,
        y: p1.y - p0.y
    )
    let s2 = CGPoint(
        x: p3.x - p2.x,
        y: p3.y - p2.y
    )
  
    let s: Double = (-s1.y * (p0.x - p2.x) + s1.x * (p0.y - p2.y)) / (-s2.x * s1.y + s1.x * s2.y)
    let t: Double = ( s2.x * (p0.y - p2.y) - s2.y * (p0.x - p2.x)) / (-s2.x * s1.y + s1.x * s2.y)
    
    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
        return CGPoint(
            x: p0.x + (t * s1.x),
            y: p0.y + (t * s1.y)
        )
    } else {
        return nil
    }
}