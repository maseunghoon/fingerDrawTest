//
//  ShapeManager.swift
//  Nasmo
//
//  Created by VRMobileTeam on 2018. 3. 26..
//

import UIKit

enum ShapeType {
    
    case circle
    case rect
    case line
    case ankleLine
}

protocol ShapeInteractable {
    
    func isSelectable(on point: CGPoint) -> Bool
    func isMovalble(on point: CGPoint) -> Bool
}

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}

class ShapeManager: UIView, ShapeInteractable {
    
    var shapeType:ShapeType = .line
    var movingButtons = [UIButton]()
    var lineColor: UIColor = UIColor.white
    internal var isSelected: Bool = false
    
    func setLineColor() {
        
        self.movingButtons.forEach { (button) in
            button.backgroundColor = self.lineColor
            button.tintColor = self.lineColor == .white ? .black : .white
        }
        self.setNeedsDisplay()
    }
    
    init(frame: CGRect, lineColor: UIColor, shapeType:ShapeType) {
        
        super.init(frame: frame)
        
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.shapeType = shapeType
        self.lineColor = lineColor
        self.frame = frame
        self.clipsToBounds = false

        switch shapeType {
        case .circle:
            let size = min(frame.size.width, frame.size.height)
            var regularFrame = frame
            regularFrame.size = CGSize(width: size, height: size)
            let movingButton = makebutton(center: CGPoint(x: regularFrame.size.width - 10, y: regularFrame.size.height / 2))
            self.movingButtons.append(movingButton)
            self.addSubview(movingButton)
            break
        case  .rect:
            let movingButton = makebutton(center: CGPoint(x: frame.size.width - 10, y: frame.size.height - 10))
            self.movingButtons.append(movingButton)
            self.addSubview(movingButton)
            break
        case .line:
            let movingStartButton = makebutton(center: CGPoint(x: 10, y: 10))
            let movingEndButton = makebutton(center: CGPoint(x: frame.size.width - 10, y: frame.size.height - 10))
            self.movingButtons.append(movingStartButton)
            self.movingButtons.append(movingEndButton)
            self.addSubview(movingStartButton)
            self.addSubview(movingEndButton)
            break
        case .ankleLine:
            let movingStartButton = makebutton(center: CGPoint(x: frame.size.width - 10, y: 10))
            let movingCenterButton = makeAnkleCenterButton(center: CGPoint(x: (frame.size.width/2) - 10, y: (frame.size.height/2) - 10))
            let movingEndButton = makebutton(center: CGPoint(x: frame.size.width - 10, y: frame.size.height - 10))
            self.movingButtons.append(movingStartButton)
            self.movingButtons.append(movingCenterButton)
            self.movingButtons.append(movingEndButton)
            self.addSubview(movingStartButton)
            self.addSubview(movingCenterButton)
            self.addSubview(movingEndButton)
            break
        }
        
        self.setLineColor()
    }
    
    func makebutton(center:CGPoint) -> UIButton {
        
        var btn:UIButton  = UIButton(type: .system)
        btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.backgroundColor = self.lineColor
        btn.center = center
        btn.setImage(UIImage(named : "ico_player_draw_size", in : Bundle(for: self.classForCoder), compatibleWith: nil), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(self.panned(gesture:)))
        pangesture.maximumNumberOfTouches = 1
        btn.addGestureRecognizer(pangesture)
        
        return btn
    }
    
    func makeAnkleCenterButton(center:CGPoint) -> UIButton {
        
        var btn:UIButton  = UIButton(type: .system)
        btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.backgroundColor = self.lineColor
        btn.center = center
        btn.tag = 100
        btn.setTitle("C", for: .normal)
//        btn.setImage(UIImage(named : "ico_player_draw_size", in : Bundle(for: self.classForCoder), compatibleWith: nil), for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.isUserInteractionEnabled = false
//        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(self.panned(gesture:)))
//        pangesture.maximumNumberOfTouches = 1
//        btn.addGestureRecognizer(pangesture)
        
        return btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.lineColor = .clear
        super.init(coder: aDecoder)
        self.setLineColor()
        
        switch shapeType {
        case .circle,.rect:
            let movingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingButton.backgroundColor = .yellow
            movingButton.center = CGPoint(x: 10, y: 10)
            self.movingButtons.append(movingButton)
            break
        case .line:
            let movingStartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingStartButton.backgroundColor = .yellow
            movingStartButton.center = CGPoint(x: 10, y: 10)
            self.movingButtons.append(movingStartButton)
            let movingEndButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingEndButton.backgroundColor = .yellow
            movingEndButton.center = CGPoint(x: frame.size.width - 10, y: frame.size.height - 10)
            self.movingButtons.append(movingEndButton)
            break
        case .ankleLine:
            let movingStartButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingStartButton.backgroundColor = .yellow
            movingStartButton.center = CGPoint(x: frame.size.width - 10, y: 10)
            self.movingButtons.append(movingStartButton)
            let movingCenterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingCenterButton.backgroundColor = .yellow
            movingCenterButton.center = CGPoint(x: (frame.size.width/2) - 10, y: (frame.size.height/2) - 10)
            self.movingButtons.append(movingCenterButton)
            let movingEndButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            movingEndButton.backgroundColor = .yellow
            movingEndButton.center = CGPoint(x: frame.size.width - 10, y: frame.size.height - 10)
            self.movingButtons.append(movingEndButton)
            break
        }
    }
    
