//
//  ImageCell.swift
//  PandaWeather
//
//  Created by Robin Allemand on 11/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
class ImageCell: UITableViewCell {
    @IBOutlet weak var ImageNameLabel: UILabel!
    @IBOutlet weak var WeatherTypeLabel: UILabel!
    @IBOutlet weak var PandaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
