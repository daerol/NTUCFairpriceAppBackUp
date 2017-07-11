//
//  HTTP.swift
//  ShareATextbook
//
//  Created by Chia Li Yun on 14/6/17.
//  Copyright © 2017 Chia Li Yun. All rights reserved.
//

import UIKit

class HTTP: NSObject {

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
    
    
    
    
    
}

