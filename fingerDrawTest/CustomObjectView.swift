//
//  CustomObjectView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/09/01.
//

import UIKit
enum SHAPE_TYPE {
    case SHAPE_RECT
    case SHAPE_CIRCLE
}

class CustomObjectView: UIView {
    var view:UIView!
    @IBOutlet var realView: UIView!

    @IBOutlet var tempImageView: UIImageView!
    
    var type:SHAPE_TYPE = .SHAPE_RECT
    
    var isTopRightBtnMode:Bool = false
    var isTopLeftBtnMode:Bool = false
    var isBottomLeftBtnMode:Bool = false
    var isBottomRightBtnMode:Bool = false
    var isCenterBtnMode:Bool = false
    
    @IBOutlet var coverView: UIView!
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
            view = (Bundle.main.loadNibNamed("CustomObjectView", owner: self, options: nil)?.first as! UIView)
            
            guard let content = view else { return }
            content.frame = self.bounds
            self.addSubview(content)
        }
    }
    
    @IBAction func touchDownBtn(_ sender: Any) {
        let tag = (sender as! UIButton).tag
        
        if tag == 0 {
            isTopLeftBtnMode = true
        } else if tag == 1 {
            isTopRightBtnMode = true
        } else if tag == 2 {
            isBottomLeftBtnMode = true
        } else if tag == 3 {
            isBottomRightBtnMode = true
        } else if tag == 4 {
            isCenterBtnMode = true
        }
    }
    
    func makeRect(){
        tempImageView.layer.borderWidth = 1
        tempImageView.layer.borderColor = UIColor.red.cgColor
        
        self.type = .SHAPE_RECT
    }
    
    func makeCircle(){
        tempImageView.layer.borderWidth = 1
        tempImageView.layer.borderColor = UIColor.red.cgColor
        tempImageView.layer.cornerRadius = tempImageView.frame.size.height / 2
        
        self.type = .SHAPE_CIRCLE 
    }
    
}
