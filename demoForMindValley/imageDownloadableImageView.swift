//
//  ViewController.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 31/03/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class customImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString : String){
        
        let activityView = UIActivityIndicatorView()
        if self.backgroundColor != nil {
            if (self.backgroundColor?.isLight())! {
                activityView.activityIndicatorViewStyle = .gray
            } else {
                activityView.activityIndicatorViewStyle = .white
            }
        }else{
            activityView.activityIndicatorViewStyle = .gray
        }
        
        activityView.center = self.center
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        self.addSubview(activityView)
        
        print("Requesting Image..")
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        //        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject)  {
            print("Fetched From Cache")
            self.image = imageFromCache as? UIImage
            activityView.stopAnimating()
            return
        }
        
        URLSession.shared.downloadTask(with: url!, completionHandler: { (location, response, error) -> Void in
            if let data = try? Data(contentsOf: url!){
                
                print("fetched from server")
                
                OperationQueue.main.addOperation {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    if self.imageUrlString == urlString{
                        self.image = imageToCache
                    }
                    activityView.stopAnimating()
                    
                }
            }
        }).resume()
    }
}
