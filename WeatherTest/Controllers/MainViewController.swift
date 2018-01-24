//
//  ViewController.swift
//  WeatherTest
//
//  Created by Nicholas Piotrowski on 23/01/2018.
//  Copyright © 2018 Nicholas Piotrowski. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cityInput: UITextField!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/"
    let WEATHER_URL_SUFIX_FORECAST = "forecast/daily"
    let WEATHER_URL_SUFIX_TODAY = "weather"
    let APP_ID = "API_KEY"
    let FORECAST_DAYS = "11"
    let START_CITY = "London"
    
    var weatherDataModel = WeatherDataModel()
    var forecastArray = [WeatherDataModel]()
    
    var accessoryDoneButton: UIBarButtonItem!
    let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ForecastViewCell", bundle: nil), forCellReuseIdentifier: "forecastCell")
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        self.accessoryToolBar.items = [flexBarButton, self.accessoryDoneButton]
        self.cityInput.inputAccessoryView = self.accessoryToolBar
        
        cityInput.text = START_CITY
        userEnteredANewCityName(city: START_CITY)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastViewCell
        
        let recordDataModel = forecastArray[indexPath.row]
        
        cell.temperatureMinLabel.text = String(recordDataModel.temperatureMin)+"℃"
        cell.temperatureMaxLabel.text = String(recordDataModel.temperatureMax)+"℃"
        cell.conditionLabel.text = recordDataModel.weatherConditionLabel
        cell.conditionIcon.image = UIImage(named: recordDataModel.weatherIconName)
        
        let date = Date(timeIntervalSince1970: recordDataModel.unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        cell.dayOfWeekLabel.text = dateFormatter.string(from: date)
        
        return cell
        
    }
    
    //MARK: - Networking
    
    func getWeatherData(url: String, parameters : [String : String], sufix: String){
        
        Alamofire.request(url+sufix, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                let weatherJSON : JSON = JSON(response.result.value!)
                
                if(sufix == self.WEATHER_URL_SUFIX_FORECAST){
                    self.updateWeatherTableData(json: weatherJSON)
                }else if (sufix == self.WEATHER_URL_SUFIX_TODAY){
                    self.updateWeatherTodayData(json: weatherJSON)
                }
                
            }else{
                print("Error: \(String(describing: response.result.error))")
                let alert = UIAlertController(title: "Connection Issues", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func updateWeatherTableData(json : JSON){
        
        if  let listResult = json["list"].array{
            forecastArray.removeAll()
            for record in listResult {
                let recordDataModel = WeatherDataModel()
                
                if  let tempMinResult = record["temp"]["min"].double{
                    recordDataModel.temperatureMin        = Int(tempMinResult - 273.15)
                    recordDataModel.temperatureMax        = Int(record["temp"]["max"].doubleValue - 273.15)
                    recordDataModel.temperature           = Int(record["temp"]["day"].doubleValue - 273.15)
                    recordDataModel.condition             = record["weather"][0]["id"].intValue
                    recordDataModel.weatherIconName       = recordDataModel.updateWeatherIcon(condition: recordDataModel.condition)
                    recordDataModel.weatherConditionLabel = record["weather"][0]["main"].stringValue
                    recordDataModel.unixtimeInterval      = record["dt"].doubleValue
                    recordDataModel.city                  = json["city"]["name"].stringValue
                    forecastArray.append(recordDataModel)
                }
            }
            forecastArray.remove(at: 0)
        }else{
            weatherUnavailableAlert()
        }
        
        tableView.reloadData()
    }
    
    func updateWeatherTodayData(json : JSON){
        if  let tempMinResult = json["main"]["temp_min"].double{
            weatherDataModel.temperatureMin        = Int(tempMinResult - 273.15)
            weatherDataModel.temperatureMax        = Int(json["main"]["temp_max"].doubleValue - 273.15)
            weatherDataModel.temperature           = Int(json["main"]["temp"].doubleValue - 273.15)
            weatherDataModel.condition             = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName       = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherConditionLabel = json["weather"][0]["main"].stringValue
            weatherDataModel.unixtimeInterval      = json["dt"].doubleValue
            weatherDataModel.city                  = json["name"].stringValue
        }else{
            weatherUnavailableAlert()
        }
        
        updateUIWithWeatherData()
        
    }
    
    func weatherUnavailableAlert(){
        let alert = UIAlertController(title: "Weather unavailable", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature)+"℃"
        weatherConditionLabel.text = weatherDataModel.weatherConditionLabel
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        let date = Date(timeIntervalSince1970: weatherDataModel.unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let strDate = dateFormatter.string(from: date)
        dateLabel.text = "Today, "+strDate
        
    }
    
    func userEnteredANewCityName(city: String) {
        let params : [String:String] = ["q" : city, "appid" : APP_ID, "cnt" : FORECAST_DAYS];
        getWeatherData(url: WEATHER_URL, parameters: params, sufix: WEATHER_URL_SUFIX_TODAY)
        getWeatherData(url: WEATHER_URL, parameters: params, sufix: WEATHER_URL_SUFIX_FORECAST)
        
    }
    
    //MARK: - Keyboard
    @objc func donePressed() {
        view.endEditing(true)
        userEnteredANewCityName(city: cityInput.text!)
    }
    
    @IBAction func buttonPressed(_ sender: UITextField) {
        cityInput.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            let detailVC = segue.destination as! DetailViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                detailVC.weatherDataModel = forecastArray[indexPath.row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

