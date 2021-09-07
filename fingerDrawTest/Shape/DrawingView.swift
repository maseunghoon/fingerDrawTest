//
//  DrawingView.swift
//  DrawingView
//
//  Created by ParkByounghyouk on 15/01/1017.
//  Copyright © 1017 ParkByounghyouk. All rights reserved.
//

import UIKit

enum PanningState {

    case begin, end
    case moved(CGFloat)    
}

class DrawingView: UIView {

    private var shapes = [ShapeManager]()
    private var movingShape: ShapeManager?
    var selectedShape: ShapeManager?
    private var firstTouchPosition: CGPoint!
    private var lastTouchPosition: CGPoint!
    private var isPanning: Bool = false
    var onEmptySpaceTouched: (() -> Void)?
    var selectedShapeChanged: (() -> Void)?
    var panned: ((PanningState) -> Void)?

    func getSelectedShape() -> ShapeManager? {
        if let selectedIndex = shapes.index(where: { $0.isSelected }) {
            return shapes[selectedIndex]
        }
        return nil
    }
    
    func setSelectedShape(shape:ShapeManager?) {
        
        if shape != nil {
            self.selectedShape = shape
        }
        shapes.forEach { (nasmoShape) in
            nasmoShape.isSelected = (shape == nasmoShape)
            nasmoShape.movingButtons.forEach { (button) in
                button.isHidden = !nasmoShape.isSelected
            }
            nasmoShape.setNeedsDisplay()
        }
        
        self.selectedShapeChanged?()
    }
    
    func add(shape: ShapeManager) {
    
        shape.alpha = 0
        self.addSubview(shape)
        shapes.append(shape)
        setSelectedShape(shape: shape)
        UIView.animate(withDuration: 0.1) {
            shape.alpha = 1
        }
        
        getSelectedShape()?.registerUndo()
    }

    func removeSelectedShape() {
        
        let shapeToRemove = self.selectedShape
        setSelectedShape(shape: nil)
        
        if let selected = shapeToRemove,
            let index = self.shapes.index(of: selected) {
            
            self.shapes.remove(at: index)
            
        }

        UIView.animate(withDuration: 0.1, animations: {
        
            shapeToRemove?.alpha = 0
        
        }) { (complete) in

            shapeToRemove?.removeFromSuperview()
            
        }
    }

    func clear() {
    
        setSelectedShape(shape: nil)
        
        self.shapes.forEach { (shape) in
            shape.removeFromSuperview()
        }
        
        self.shapes.removeAll()
    }
    
    func clearAllSubs() {
        
        self.clear()
        
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    
    func reFrameSubviews(size:CGSize) {
        
        self.subviews.forEach { (view) in
            
            view.frame.size = size
        }
    }
    
    func setSelectedShapeColor(_ color: UIColor) {
    
        getSelectedShape()?.registerUndo()
        getSelectedShape()?.lineColor = color
        getSelectedShape()?.setLineColor()
    }
    
    func undoSelectedShape() {
    
        getSelectedShape()?.undo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchPoint = touches.first?.location(in: self) else {
            
            return
        
        }
        
        self.firstTouchPosition = touchPoint
        self.lastTouchPosition = touchPoint
        
        if let movableIndex = shapes.index(where: { $0.isMovalble(on: touchPoint) }) {
        
            self.movingShape = self.shapes[movableIndex]
            self.movingShape?.registerUndo()
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        
        // 화면사이즈만큼의 제한을 둔다 ; 8을 해야 보임
        if touchPoint.y <= 8 {
            warningPositionAnimation()
           return
        } else if touchPoint.x <= 8 {
           warningPositionAnimation()
            return
        } else if touchPoint.x >= self.frame.size.width - 8 {
            warningPositionAnimation()
            return
        } else if touchPoint.y >= self.frame.size.height - 8 {
            warningPositionAnimation()
            return
        }

        if self.movingShape != nil {
       
            if let m_shaple = self.movingShape {
                switch m_shaple.shapeType {
                case .ankleLine:
                    let btn = m_shaple.movingButtons[1]
                    m_shaple.center = CGPoint(x: ((m_shaple.frame.width/2) - btn.center.x) + touchPoint.x,
                                                       y: ((m_shaple.frame.height/2) - btn.center.y) + touchPoint.y)
                default:
                    m_shaple.center = touchPoint
                }
            }
            
//            self.movingShape?.center = touchPoint
            
        }
        else if self.isPanning {
            
            self.panned?(.moved(touchPoint.x - lastTouchPosition.x))
            
        }
        else if abs(touchPoint.x - firstTouchPosition.x) > 50 {
        
            self.isPanning = true
            
        }
        
        // 화면사이즈만큼의 제한을 둔다
        let touchPointmodi = CGPoint(x: min(max(0, touchPoint.x), self.frame.width), y: min(max(0, touchPoint.y), self.frame.height))
        print("\(touchPointmodi)")

        self.lastTouchPosition = touchPoint
        print("touchPoint : \(touchPoint)")
    }
    
    func warningPositionAnimation() {
        
        DispatchQueue.main.async {
//            self.layer.borderWidth = 5
            UIView.animate(withDuration: 0, animations: {
                self.layer.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.1).cgColor
            }) { (_) in
                UIView.animate(withDuration: 0, animations: {
                    self.layer.backgroundColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0).cgColor
                })
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touchPoint = touches.first?.location(in: self) else {
            return
        }
        if self.isPanning == true {
            
            self.isPanning = false
            self.panned?(.end)
            self.lastTouchPosition = nil
            getSelectedShape()?.registerUndo()
            
        } else if self.movingShape != nil {
            
            self.movingShape = nil
            
        } else if let index = shapes.index(where: { $0.isSelectable(on: touchPoint) }) {
            
            setSelectedShape(shape: shapes[index])
            let element = shapes.remove(at: index)
            self.shapes.insert(element, at: 0)
            self.bringSubviewToFront(element)
            
        } else if self.selectedShape != nil {
            
            setSelectedShape(shape: nil)
            
        } else {
            
            self.onEmptySpaceTouched?()
        }
    }
}
