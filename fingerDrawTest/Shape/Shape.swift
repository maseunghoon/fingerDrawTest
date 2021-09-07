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
    
    func makeShapeAnkleLine(context:CGContext?, firstCenter:CGPoint, centerCenter:CGPoint, lastCenter:CGPoint) {
        
        context?.setLineWidth(2.0)
        context?.move(to: firstCenter)
        context?.addLine(to: centerCenter)
        context?.addLine(to: lastCenter)

//        var angleDegree = atan((lastCenter.y - centerCenter.y)/(lastCenter.x - centerCenter.x)) - atan((firstCenter.y - centerCenter.y)/(firstCenter.x - centerCenter.x))
//        angleDegree = angleDegree * CGFloat((180.0 / .pi))
        
        let m12 = (CGFloat)(firstCenter.y - centerCenter.y) / (CGFloat)(firstCenter.x - centerCenter.x)
        let m34 = (CGFloat)(lastCenter.y - centerCenter.y) / (CGFloat)(lastCenter.x - centerCenter.x)

        var angleDegree = self.getAngleBetweenTwoLines(m1: m12, m2: m34)
        
        if (angleDegree < 0.0) {
            angleDegree = 180 + angleDegree;
        }
        
        context?.addArc(center: centerCenter, radius: 15,
                        startAngle: atan((lastCenter.y - centerCenter.y)/(lastCenter.x - centerCenter.x)),
                        endAngle: atan((firstCenter.y - centerCenter.y)/(firstCenter.x - centerCenter.x)),
                        clockwise: true)
        
        context?.strokePath()
        
        UIGraphicsPushContext(context!)
        
        let font = UIFont.systemFont(ofSize: 15)
        let color = UIColor.red
        let string = NSAttributedString(string: String(format: "%1.f°", angleDegree), attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        string.draw(at: CGPoint(x: centerCenter.x + 20, y: centerCenter.y - 10))
        UIGraphicsPopContext()
    }
    
    public func getAngleBetweenTwoLines(m1:CGFloat, m2:CGFloat) -> CGFloat{
        let m:CGFloat = (m1 - m2) / (1 + m1 * m2)
        let radian:CGFloat = -atan(m) // or (float) -Math.atan(m)
        let degree:CGFloat = (CGFloat) (radian / .pi * 180)
//        let degree:CGFloat = (CGFloat) (radian * (180.0 / .pi))
        return degree
    }
}
