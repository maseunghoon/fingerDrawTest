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
}
