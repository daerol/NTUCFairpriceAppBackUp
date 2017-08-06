//
//  Constants.swift
//  ntucTest
//
//  Created by Chia Li Yun on 3/5/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    //  Project Colors
    static let red = UIColor(red: 232/255, green: 26/255, blue: 4/255, alpha: 1.0)
    static let blue = UIColor(red: 0/255, green: 67/255, blue: 134/255, alpha: 1.0)
    static let darkRed = UIColor(red: 210/255, green: 0/255, blue: 0/255, alpha: 1.0)
    static let white = UIColor.white
    static let lightGrey = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1.0)
    static let lightestGray = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
    static let darkGrey = UIColor(red: 91/255, green: 91/255, blue: 91/255, alpha: 1.0)
    static let shadowGrey = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0)
}

struct DatabaseAPI {
    static let url: String = "http://13.228.39.122/FP05_883458374658792/1.0/"
    
    static let imageDownloadURL: String = "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=postings/"
    static let imageSizeR1000: String = "_r1000"
    static let imageSizeR600: String = "_r600"
    
    static let userImageDownloadURL: String = "http://13.228.39.122/fpsatimgdev/loadimage.aspx?q=users/"
    static let userImageSizeC150 = "_c150"
    static let userImageSizeC300 = "_c300"
    
    /// Check if the response is an error
    ///
    /// - Parameter json: json response from Database API
    /// - Returns: true if there is an error, false if there is no error
    static func gotError(json: JSON) -> Bool {
        if let error = json["error"] as? String{
            return false
        } else {
            return true
        }
    }
    
    static func responseIsError(json: JSON) -> Bool {
        if json.count == 1 {
            if let error = json["error"] as? String{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

struct Strings {
    static let choosePrompt = "Choose one"
    static let profileMissingFieldErrorMsg = "You cannot leave blank\n"
    static let invalidFieldMsg = "Please ensure the correct format\n"
}

struct SharedVariables {
    static var id: String = ""
    static var token: String = ""
    static var user: User = User(username: "", password: "", token: "", preferredloc: "", id: "", email: "", phoneNumber: "", photo: "")
    
}

struct OpenPhoneApplication {
    static func openMap (url: String) -> Bool {
        if (UIApplication.shared.canOpenURL(URL(string: url)!)) {
            return true
        } else {
            return false
        }
    }
}

struct Formatter {
    static func formatDoubleToString(num: Double, noOfDecimal: Int) -> String {
        let fmt = NumberFormatter()
        fmt.minimumFractionDigits = noOfDecimal
        let formattedStr = fmt.string(from: NSNumber(value: num))!
        
        return formattedStr
    }
}

struct Calculation {
    
}
