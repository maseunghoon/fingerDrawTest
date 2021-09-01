//
//  MyRectView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/08/25.
//

import UIKit

class MyRectView: UIView {
    var view:UIView!
    
    @IBOutlet var panGEST: UIPanGestureRecognizer!
    @IBOutlet var pinGEST: UIPinchGestureRecognizer!
    @IBOutlet var rotationGEST: UIRotationGestureRecognizer!
    @IBOutlet var TapGEST: UITapGestureRecognizer!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var figureArray:[CustomObjectView]! = []
    
    var tag_index = 0
    
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
    
    @IBAction func clickAddBtn(_ sender: Any) {
        let c:CustomObjectView = CustomObjectView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        self.addSubview(c)
  
        let pinGEST:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let panGEST:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        let rotationGEST:UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotation(_:)))
        let TapGEST:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        c.gestureRecognizers = [pinGEST,panGEST,rotationGEST,TapGEST]
        c.tag = tag_index
        
        figureArray.append(c)
        tag_index = tag_index + 1
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        let v:CustomObjectView = (gestureView as? CustomObjectView)!
        if v.coverView.isHidden {
            return
        }
        
        if gesture.state == .ended {
            v.isEndBtnMode = false
        }
        
        if v.isEndBtnMode {
            gestureView.frame = CGRect(x: gestureView.frame.origin.x, y: gestureView.frame.origin.y, width: gestureView.frame.width + translation.x, height: gestureView.frame.height + translation.y)
            
            gesture.setTranslation(.zero, in: self)
        } else {
            gestureView.center = CGPoint(
                x: gestureView.center.x + translation.x,
                y: gestureView.center.y + translation.y
            )

            gesture.setTranslation(.zero, in: self)
        }
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        
        let v:CustomObjectView = (gestureView as? CustomObjectView)!
        if v.coverView.isHidden {
            return
        }

        gestureView.transform = gestureView.transform.scaledBy(
          x: gesture.scale,
          y: gesture.scale
        )
        gesture.scale = 1
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        
        let v:CustomObjectView = (gestureView as? CustomObjectView)!
        if v.coverView.isHidden {
            return
        }

        gestureView.transform = gestureView.transform.rotated(
          by: gesture.rotation
        )
        gesture.rotation = 0
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        for it in figureArray {
            it.coverView.isHidden = true
        }
        
        let v:CustomObjectView = (gestureView as? CustomObjectView)!
        v.coverView.isHidden = false
        
//        gestureView.center = CGPoint(
//          x: gestureView.center.x + translation.x,
//          y: gestureView.center.y + translation.y
//        )
//
//        gesture.setTranslation(.zero, in: self)
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }
}
