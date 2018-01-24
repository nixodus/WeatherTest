//
//  WeatherDataModel.swift
//  WeatherTest
//
//  Created by Nicholas Piotrowski on 23/01/2018.
//  Copyright © 2018 Nicholas Piotrowski. All rights reserved.
//

import UIKit

class WeatherDataModel {
    
    
    var temperatureMin : Int = 0
    var temperatureMax : Int = 0
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var weatherConditionLabel : String = ""
    var unixtimeInterval : Double = 0
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "Thunderstorm Mini"
            
        case 301...500 :
            return "Rain Mini"
            
        case 501...600 :
            return "Rain"
            
        case 601...700 :
            return "Snow Mini"
            
        case 701...771 :
            return "Partially Cloudy"
            
        case 772...799 :
            return "Thunderstorm"
            
        case 800 :
            return "Clear"
            
        case 800 :
            return "Clouds"
            
        case 801...804 :
            return "Partially Cloudy Copy"
            
        case 900...903, 905...1000  :
            return "Thunderstorm"
            
        case 903 :
            return "Snow"
            
        case 904 :
            return "Clear"
            
        default :
            return "Clear Mini"
        }
        
    }
}
