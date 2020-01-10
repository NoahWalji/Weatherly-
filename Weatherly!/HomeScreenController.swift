//
//  ViewController.swift
//  Weatherly!
//
//  Created by Noah Walji on 2019-10-16.
//  Copyright © 2019 Noah Walji. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}

class HomeScreenController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var day6: UILabel!
    @IBOutlet weak var day7: UILabel!
    
    @IBOutlet weak var day1temp: UILabel!
    @IBOutlet weak var day2temp: UILabel!
    @IBOutlet weak var day3temp: UILabel!
    @IBOutlet weak var day4temp: UILabel!
    @IBOutlet weak var day5temp: UILabel!
    @IBOutlet weak var day6temp: UILabel!
    @IBOutlet weak var day7temp: UILabel!
    
    @IBOutlet weak var day1low: UILabel!
    @IBOutlet weak var day2low: UILabel!
    @IBOutlet weak var day3low: UILabel!
    @IBOutlet weak var day4low: UILabel!
    @IBOutlet weak var day5low: UILabel!
    @IBOutlet weak var day6low: UILabel!
    @IBOutlet weak var day7low: UILabel!
    
    
    
    
    let WEATHER_DATA_CURRENT = "http://api.weatherbit.io/v2.0/current"
    let WEATHER_DATA_DAILY = "http://api.weatherbit.io/v2.0/forecast/daily"
    let APP_ID = "f4e3b1177de743649c8b8f7abceb6ab0"
    
    
    var temperature : Int = 0
    var currentHigh : Int = 0
    var currentLow : Int = 0
    var stringCondition : String = ""
    var tempday1 : Int = 0
    var tempday2 : Int = 0
    var tempday3 : Int = 0
    var tempday4 : Int = 0
    var tempday5 : Int = 0
    var tempday6 : Int = 0
    var tempday7 : Int = 0
    
    var lowday1 : Int = 0
    var lowday2 : Int = 0
    var lowday3 : Int = 0
    var lowday4 : Int = 0
    var lowday5 : Int = 0
    var lowday6 : Int = 0
    var lowday7 : Int = 0
    
    var condition : Int = 0
    var city : String = ""
    var quote : String = ""
    
    var weatherJSON : JSON = []
    let locationManager = CLLocationManager()
    
    var dayFormatter = DateFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is AdditionalInfoController
        {
            let vc = segue.destination as? AdditionalInfoController
            vc?.weatherJSON = self.weatherJSON
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0
        {
            locationManager.stopUpdatingLocation()
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let params : [String: String] = ["key" : APP_ID, "lat" : String(latitude), "lon" : String(longitude)]
            
            getWeatherCurrent(url: WEATHER_DATA_CURRENT, parameters: params)
            getWeatherDaily(url: WEATHER_DATA_DAILY, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Currently Unavialable"
        print(error)
    }
    
    func getWeatherCurrent(url: String, parameters: [String: String])
    {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON
        {
            response in
            if response.result.isSuccess
            {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            
            else
            {
                self.cityLabel.text = "Location Unavailable"
                print(response.result.error)
            }
                
        }
        
    }
    
    func getWeatherDaily(url: String, parameters: [String: String])
    {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON
        {
            response in
            if response.result.isSuccess
            {
                self.weatherJSON = JSON(response.result.value!)
                self.updateWeatherDataDaily(json: self.weatherJSON)
            }
            
            else
            {
                self.cityLabel.text = "Location Unavailable"
                print(response.result.error)
            }
                
        }
    }
    
    
    func updateWeatherData(json: JSON)
    {
        let tempData = json["data"][0]["temp"].int
        let cityData = json["data"][0]["city_name"].stringValue

        let condition = json["data"][0]["weather"]["description"].stringValue
    
        temperature = tempData!
        stringCondition = condition
        city = cityData
        updateView()
        
    }
    
    func updateWeatherDataDaily(json: JSON)
    {
        let cHigh = json["data"][0]["max_temp"].int
        let cLow = json["data"][0]["app_min_temp"].int
        let tempday1data = json["data"][1]["max_temp"].int
        let tempday2data = json["data"][2]["max_temp"].int
        let tempday3data = json["data"][3]["max_temp"].int
        let tempday4data = json["data"][4]["max_temp"].int
        let tempday5data = json["data"][5]["max_temp"].int
        let tempday6data = json["data"][6]["max_temp"].int
        let tempday7data = json["data"][7]["max_temp"].int
        
        let lowday1data = json["data"][1]["app_min_temp"].int
        let lowday2data = json["data"][2]["app_min_temp"].int
        let lowday3data = json["data"][3]["app_min_temp"].int
        let lowday4data = json["data"][4]["app_min_temp"].int
        let lowday5data = json["data"][5]["app_min_temp"].int
        let lowday6data = json["data"][6]["app_min_temp"].int
        let lowday7data = json["data"][7]["app_min_temp"].int
        
        tempday1 = tempday1data!
        tempday2 = tempday2data!
        tempday3 = tempday3data!
        tempday4 = tempday4data!
        tempday5 = tempday5data!
        tempday6 = tempday6data!
        tempday7 = tempday7data!
        
        lowday1 = lowday1data!
        lowday2 = lowday2data!
        lowday3 = lowday3data!
        lowday4 = lowday4data!
        lowday5 = lowday5data!
        lowday6 = lowday6data!
        lowday7 = lowday7data!
        
        currentLow = cLow!
        currentHigh = cHigh!
        
        updateView()
        
    }
    
    func updateQuote()
    {
        if temperature < 0
        {
            quote = "Gosh it's cold! Stay in & binge!"
        }
        
        else if  0 < temperature && temperature < 10
        {
            quote = "It's a decent day, but take a hoodie"
        }
        
        else if 10 < temperature && temperature < 20
        {
            quote = "It's warm today, enjoy it while it lasts!"
        }
        
        else if temperature > 20
        {
            quote = "Shorts, T-Shirts & Sunscreen!"
        }
    }
    
    func updateDate()
    {
        dayFormatter.dateFormat = "EEEE"
        dayFormatter.timeZone = TimeZone.current
        let tommorow = Date().dayAfter
        let day2String = tommorow.dayAfter
        let day3String = day2String.dayAfter
        let day4String = day3String.dayAfter
        let day5String = day4String.dayAfter
        let day6String = day5String.dayAfter
        let day7String = day6String.dayAfter
        
        let day1text = dayFormatter.string(from: tommorow)
        let day2text = dayFormatter.string(from: day2String)
        let day3text = dayFormatter.string(from: day3String)
        let day4text = dayFormatter.string(from: day4String)
        let day5text = dayFormatter.string(from: day5String)
        let day6text = dayFormatter.string(from: day6String)
        let day7text = dayFormatter.string(from: day7String)
        
        day1.text = day1text
        day2.text = day2text
        day3.text = day3text
        day4.text = day4text
        day5.text = day5text
        day6.text = day6text
        day7.text = day7text
        
    }
    
    func updateView()
    {
        cityLabel.text = city
        tempLabel.text = String(temperature) + "°"
        currentHighLabel.text = String(currentHigh) + "°"
        currentLowLabel.text = String(currentLow) + "°"
        conditionLabel.text = stringCondition
        updateQuote()
        quoteLabel.text = quote
        
        day1temp.text = String(tempday1) + "°"
        day2temp.text = String(tempday2) + "°"
        day3temp.text = String(tempday3) + "°"
        day4temp.text = String(tempday4) + "°"
        day5temp.text = String(tempday5) + "°"
        day6temp.text = String(tempday6) + "°"
        day7temp.text = String(tempday7) + "°"
        
        day1low.text = String(lowday1) + "°"
        day2low.text = String(lowday2) + "°"
        day3low.text = String(lowday3) + "°"
        day4low.text = String(lowday4) + "°"
        day5low.text = String(lowday5) + "°"
        day6low.text = String(lowday6) + "°"
        day7low.text = String(lowday7) + "°"
        updateDate()
        
        
    }
    
    


}

