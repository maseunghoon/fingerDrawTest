//
//  MyRectView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/08/25.
//

import UIKit

class MyRectView: UIView {
    var view:UIView!
    
    @IBOutlet var testRect: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadView()
    }
    
    
    func loadView() {
        if view == nil {
            view = (Bundle.main.loadNibNamed("MyRectView", owner: self, options: nil)?.first as! UIView)
            
            guard let content = view else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
        
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
         let translation = gesture.translation(in: self)

         guard let gestureView = gesture.view else {
           return
         }

         gestureView.center = CGPoint(
           x: gestureView.center.x + translation.x,
           y: gestureView.center.y + translation.y
         )

         gesture.setTranslation(.zero, in: self)
    }
    
    
    @IBAction func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.scaledBy(
          x: gesture.scale,
          y: gesture.scale
        )
        gesture.scale = 1
    }
    
    @IBAction func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.rotated(
          by: gesture.rotation
        )
        gesture.rotation = 0
    }
    
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }
}
