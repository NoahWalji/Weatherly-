//
//  AdditionalInfoController.swift
//  Weatherly!
//
//  Created by Noah Walji on 2019-10-23.
//  Copyright © 2019 Noah Walji. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class AdditionalInfoController: UIViewController {
    
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visabilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    
    var weatherJSON: JSON = []
    var sunriseTS : Double = 0
    var sunsetTS : Double = 0
    var windSpeed : Int = 0
    var visability : Int = 0
    var pressure : Int = 0
    
    var sunsetDate  = Date()
    var sunriseDate = Date()
    var sunriseString : String = ""
    var sunsetString : String = ""
    
    var sunsetdateFormatter = DateFormatter()
    var sunrisedateFormatter = DateFormatter()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAdditionalInfo(json: weatherJSON)

        // Do any additional setup after loading the view.
    }
    
    
    func updateAdditionalInfo(json: JSON)
    {
        let sunriseTime = json["data"][0]["sunrise_ts"].double
        let sunsetTime = json["data"][0]["sunset_ts"].double
        let windSpeedData = json["data"][0]["wind_spd"].int
        let visabilityData = json["data"][0]["vis"].int
        let pressureData = json["data"][0]["pres"].int
        
        sunriseTS = sunriseTime!
        sunsetTS = sunsetTime!
        windSpeed = windSpeedData!
        visability = visabilityData!
        pressure = pressureData!
        setHourDates(sunriseData: sunriseTS, sunsetData: sunsetTS)
        
    }
    
    func setHourDates(sunriseData: Double, sunsetData: Double)
    {
        sunsetdateFormatter.dateFormat = "HH:MM"
        sunrisedateFormatter.dateFormat = "H:MM"
        sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunriseData))
        sunsetDate = Date(timeIntervalSince1970: sunsetData)
        
        sunriseString = sunrisedateFormatter.string(from: sunriseDate)
        sunsetString = sunsetdateFormatter.string(from: sunsetDate)
        updateUI()
        
        
        
        
    }
    
    func updateUI()
    {
        sunriseLabel.text = sunriseString + " AM"
        sunsetLabel.text = sunsetString + " PM"
        windSpeedLabel.text = String(windSpeed) + " km/h"
        visabilityLabel.text = String(visability) + " km"
        pressureLabel.text = String(pressure) + " hPA"
        
    }

}
