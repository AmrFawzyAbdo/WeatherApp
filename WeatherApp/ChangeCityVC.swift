//
//  ChangeCityVC.swift
//  WeatherApp
//
//  Created by Amr fawzy on 5/7/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import Foundation
import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(city:String)
}

class ChangeCityVC : UIViewController{
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func getWeather(_ sender: Any) {
    
    let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city :cityName)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

