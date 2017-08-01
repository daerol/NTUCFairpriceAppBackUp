//
//  ImageDownload.swift
//  ntucTest
//
//  Created by Chia Li Yun on 18/7/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class ImageDownload: NSObject {
    
    private class func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    class func downloadImage(url: URL, onComplete: ((_:Data)-> Void)?) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            onComplete!(data)
        }
    }

}
