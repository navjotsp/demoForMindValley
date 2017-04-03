//
//  pinBoardViewController.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 31/03/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class pinBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ServerControllerDelegate{
    
    
    @IBOutlet weak var leftCV: UICollectionView!
    @IBOutlet weak var rightCV: UICollectionView!
    
    let server = ServerController()
    
    var leftPinBoardData = [[String:AnyObject]]()
    var rightPinBoardData = [[String:AnyObject]]()
    
    var refreshCtrl: UIRefreshControl!
    
    @IBOutlet weak var SV: UIScrollView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        
        leftCV.register(pinBoardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        rightCV.register(pinBoardCollectionViewCell.self , forCellWithReuseIdentifier: reuseIdentifier)
        
        self.refreshCtrl = UIRefreshControl()
        self.refreshCtrl.addTarget(self, action: #selector(fetchDataFromServer), for: .valueChanged)
        
        self.SV.addSubview(self.refreshCtrl)
        
        server.delegate = self
        fetchDataFromServer()
        
    }
    
    func fetchDataFromServer(){
        //let param = "tag=emailvalidation&email=navjotsp@hotmail.com"
        server.CallService(urlString: "http:pastebin.com/raw/wgkJgazE", parameters: nil)
    }
    
    func requestFinished(dictionary : [[String:AnyObject]]){
        print(dictionary)
        
        leftPinBoardData = []
        rightPinBoardData = []
        
        for index in 0 ..< dictionary.count {
            if index%2 == 0 {
                leftPinBoardData.append(dictionary[index])
            } else {
                rightPinBoardData.append(dictionary[index])
            }
        }
        
        self.refreshCtrl.endRefreshing()
        
        self.leftCV.reloadData()
        self.rightCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == leftCV {
            return leftPinBoardData.count
        } else {
            return rightPinBoardData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! pinBoardCollectionViewCell
        
        var pinData = [String:AnyObject]()
        
        if collectionView == leftCV {
            pinData = leftPinBoardData[indexPath.row] as [String:AnyObject]
        } else {
            pinData = rightPinBoardData[indexPath.row] as [String:AnyObject]
        }
        
        let pinColor = pinData["color"] as? String
        
        cell.pinImageView.backgroundColor = hexStringToUIColor(hex: pinColor!)
        cell.backView.backgroundColor = hexStringToUIColor(hex: pinColor!)
        
        if let pinUrlData = pinData["urls"] as? [String:AnyObject] {
            OperationQueue.main.addOperation {
                let pinUrlStr = pinUrlData["thumb"] as! String
                //   print(pinUrlStr)
                cell.pinImageView.loadImageUsingUrlString(urlString: pinUrlStr)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var pinData = [String:AnyObject]()
        
        if collectionView == leftCV {
            pinData = leftPinBoardData[indexPath.row] as [String:AnyObject]
        } else {
            pinData = rightPinBoardData[indexPath.row] as [String:AnyObject]
        }
        
        let pinWidth = pinData["width"] as! CGFloat
        let pinHeight = pinData["height"] as! CGFloat
        
        let AspectRationOfPin:CGFloat = pinHeight/pinWidth
        
        let itemWidth = (leftCV.frame.width)
        let itemHeight = itemWidth * AspectRationOfPin
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        collectionViewHeightConstraint.constant += cell.bounds.height
        
        if indexPath.row == (leftPinBoardData.count - 1) && (leftCV.contentSize.height > rightCV.contentSize.height){
            collectionViewHeightConstraint.constant = leftCV.contentSize.height + 10
        }else if indexPath.row == (leftPinBoardData.count - 1) && (leftCV.contentSize.height < rightCV.contentSize.height){
            collectionViewHeightConstraint.constant = rightCV.contentSize.height + 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pinData = [String:AnyObject]()
        if collectionView == leftCV {
            pinData = leftPinBoardData[indexPath.row] as [String:AnyObject]
        } else {
            pinData = rightPinBoardData[indexPath.row] as [String:AnyObject]
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! pinBoardCollectionViewCell
        
        
        let detailViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "pinDetailViewController") as! pinDetailViewController
        detailViewcontroller.pinDetails = pinData
        if cell.pinImageView.image != nil {
            detailViewcontroller.pinImage = cell.pinImageView.image!
        }
        show(detailViewcontroller, sender: self)
    }
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        if self.CV == scrollView{
    //            let slaveView = self.rightCV
    //            slaveView?.setContentOffset(scrollView.contentOffset, animated: false)
    //        }else{
    //            let slaveView = self.CV
    //            slaveView?.setContentOffset(scrollView.contentOffset, animated: false)
    //        }
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
