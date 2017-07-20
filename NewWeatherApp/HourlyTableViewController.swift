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

        
        getDatafromJson()


    }
    
    func getDatafromJson() {
        
        let url = URL(string: "https://api.darksky.net/forecast/68d36f60226ba87c659b7bb4aa3458c7/16.067538,%20108.150059")
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
                            let forecastDailyData = forecastHourly["data"] as? [[String:AnyObject]]
                            for dailyPoint in forecastDailyData! {
                                
                                let summary = dailyPoint["summary"] as! String
                                let icon = dailyPoint["icon"] as! String
                                let temp = dailyPoint["temperature"] as! Double
                                
                                let weatherObject = Weather(summary: summary, icon: icon, temp: temp)
                                
                                
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
        hourFormat.dateFormat = "EEEE hh:00 a"
        return hourFormat.string(from: hour!)
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
