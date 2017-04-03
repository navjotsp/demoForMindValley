//
//  ServerController.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 31/03/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit

protocol ServerControllerDelegate: class {
    func requestFinished(dictionary : [[String:AnyObject]])
}

class ServerController: NSObject {
    
    weak var delegate : ServerControllerDelegate?
    
    func CallService(urlString: String, parameters: String?){
        
        print(urlString)
        print(parameters as Any)
        
        print("Requesting....")
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        if let param = parameters{
            request.httpBody = param.data(using: String.Encoding.utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request)
        {(data, response, error) in
            
            guard let data = data, error == nil else{
                print((error?.localizedDescription)!)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString!)
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.requestFinished(dictionary: json as! [[String:AnyObject]])
                })
                print("request completed!!!")
                
            }catch let jsonError{
                print(jsonError)
            }
        }
        task.resume()
        
    }
}
