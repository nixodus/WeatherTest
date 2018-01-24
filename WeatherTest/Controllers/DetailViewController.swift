//
//  DetailViewController.swift
//  WeatherTest
//
//  Created by Nicholas Piotrowski on 24/01/2018.
//  Copyright © 2018 Nicholas Piotrowski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = weatherDataModel.city
        temperatureMaxLabel.text = "max:"+String(weatherDataModel.temperatureMax)+"℃"
        temperatureMinLabel.text = "min:"+String(weatherDataModel.temperatureMin)+"℃"
        weatherConditionLabel.text = weatherDataModel.weatherConditionLabel
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        let date = Date(timeIntervalSince1970: weatherDataModel.unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
