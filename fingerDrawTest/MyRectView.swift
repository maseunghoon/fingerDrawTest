//
//  MyRectView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/08/25.
//
// 사각형
import UIKit

class MyRectView: UIView, UIGestureRecognizerDelegate {
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
    var selectedFigureTag:Int = -1
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
    
    @IBAction func clickAddCircleButton(_ sender: Any) {
        let c:CustomObjectView = CustomObjectView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        
        c.makeCircle()
        
        self.addSubview(c)
  
        let pinGEST:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let panGEST:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
//        let rotationGEST:UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotation(_:)))
        let TapGEST:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
//        c.gestureRecognizers = [pinGEST,panGEST,rotationGEST,TapGEST]
        c.gestureRecognizers = [pinGEST,panGEST,TapGEST]
        c.tag = tag_index
        c.coverView.isHidden = false
        
        
        for it in figureArray {
            it.coverView.isHidden = true
        }
        
        figureArray.append(c)
        tag_index = tag_index + 1
        
    }
    
    @IBAction func clickAddRectBtn(_ sender: Any) {
        let c:CustomObjectView = CustomObjectView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        
        c.makeRect()
        
        self.addSubview(c)
  
        let pinGEST:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        let panGEST:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
//        let rotationGEST:UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotation(_:)))
        let TapGEST:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
//        c.gestureRecognizers = [pinGEST,panGEST,rotationGEST,TapGEST]
        c.gestureRecognizers = [pinGEST,panGEST,TapGEST]
        c.tag = tag_index
        c.coverView.isHidden = false
        
        for it in figureArray {
            it.coverView.isHidden = true
        }
        
        figureArray.append(c)
        tag_index = tag_index + 1
    }
    
    @IBAction func clickDelBtn(_ sender: Any) {
        if figureArray.count > 0 {
            for (idx, it) in figureArray.enumerated() {
                if it.tag == selectedFigureTag {
                    figureArray.remove(at: idx)
                    it.removeFromSuperview()
                    selectedFigureTag = -1
                }
            }
        }
    }
    
    @IBAction func clickDeleteAll(_ sender: Any) {
        for it in figureArray {
            it.removeFromSuperview()
        }
        
        figureArray.removeAll()
        selectedFigureTag = -1
    }
    
    @IBAction func clickSelectReset(_ sender: Any) {
        for it in figureArray {
            it.coverView.isHidden = true
        }
        selectedFigureTag = -1
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
            v.isTopRightBtnMode = false
            v.isTopLeftBtnMode = false
            v.isCenterBtnMode = false
            v.isBottomRightBtnMode = false
            v.isBottomLeftBtnMode = false
        }
        
        if v.isBottomRightBtnMode {
            var width:CGFloat = gestureView.frame.width + translation.x
            var height:CGFloat = gestureView.frame.height + translation.y
            width = width < 80 ? 80 : width
            height = height < 80 ? 80 : height
            
            gestureView.frame = CGRect(x: gestureView.frame.origin.x, y: gestureView.frame.origin.y, width: width, height: height)
            
            if v.type == .SHAPE_CIRCLE {
                let min = (v.tempImageView.frame.size.width < v.tempImageView.frame.size.height) ? v.tempImageView.frame.size.width : v.tempImageView.frame.size.height
                v.tempImageView.layer.cornerRadius = min / 2
            }
            
            gesture.setTranslation(.zero, in: self)
        } else if v.isBottomLeftBtnMode {
            var x:CGFloat = gestureView.frame.origin.x + translation.x
            var width:CGFloat = gestureView.frame.width - translation.x
            var height:CGFloat = gestureView.frame.height + translation.y
            width = width < 80 ? 80 : width
            height = height < 80 ? 80 : height
            
            if width == CGFloat(80) {
                x = gestureView.frame.maxX - width
            }
            
            gestureView.frame = CGRect(x: x, y: gestureView.frame.origin.y, width: width, height: height)
            gesture.setTranslation(.zero, in: self)
            
        } else if v.isTopRightBtnMode {
            var y:CGFloat = gestureView.frame.origin.y + translation.y
            var width:CGFloat = gestureView.frame.width + translation.x
            var height:CGFloat = gestureView.frame.height - translation.y
            width = width < 80 ? 80 : width
            height = height < 80 ? 80 : height
            
            if height == CGFloat(80) {
                y = gestureView.frame.maxY - height
            }
            
            gestureView.frame = CGRect(x: gestureView.frame.origin.x, y: y, width: width, height: height)
            gesture.setTranslation(.zero, in: self)
            
        } else if v.isTopLeftBtnMode {
            var x:CGFloat = gestureView.frame.origin.x + translation.x
            var y:CGFloat = gestureView.frame.origin.y + translation.y
            var width:CGFloat = gestureView.frame.width - translation.x
            var height:CGFloat = gestureView.frame.height - translation.y
            width = width < 80 ? 80 : width
            height = height < 80 ? 80 : height
            
            if width == CGFloat(80) {
                x = gestureView.frame.maxX - width
            }
            
            if height == CGFloat(80) {
                y = gestureView.frame.maxY - height
            }
            
            gestureView.frame = CGRect(x: x, y: y, width: width, height: height)
            gesture.setTranslation(.zero, in: self)
            
        } else if v.isCenterBtnMode {
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
    
//    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
//        guard let gestureView = gesture.view else {
//          return
//        }
//
//        let v:CustomObjectView = (gestureView as? CustomObjectView)!
//        if v.coverView.isHidden {
//            return
//        }
//
//        gestureView.transform = gestureView.transform.rotated(
//          by: gesture.rotation
//        )
//        gesture.rotation = 0
//    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        for it in figureArray {
            it.coverView.isHidden = true
        }
        
        let v:CustomObjectView = (gestureView as? CustomObjectView)!
        v.coverView.isHidden = false
        
        if v.tag == selectedFigureTag {
            return
        }
        
        selectedFigureTag = v.tag
        self.addSubview(v)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
}
