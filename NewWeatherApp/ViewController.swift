//
//  ViewController.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mytable: UITableView!

    var forecastArray = Array<Weather>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mytable.delegate = self
        mytable.dataSource = self
        
        getDatafromJson(link: "https://api.darksky.net/forecast/68d36f60226ba87c659b7bb4aa3458c7/16.067538,%20108.150059")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func getDatafromJson(link: String) {

        let url = URL(string: link)
        let task = URLSession.shared.dataTask(with: url!) { (data, respone, error) in
            if error != nil {
                print(error!)
            }
            else{
                if let content = data
                {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! [String:AnyObject]
                        if let forecastDaily = myJson["daily"] as? [String: AnyObject]
                        {
                            let forecastDailyData = forecastDaily["data"] as? [[String:AnyObject]]
                            for dailyPoint in forecastDailyData! {
                                
                                let summary = dailyPoint["summary"] as! String
                                let icon = dailyPoint["icon"] as! String
                                let temp = dailyPoint["temperatureMax"] as! Double
                                
                                let weatherObject = Weather(summary: summary, icon: icon, temp: temp)
                                
                                
                                self.forecastArray.append(weatherObject)
                                DispatchQueue.main.async {
                                    self.mytable.reloadData()
                                }
                            }
                        }
                    } catch
                    {
                        
                    }
                }
            }
        }
        task.resume()
        
    }
  
  
}


extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE MMMM dd"
        return dateFormat.string(from: date!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyTableViewCell
        
        let weatherObject = forecastArray[indexPath.section]
        let fahrenheit = weatherObject.temp
        let celsius = Int((fahrenheit - 32) * (5 / 9))
        
        cell.lblsummary.text = weatherObject.summary
        cell.lbltemp.text = "\(celsius) °C"
        cell.imgIcon.image = UIImage(named: weatherObject.icon)
               
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}






