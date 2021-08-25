//
//  MyDrawView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/08/25.
//

import UIKit

class MyDrawView: UIView {
    
    var touch : UITouch!
    var lastPoint : CGPoint!
    var currentPoint : CGPoint!
    
    var pointArray:[CGPoint]! = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first!
        lastPoint = touch.location(in: self)
        pointArray = []
        print("lastPoint.x : \(lastPoint.x), lastPoint.y : \(lastPoint.y)")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first!
        currentPoint = touch.location(in: self)
        
        self.setNeedsDisplay()
        
        pointArray.append(currentPoint)
        
        lastPoint = currentPoint
    }

    override func draw(_ rect: CGRect) {
        var context:CGContext! = UIGraphicsGetCurrentContext()
        
        context.setLineWidth(5)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineCap(CGLineCap(rawValue: 5)!)
        
        context.beginPath()
        
        for (index,it) in pointArray.enumerated(){
            let p0:CGPoint = pointArray[index]
            
            if pointArray.count > index + 1 {
                let p1:CGPoint = pointArray[index+1]
                context.move(to: CGPoint(x: p1.x, y: p1.y))
                context.addLine(to: CGPoint(x: p0.x, y: p0.y))
            }
            
//            context.addEllipse(in: CGRect(x: it.x - 2, y: it.y - 2, width: 4, height: 4))
        }
        
        context.strokePath()
    }
    
}
