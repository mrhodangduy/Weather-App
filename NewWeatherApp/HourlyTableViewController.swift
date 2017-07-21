//
//  HourlyTableViewController.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class HourlyTableViewController: UITableViewController {
    
    var hourlyArray = Array<Weather>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatafromJson(link: "https://api.darksky.net/forecast/68d36f60226ba87c659b7bb4aa3458c7/16.067538,%20108.150059")
        
        
        
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
                        if let forecastHourly = myJson["hourly"] as? [String: AnyObject]
                        {
                            let forecastHourlyData = forecastHourly["data"] as? [[String:AnyObject]]
                            for hourlyPoint in forecastHourlyData! {
                                
                                let weatherObject = try Weather(hourly: hourlyPoint)
                                
                                self.hourlyArray.append(weatherObject)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return hourlyArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hour = Calendar.current.date(byAdding: .hour, value: section, to: Date())
        let hourFormat = DateFormatter()
        hourFormat.dateFormat = "EEEE hh:mm"
        return hourFormat.string(from: hour!)
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(15)
            textlabel.textColor = UIColor.blue
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let hourlyObject = hourlyArray[indexPath.section]
        let fahrenheit = hourlyObject.temp
        let celsius = Int((fahrenheit - 32) * (5 / 9))
        
        cell.lblsummary.text = hourlyObject.summary
        cell.lbltemp.text = "\(celsius) °C"
        cell.imgIcon.image = UIImage(named: hourlyObject.icon)
        //        cell.backgroundColor = UIColor(patternImage: UIImage(named: hourlyObject.icon)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    
}
