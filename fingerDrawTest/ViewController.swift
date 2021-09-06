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

