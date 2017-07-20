//
//  Weather.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

struct Weather {
    let summary:String
    let icon:String
    let temp:Double
    
    init(summary:String, icon: String, temp:Double)
    {
        self.summary = summary
        self.icon = icon
        self.temp = temp
    }
}

