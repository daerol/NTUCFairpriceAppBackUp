//
//  PointsRecordsTableViewCell.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 3/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PointsRecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var typeMessage: UILabel!
    @IBOutlet weak var pointsDate: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
