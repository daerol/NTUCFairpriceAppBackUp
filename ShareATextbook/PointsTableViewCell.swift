
//
//  PointsTableViewCell.swift
//  ShareATextbook
//
//  Created by Tan QingYu on 2/8/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class PointsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var titleCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
