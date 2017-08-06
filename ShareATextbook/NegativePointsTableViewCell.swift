//
//  NegativePointsTableViewCell.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 5/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class NegativePointsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var negTypeMessage: UILabel!
    @IBOutlet weak var negPointsDate: UILabel!
    @IBOutlet weak var negTotalPoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
