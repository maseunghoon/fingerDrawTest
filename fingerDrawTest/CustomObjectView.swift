//
//  CustomObjectView.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/09/01.
//

import UIKit

class CustomObjectView: UIView {
    var view:UIView!
    @IBOutlet var realView: UIView!
    var isEndBtnMode:Bool = false
    
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

    @IBAction func clickEndBtn(_ sender: Any) {
        print("touch up inside end btn.!")
    }
    
    @IBAction func touchDownEndBtn(_ sender: Any) {
        print("touch down end btn.")
        isEndBtnMode = true
    }
    
    @IBAction func touchupOutsideEndBtn(_ sender: Any) {
        print("touch up outside end btn.!")
    }
    
    @IBAction func touchCancelEndBtn(_ sender: Any) {
        print("touch cancel end btn.")
//        isEndBtnMode = false
    }
}
