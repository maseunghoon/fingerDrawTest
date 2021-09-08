//
//  Shape.swift
//  Nasmo
//
//  Created by VRMobileTeam on 2018. 3. 27..
//

import UIKit


class Shape {

    func makeShapeCircle(bezier:UIBezierPath) {

        bezier.lineWidth = 2
        bezier.stroke()
    }
    
    func makeShapeLine(context:CGContext?, firstCenter:CGPoint, lastCenter:CGPoint) {
    
        context?.setLineWidth(2.0)
        context?.move(to: firstCenter)
        context?.addLine(to: lastCenter)
        context?.strokePath()
    }
    
    func makeShapeRect(context:CGContext?, rect:CGRect) {

        UIGraphicsGetCurrentContext()?.setLineWidth(2.0)
        context?.move(to: CGPoint(x: 10, y: 10))
        context?.addLine(to: CGPoint(x: rect.size.width - 10, y: 10))
        context?.addLine(to: CGPoint(x: rect.size.width - 10, y: rect.size.height - 10))
        context?.addLine(to: CGPoint(x: 10, y: rect.size.height - 10))
        context?.closePath()
        context?.strokePath()
    }
    
    func makeShapeAngleLine(context:CGContext?, firstCenter:CGPoint, centerCenter:CGPoint, lastCenter:CGPoint, color:UIColor) {
        
        context?.setLineWidth(2.0)
        context?.move(to: firstCenter)
        context?.addLine(to: centerCenter)
        context?.addLine(to: lastCenter)

        context?.move(to: centerCenter)
        
        let start = getAngle(center: centerCenter, point: firstCenter, radius: 15)
        let end = getAngle(center: centerCenter, point: lastCenter, radius: 15)
        
        context?.addArc(center: centerCenter, radius: 15,
                        startAngle: start,
                        endAngle: end,
                        clockwise: false)
        
//        print("start : \(start), end : \(end)")
//        print("start_d : \((start / .pi * 180)), end_d : \((end / .pi * 180))")
        
        let start_d = (start / .pi * 180)
        let end_d = (end / .pi * 180)
        
        var angleDegree = end_d - start_d
        if (angleDegree < 0.0) {
            angleDegree = 360 + angleDegree;
        }

        context?.strokePath()
        
        UIGraphicsPushContext(context!)
        
        let font = UIFont.systemFont(ofSize: 15)
        let color = color
        let string = NSAttributedString(string: String(format: "%1.f°", angleDegree), attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        
        let x = CGFloat(20)
        let y = CGFloat(10)
        string.draw(at: CGPoint(x: centerCenter.x + x, y: centerCenter.y - y))
        
        UIGraphicsPopContext()
    }
    
    func getAngle(center: CGPoint, point: CGPoint, radius: CGFloat) -> CGFloat {
        let origin = CGPoint(x: center.x + radius, y: center.y)

        let v1 = CGVector(dx: origin.x - center.x, dy: origin.y - center.y)
        let v2 = CGVector(dx: point.x - center.x, dy: point.y - center.y)

        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)

        return angle
    }
}
