//
//  ItemCollectionViewCell.swift
//  ntucTest
//
//  Created by Chia Li Yun on 11/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

@IBDesignable
class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDetail: UILabel!
    @IBOutlet weak var itemTag: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBAction func bookmarkAction(_ sender: Any) {
    }
    
    @IBAction func chatAction(_ sender: Any) {
    }
    
    
    
}
