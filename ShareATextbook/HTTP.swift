//
//  Http.swift
//  NewsApp
//
//  Created by KIM FOONG CHOW on 9/4/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

///
/// A simple wrapper class for common HTTP functions
///
class HTTP {
    
    
    /**
     Issues a HTTP request to the server
     */
    private class func request(
        url: String,
        httpMethod : String,
        httpHeaders : [String: String],
        httpBody : Data?,
        onComplete:
        ((_: Data?, _: URLResponse?, _: Error?) -> Void)?)
    {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        for (key, value) in httpHeaders
        {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        URLSession.shared.dataTask(with: request)
        {
            data, response, error in
            
            onComplete?(data, response, error)
            }.resume()
    }
    
    
    /**
     Issues a HTTP request to the server
     */
    private class func requestJSON(
        url: String,
        httpMethod : String,
        json: JSON?,
        onComplete:
        ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?)
    {
        do
        {
            var httpBody : Data?
            if (json != nil)
            {
                httpBody = try json!.rawData()
            }
            request(url: url,
                    httpMethod: httpMethod,
                    httpHeaders: [
                        "Accept" : "application/json",
                        "Content-Type" : "application/json"
                ],
                    httpBody: httpBody,
                    onComplete:
                {
                    data, response, error in
                    
                    var result : JSON?
                    if (data != nil)
                    {
                        result = JSON.init(data: data!)
                    }
                    onComplete?(result, response, error)
                    
            })
        }
        catch
        {
        }
        
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    private class func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    private class func createRequest(url: String, token: String, imageData: Data) -> URLRequest {
        let parameters = ["token": token]  // build your dictionary however appropriate
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBody(parameters: parameters,
                                      boundary: boundary,
                                      data: imageData,
                                      mimeType: "image/jpg",
                                      filename: "hello.jpg")
        
        return request
    }

    
    /**
     Issues a HTTP GET request to the server
     */
    class func getJSON(url: String, onComplete:
        ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?)
    {
        requestJSON(url: url,
                    httpMethod: "GET",
                    json: nil,
                    onComplete: onComplete)
    }
    
    /**
     Issues a HTTP POST request to the server
     */
    class func postJSON(url: String, json: JSON, onComplete:
        ((_: JSON?, _: URLResponse?, _: Error?) -> Void)?)
    {
        requestJSON(url: url,
                    httpMethod: "POST",
                    json: json,
                    onComplete: onComplete)
    }
    
    class func postMultipartPhotos(url: String, token: String, tag: Int, image: UIImage, onComplete:
        ((_: JSON?, _: URLResponse?, _: Error?, _:Int?) -> Void)?) {
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        
        if imageData != nil {
            let request = createRequest(url: url, token: token, imageData: imageData!)
            
            URLSession.shared.dataTask(with: request)
            {
                data, response, error in
                
                if data != nil {
                    
                    let json = JSON.init(data: data!)
                    
                    onComplete?(json, response, error, tag)
                }
            }.resume()
        }
        
    }
    
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
