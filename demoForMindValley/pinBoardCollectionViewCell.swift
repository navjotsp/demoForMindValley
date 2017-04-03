//
//  pinBoardCollectionViewCell.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 31/03/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit

class pinBoardCollectionViewCell: UICollectionViewCell {
    
    let pinImageView: customImageView = {
        let imageView = customImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let backView : UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10             
        
        setUpView()
    }
    
    func setUpView(){
        
        addSubview(backView)
        
        backView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 3, height: self.frame.height - 3)
        backView.layer.cornerRadius = 15
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 1.0, height: 1.5)
        backView.layer.shadowOpacity = 0.9
        backView.layer.shadowRadius = 2.0
        
        addSubview(pinImageView)
        
        pinImageView.frame = backView.bounds
        pinImageView.layer.cornerRadius = 10
        pinImageView.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
