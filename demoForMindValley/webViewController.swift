//
//  webViewController.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 01/04/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit

class webViewController: UIViewController,UIWebViewDelegate {
    
    var urlString = String()
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var topBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var blurEffect = UIBlurEffect()
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = topBarView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topBarView.addSubview(blurEffectView)
        topBarView.sendSubview(toBack: blurEffectView)
        
        topBarView.layer.shadowColor = UIColor.black.cgColor
        topBarView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        topBarView.layer.shadowOpacity = 0.9
        topBarView.layer.shadowRadius = 1.0
        
        urlTextField.text = urlString
        webView.loadRequest(URLRequest(url: URL(string:urlString)!))
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("Loading...")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        urlTextField.text = webView.request?.url?.absoluteString
        print("Done")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("Error while loading!")
    }
    
    @IBAction func backToUserProfile(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