    internal func undo() {
        self.undoManager?.undo()
        if true != self.undoManager?.canUndo {
            self.registerUndo()
        }
    }
    
    internal func registerUndo() {
        
        let frame = self.frame
        let color = self.lineColor.copy() as! UIColor

        if #available(iOS 9.0, *) {
            let startMovingButtonFrame = self.movingButtons.first!.frame
            var endMovingButtonFrame:CGRect? = .zero
            
            var centerMovingButtonFrame:CGRect? = .zero
            if shapeType == .ankleLine {
                centerMovingButtonFrame = self.movingButtons[1].frame
            }
            
            if movingButtons.count >= 2 {
                endMovingButtonFrame = self.movingButtons.last!.frame
            }
            self.undoManager?.registerUndo(withTarget: self, handler: { (me) in
                
                self.frame = frame
                self.lineColor = color
                self.setLineColor()
                self.movingButtons.first!.frame = startMovingButtonFrame
            
                if self.shapeType == .ankleLine {
                    self.movingButtons[1].frame = centerMovingButtonFrame!
                }
                
                if self.movingButtons.count >= 2 {
                    self.movingButtons.last!.frame = endMovingButtonFrame!
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    internal func isMovalble(on point: CGPoint) -> Bool {
        if self.isSelected {
            switch shapeType {
            case .ankleLine:
                let btn = movingButtons[1]
                let target_point:CGPoint = CGPoint(x: btn.center.x + self.frame.origin.x,
                                                   y: btn.center.y + self.frame.origin.y)
                return target_point.distance(to: point) < 20
            default:
                let movableRect = CGRect(x: center.x - 10, y: center.y - 10, width: 20, height: 20)
                return movableRect.contains(point)
            }
            
        }
        return false
    }
    
    internal func isSelectable(on point: CGPoint) -> Bool {
        
        switch shapeType {
        case .circle:
            return self.center.distance(to: point) < self.frame.size.width / 2
        case .rect:
            var selectableRect = self.frame
            
            selectableRect.origin.x += 10
            selectableRect.origin.y += 10
            selectableRect.size.width -= 20
            selectableRect.size.height -= 20
            
            return selectableRect.contains(point)
        case .line:
            return self.center.distance(to: point) < 20
        case .ankleLine:
            let btn = movingButtons[1]
            let target_point:CGPoint = CGPoint(x: btn.center.x + self.frame.origin.x,
                                               y: btn.center.y + self.frame.origin.y)
            return target_point.distance(to: point) < 20
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if self.isSelected {
            
            switch shapeType {
            case .ankleLine:
                let btn = movingButtons[1]
                if let image = UIImage(named : "ico_player_draw_move", in : Bundle(for: self.classForCoder), compatibleWith: nil) {
                    btn.setImage(image, for: .normal)
                    btn.setTitle("", for: .normal)
                }
                
            default:
                if let image = UIImage(named : "ico_player_draw_move", in : Bundle(for: self.classForCoder), compatibleWith: nil) {
                    let drawingPoint = CGPoint(x: (rect.size.width - image.size.width) / 2, y: (rect.size.height - image.size.width) / 2)
                    image.draw(at: drawingPoint)
                }
                break
            }
            
            
        }
        
        switch shapeType {
        case .circle:
            self.lineColor.setStroke()
            var bezierRect = rect
            bezierRect.origin.x += 10
            bezierRect.origin.y += 10
            bezierRect.size.width -= 20
            bezierRect.size.height -= 20
            let bezier = UIBezierPath(ovalIn: bezierRect)
            
            let shape:Shape = Shape()
            shape.makeShapeCircle(bezier: bezier)
            break
        case .rect:
            self.lineColor.setStroke()
            let shape:Shape = Shape()
            shape.makeShapeRect(context: UIGraphicsGetCurrentContext(), rect: rect)
            break
        case .line:
            self.lineColor.setStroke()
            let shape:Shape = Shape()
            shape.makeShapeLine(context: UIGraphicsGetCurrentContext(), firstCenter: (self.movingButtons.first?.center)!, lastCenter: (self.movingButtons.last?.center)!)
            break
        case .ankleLine:
            self.lineColor.setStroke()
            let shape:Shape = Shape()
            shape.makeShapeAnkleLine(context: UIGraphicsGetCurrentContext(),
                                     firstCenter: (self.movingButtons.first?.center)!, centerCenter: (self.movingButtons[1].center), lastCenter: (self.movingButtons.last?.center)!)
            break
        }
    }
    
    @objc internal func panned(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            self.registerUndo()
        }
        
        switch shapeType {
        case .circle:
            if let touchedButton = gesture.view as? UIButton {
                let innerLocation = gesture.location(in: self)
                let innerCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
                let distance = innerCenter.distance(to: innerLocation) * 2 + 20
                let x = self.center.x - distance / 2
                let y = self.center.y - distance / 2
                self.frame = CGRect(x: x, y: y, width: distance, height: distance)
                touchedButton.center = gesture.location(in: self)
            }
            break
        case .rect:
            if let touchedButton = gesture.view as? UIButton {
                let location = gesture.location(in: self.superview)
                let width = abs(self.center.x - location.x) * 2 + 20
                let height = abs(self.center.y - location.y) * 2 + 20
                let x = self.center.x - width / 2
                let y = self.center.y - height / 2
                self.frame = CGRect(x: x, y: y, width: width, height: height)
                touchedButton.center = gesture.location(in: self)
            }
            break
        case .line:
            guard let touchedButton = gesture.view as? UIButton,
                let otherButtonIndex = self.movingButtons.index(where: { $0 != gesture.view }) else {
                    return
            }
            
            let touchPoint = gesture.location(in: self.superview)
            let touchPointInSelf = gesture.location(in: self)
            let otherButton = self.movingButtons[otherButtonIndex]
            let otherXinSuperView = otherButton.center.x + self.frame.origin.x
            let otherYinSuperView = otherButton.center.y + self.frame.origin.y
            let x = min(otherXinSuperView, touchPoint.x) - 10
            let y = min(otherYinSuperView, touchPoint.y) - 10
            let width = abs(otherXinSuperView - touchPoint.x) + 20
            let height = abs(otherYinSuperView - touchPoint.y) + 20
            let xtranslated = frame.origin.x - x
            let ytranslated = frame.origin.y - y
            self.frame = CGRect(x: x, y: y, width: width, height: height)
            
            let otherBtnX = otherButton.center.x + xtranslated
            let otherBtnY = otherButton.center.y + ytranslated
            let touchBtnX = touchPointInSelf.x
            let touchBtnY = touchPointInSelf.y
            
            otherButton.center = CGPoint(x: otherBtnX,
                                         y: otherBtnY)
            touchedButton.center = CGPoint(x: touchBtnX,
                                           y: touchBtnY)
            break
        case .ankleLine:
            guard let touchedButton = gesture.view as? UIButton,
                  let otherButtonIndex = self.movingButtons.index(where: { $0 != gesture.view && $0.tag != 100 }) else {
                    return
            }
            
            let touchPoint = gesture.location(in: self.superview)
            let touchPointInSelf = gesture.location(in: self)

            let centerButton = self.movingButtons[1]
            let centerXinSuperView = centerButton.center.x + self.frame.origin.x
            let centerYinSuperView = centerButton.center.y + self.frame.origin.y
            
            let otherButton = self.movingButtons[otherButtonIndex]
            let otherXinSuperView = otherButton.center.x + self.frame.origin.x
            let otherYinSuperView = otherButton.center.y + self.frame.origin.y
            
            let x = min(otherXinSuperView, touchPoint.x, centerXinSuperView) - 20
            let y = min(otherYinSuperView, touchPoint.y, centerYinSuperView) - 20
            
            let xtranslated = frame.origin.x - x
            let ytranslated = frame.origin.y - y
//            self.frame = CGRect(x: x, y: y, width: width, height: height)
                        
            let otherBtnX = otherButton.center.x + xtranslated
            let otherBtnY = otherButton.center.y + ytranslated
            let touchBtnX = touchPointInSelf.x
            let touchBtnY = touchPointInSelf.y
            
            otherButton.center = CGPoint(x: otherBtnX,
                                         y: otherBtnY)
            touchedButton.center = CGPoint(x: touchBtnX,
                                           y: touchBtnY)
            
            let centerBtnX = centerButton.center.x + xtranslated
            let centerBtnY = centerButton.center.y + ytranslated
            centerButton.center = CGPoint(x: centerBtnX,
                                           y: centerBtnY)

            let min_x = min(otherBtnX, centerBtnX, touchBtnX) + self.frame.origin.x
            let min_y = min(otherBtnY, centerBtnY, touchBtnY) + self.frame.origin.y
            let max_x = max(otherBtnX, centerBtnX, touchBtnX) + self.frame.origin.x
            let max_y = max(otherBtnY, centerBtnY, touchBtnY) + self.frame.origin.y
            
            let width = abs(max_x - min_x) + 80
            let height = abs(max_y - min_y) + 80

            self.frame = CGRect(x: x, y: y, width: width, height: height)

            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.blue.cgColor
            
            break
        }
        self.setNeedsDisplay()
    }
}



