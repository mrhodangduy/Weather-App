//
//  DailyTableViewCell.swift
//  NewWeatherApp
//
//  Created by QTS Coder on 7/20/17.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblsummary: UILabel!
    @IBOutlet weak var lbltemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
