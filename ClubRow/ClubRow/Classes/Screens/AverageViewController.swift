//
//  AverageViewController.swift
//  ClubRow
//
//  Created by Guru on 1/4/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class AverageViewController: UIViewController {

    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblCalories: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblStroke: UILabel!
    @IBOutlet weak var lblWattage: UILabel!
    
    
    var type: String = "day"
    
    var distance:NSNumber = 0
    var calories: NSNumber = 0
    var speed: NSNumber = 0
    var stroke: NSNumber = 0
    var wattage: NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        reloadData()

        updateUI()

    }
    
    func updateUI() {
        if self.lblDistance == nil {
            return
        }
            lblDistance.text = "\(distance)"
            lblCalories.text = "\(calories)"
            lblSpeed.text = "\(speed)"
            lblStroke.text = "\(stroke)"
            lblWattage.text = "\(wattage)"
    }
    
    func reloadData() {
        
        // API
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Token token=\(appDelegate.g_token)"
        ]
        let url = SERVER_URL + KEY_API_LOAD_AVERAGE + "?period=\(self.type)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                var error = false
                switch response.result
                {
                case .failure( _):
                    error = true
                    
                case .success( _):
                    
                    guard let raw = response.result.value as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    guard let data = raw["data"] as? [String: Any] else {
                        error = true
                        break
                    }
                    
                    self.distance = data["distance"] as? NSNumber ?? 0
                    self.calories = data["calories"] as? NSNumber ?? 0
                    self.speed = data["speed"] as? NSNumber ?? 0
                    self.stroke = data["strokes_per_minute"] as? NSNumber ?? 0
                    self.wattage = data["wattage"] as? NSNumber ?? 0


                }
                if error == true {
                    DispatchQueue.main.async(execute: {
                        self.distance = 0
                        self.calories = 0
                        self.speed = 0
                        self.stroke = 0
                        self.wattage = 0
                        self.updateUI()
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {
                        self.updateUI()
                    })
                }
        }
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
