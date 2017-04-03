//
//  pinDetailViewController.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 01/04/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit//user       username

class pinDetailViewController: UIViewController {
    
    var pinDetails = [String:AnyObject]()
    var pinImage = UIImage()
    
    @IBOutlet weak var imgViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var profileImageView: customImageView!
    
    @IBOutlet weak var pinImgView: customImageView!
    
    var userProfileLinkURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = false
        
        print(pinDetails)
        print(pinImage)
        
        let yourBackImage = #imageLiteral(resourceName: "backArrow").withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        let pinWidth = pinDetails["width"] as! CGFloat
        let pinHeight = pinDetails["height"] as! CGFloat
        
        let AspectRationOfPin:CGFloat = pinHeight/pinWidth
        
        let itemWidth = (pinImgView.frame.width)
        
        imgViewHeightConstraint.constant = itemWidth * AspectRationOfPin
        
        let pinColor = pinDetails["color"] as? String
        
        pinImgView.backgroundColor = hexStringToUIColor(hex: pinColor!)
        
        pinImgView.image = pinImage
        
        if let pinUrlData = pinDetails["urls"] as? [String:AnyObject] {
            OperationQueue.main.addOperation {
                let pinUrlStr = pinUrlData["regular"] as! String
                //   print(pinUrlStr)
                self.pinImgView.loadImageUsingUrlString(urlString: pinUrlStr)
            }
        }
        
        if let userDetails = pinDetails["user"] as? [String:AnyObject]{
            print(userDetails["username"] as Any)
            if let userName = userDetails["username"] as? String {
                userNameLbl.text = userName
            }
            
            if let name = userDetails["name"] as? String {
                let firstName = name.components(separatedBy: " ").first
                self.navigationItem.title = firstName
            }
            
            let userProfileImageData = userDetails["profile_image"] as? [String:AnyObject]
            print(userProfileImageData?["medium"] as Any)
            if let profileImageURL = userProfileImageData?["medium"] as? String {
                profileImageView.loadImageUsingUrlString(urlString: profileImageURL)
            }
            
            let userProfileLinkData = userDetails["links"] as? [String:AnyObject]
            if let userProfileLink = userProfileLinkData?["html"] as? String {
                userProfileLinkURL = userProfileLink
            }
        }else {
            print("No User Details Found")
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func visitProfileBtn(_ sender: UIButton) {
        print(userProfileLinkURL)
        let LinkToWebViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "webViewController") as! webViewController
        LinkToWebViewcontroller.urlString = userProfileLinkURL
        present(LinkToWebViewcontroller, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
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
