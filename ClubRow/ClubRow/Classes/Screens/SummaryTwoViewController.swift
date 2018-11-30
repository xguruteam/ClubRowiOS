//
//  SummaryTwoViewController.swift
//  ClubRow
//
//  Created by Luccas on 10/10/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit
import EChart

class SummaryTwoViewController: SuperViewController , EColumnChartDelegate, EColumnChartDataSource{
    
    func eColumnChart(_ eColumnChart: EColumnChart!, didSelect eColumn: EColumn!) {
        
    }
    
    func eColumnChart(_ eColumnChart: EColumnChart!, fingerDidEnter eColumn: EColumn!) {
//        let eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25
//        var eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * CGFloat(1 - eColumn.grade)
//        if (eFloatBox != nil){
//            eFloatBox?.removeFromSuperview()
//            eFloatBox?.frame = CGRect.init(x: eFloatBoxX, y: eFloatBoxY, width: (eFloatBox?.frame.size.width)!, height: eFloatBox!.frame.size.height)
//            eFloatBox?.value = eColumn.eColumnDataModel.value
//            viewChart .addSubview(eFloatBox!)
//        } else {
//            eFloatBox = EFloatBox.init(position: CGPoint.init(x: eFloatBoxX, y: eFloatBoxY), value: eColumn!.eColumnDataModel.value, unit: "kWh", title: "Title")
//            eFloatBox?.alpha = 0.0
//            eColumnChart.addSubview(eFloatBox!)
//        }
//        eFloatBoxY = eFloatBoxY - ((eFloatBox?.frame.size.height)! + eColumn.frame.size.width * 0.25)
//        eFloatBox?.frame = CGRect.init(x: eFloatBoxX, y: eFloatBoxY, width: (eFloatBox?.frame.size.width)!, height: (eFloatBox?.frame.size.height)!)
    }
    
    func eColumnChart(_ eColumnChart: EColumnChart!, fingerDidLeave eColumn: EColumn!) {
        
    }
    
    
    func fingerDidLeave(_ eColumnChart: EColumnChart!) {
        
    }
    
    func numberOfColumns(in eColumnChart: EColumnChart!) -> Int {
        return data.count
    }
    
    func number(ofColumnsPresentedEveryTime eColumnChart: EColumnChart!) -> Int {
        return 7
    }
    
    func highestValueEColumnChart(_ eColumnChart: EColumnChart!) -> EColumnDataModel! {
        var maxModel: EColumnDataModel? = nil
        var maxValue = -Float.leastNormalMagnitude
        for model in data {
            let item = model as! EColumnDataModel
            if (item.value > maxValue){
                maxValue = item.value
                maxModel = item
            }
        }
        return maxModel
    }
    
    func eColumnChart(_ eColumnChart: EColumnChart!, valueFor index: Int) -> EColumnDataModel! {
        if (index >= data.count || index < 0){
            return nil;
        }
        return (data.object(at: index) as! EColumnDataModel)
    }
    
    
    var viewChart: EColumnChart!
    var data = NSArray()
    var eFloatBox:EFloatBox? = nil
 
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewChart = EColumnChart.init(frame: viewContainer.frame)
        
        // Do any additional setup after loading the view.
        let temp = NSMutableArray.init()
        for i in 0..<50 {
            let val = arc4random() % 100
            let model = EColumnDataModel.init(label: String.init(format: "%d", i), value: Float(val), index: i, unit: "k+")
            temp.add(model as Any)
        }
        data = temp
        
        viewChart.normalColumnColor = UIColor.green
        viewChart.maxColumnColor = UIColor.green
        viewChart.minColumnColor = UIColor.green

        viewChart.showHighAndLowColumnWithColor = true

        viewChart.columnsIndexStartFromLeft = true
        viewChart.delegate = self
        viewChart.dataSource = self
        
        
        tableview.addSubview(viewChart)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.viewChart.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.viewChart.addGestureRecognizer(swipeLeft)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                if (viewChart != nil){
                    viewChart.moveLeft()
                }
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                if (viewChart != nil){
                    viewChart.moveRight()
                }
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @IBAction func onSummary(_ sender: Any) {
        let vc = self.getStoryboardWithIdentifier(identifier: "SummaryViewController") as! SummaryViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
