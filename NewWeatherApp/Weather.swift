//
//  Weather.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temp:Double
    
    enum SerizationError:Error {
        case missing(String)
        case invalid(String)
        
    }
    
    init(summary:String, icon: String, temp:Double)
    {
        self.summary = summary
        self.icon = icon
        self.temp = temp
    }
    
    init(daily: [String:Any]) throws {
        guard let summary = daily["summary"] as? String else { throw SerizationError.missing("missing summary")}
        guard let icon = daily["icon"] as? String else { throw SerizationError.missing("missing summary")}
        guard let temp = daily["temperatureMax"] as? Double else { throw SerizationError.missing("missing summary")}
        
        self.summary = summary
        self.icon = icon
        self.temp = temp

    }
    
    init(hourly:[String:Any]) throws {
        guard let summary = hourly["summary"] as? String else {throw SerizationError.missing("summary is missing")}
        
        guard let icon = hourly["icon"] as? String else {throw SerizationError.missing("icon is missing")}
        
        guard let temperature = hourly["temperature"] as? Double else {throw SerizationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temp = temperature
        
    }
    
    static let basePath = "https://api.darksky.net/forecast/68d36f60226ba87c659b7bb4aa3458c7/"
    
    static func forecast(withLocation location:CLLocationCoordinate2D, parameter para:String, completion: @escaping ([Weather]?) -> ())
    {
        let link = basePath + "\(location.latitude),\(location.longitude)"
        let url = URL(string: link)
        let task = URLSession.shared.dataTask(with: url!) { (data, respone, error) in
            
            var arrayDaily = [Weather]()
            
            if error != nil
            {
                print(error!)
            } else
            {
                if let content = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? [String: AnyObject]
                        {
                            if let daily = json[para] as? [String: AnyObject]
                            {
                                if let dailyData = daily["data"] as? Array<[String:AnyObject]>
                                {
                                    for dailyPoint in dailyData
                                    {
                                        let weatherObject = try? Weather(daily: dailyPoint)
                                        arrayDaily.append(weatherObject!)
                                    }
                                }
                            }
                        }
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    
                    completion(arrayDaily)
                }
            }
        }
        task.resume()
        
    }
    
}



