//
//  ViewController.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mytable: UITableView!
    
    var forecastArray = Array<Weather>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mytable.delegate = self
        mytable.dataSource = self
        searchBar.delegate = self
        
        
        updateWeatherForLocation(location: "Da Nang")
        
//        var leftSwipe = UISwipeGestureRecognizer
        
    
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            //call updateWeatherForLocation
            print(locationString)
            updateWeatherForLocation(location: locationString)
            
        }
        
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func updateWeatherForLocation(location: String) {
        
        CLGeocoder().geocodeAddressString(location) { (placemarker, error) in
            if error == nil{
                if let location = placemarker?.first?.location
                {
                    Weather.forecast(withLocation: location.coordinate, parameter: "daily", completion: { (results) in
                        
                        if let weather = results {
                            self.forecastArray = weather
                            DispatchQueue.main.async {
                                self.mytable.reloadData()
                            }
                        }
                    })
                }
            }
        }
        
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
        cell.lblsummary.sizeToFit()
        cell.lbltemp.text = "\(celsius) °C"
        cell.imgIcon.image = UIImage(named: weatherObject.icon)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(15)
            textlabel.textColor = UIColor.blue
        }
    }

}






