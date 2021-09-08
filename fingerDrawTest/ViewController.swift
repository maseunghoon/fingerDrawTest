//
//  ViewController.swift
//  fingerDrawTest
//
//  Created by maseunghoon on 2021/08/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var drawingView: DrawingView!
    var selectedColor:UIColor! = UIColor.red
    
    //    @IBOutlet var myRectParentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func addCircle(_ sender: Any) {
        let circle = ShapeManager(frame: CGRect(x: drawingView.frame.size.width / 2 - 50,
                                                y: drawingView.frame.size.height / 2 - 50,
                                                width: 100,
                                                height: 100),
                                  lineColor: selectedColor, shapeType:.circle)
        drawingView.add(shape: circle)
    }
    
    @IBAction func addRect(_ sender: Any) {
        let rect = ShapeManager(frame: CGRect(x: drawingView.frame.size.width / 2 - 50,
                                              y: drawingView.frame.size.height / 2 - 50,
                                              width: 100,
                                              height: 100),
                                lineColor: selectedColor, shapeType:.rect)
        drawingView.add(shape: rect)
    }
    
    @IBAction func addLine(_ sender: Any) {
        let line = ShapeManager(frame: CGRect(x: drawingView.frame.size.width / 2 - 50,
                                              y: drawingView.frame.size.height / 2 - 50,
                                              width: 100,
                                              height: 100),
                                lineColor: selectedColor, shapeType:.line)
        drawingView.add(shape: line)
    }
    
    @IBAction func addAngleLine(_ sender: Any) {
        let angle = ShapeManager(frame: CGRect(x: drawingView.frame.size.width / 2 - 50,
                                              y: drawingView.frame.size.height / 2 - 50,
                                              width: 100,
                                              height: 100),
                                lineColor: selectedColor, shapeType:.angleLine)
        drawingView.add(shape: angle)
    }
    
    
    @IBOutlet var colorButtonCollection: [UIButton]!
    @IBAction func clickColorBtn(_ sender: Any) {
        for it in colorButtonCollection {
            it.isSelected = false
        }
        
        let btn = sender as! UIButton
        btn.isSelected = true
        let tag = btn.tag
        
        switch tag {
        case 0:
            selectedColor = UIColor.red
            break
        case 1:
            selectedColor = UIColor.blue
            break
        case 2:
            selectedColor = UIColor.green
            break
        case 3:
            selectedColor = UIColor.yellow
            break
        default:
            break
        }
    }
    
    @IBAction func undo(_ sender: Any) {
        drawingView.undoSelectedShape()
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        drawingView.removeSelectedShape()
    }
    
    @IBAction func reset(_ sender: Any) {
        drawingView.clear()
    }
    
    @IBAction func selectColor(_ sender: Any) {
        self.drawingView.setSelectedShapeColor(self.selectedColor)
    }
    
}

