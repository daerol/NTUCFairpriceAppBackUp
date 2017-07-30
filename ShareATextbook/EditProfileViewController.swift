//
//  EditProfileViewController.swift
//  ntucTest
//
//  Created by Chia Li Yun on 12/5/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var user: User?
    
    @IBAction func doneButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to edit your profile?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
            action in
                
            print("okay")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if user != nil {
            name.text = user?.username
            location.text = user?.preferredloc
            email.text = user?.email != "" ? user?.email : ""
        }
        
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
