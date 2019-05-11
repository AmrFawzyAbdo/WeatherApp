//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Amr fawzy on 5/7/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherVC: UIViewController , CLLocationManagerDelegate , ChangeCityDelegate {
  
    

    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "051f7d65af99d9158d6485893cdb4618"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        
        // accuracy belzbt
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // popup request
        locationManager.requestWhenInUseAuthorization()
        
        // when the location manager looking for current device cordinates using GPS , it work in the background to prevent the app from freezing up while working in the foreground
        locationManager.startUpdatingLocation()
        
    }
    
    
    func getWeatherData(url: String , parameters : [String:String]){
        Alamofire.request(url , method : .get , parameters : parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON = JSON(response.result.value!)
                print(weatherJSON)
                
                
                
                self.updateWeatherData(json: weatherJSON)
                
            }else{
                print(response.result.error)
            }        }
    }
    
    
    func updateWeatherData(json : JSON){
        
        // i will make it  with if to unforce temp! ..
        
        if let temp = json["main"]["temp"].double {
            //        let name = json["name"]
            weatherDataModel.temperature = Int(temp - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
            
        }
        else {
            cityLabel.text = "Weather unavaliable"
        }
    }
    
    
    
    func updateUIWithWeatherData(){
        cityLabel.text = self.weatherDataModel.city
        temperatureLabel.text = "\(self.weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named:self.weatherDataModel.weatherIconName)
    }
    
    
    
    // Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String:String] = ["lat" : latitude , "lon" : longitude , "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }
    
    
    
    func userEnteredANewCityName(city: String) {
        let params : [String:String] = ["q" : city , "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityVC
            
            destinationVC.delegate = self
        }
    }

}

