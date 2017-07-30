//
//  TestViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 3/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var img1: UIImageView! = UIImageView()
    @IBOutlet weak var img2: UIImageView! = UIImageView()
    @IBOutlet weak var img3: UIImageView! = UIImageView()
    
    var i1: UIImage = UIImage()
    var i2: UIImage = UIImage()
    var i3: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        img1.image = i1
        img2.image = i2
        img3.image = i3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
