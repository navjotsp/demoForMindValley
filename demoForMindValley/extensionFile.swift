//
//  extensionFile.swift
//  demoForMindValley
//
//  Created by Navjot Singh on 31/03/17.
//  Copyright © 2017 Navjot Singh. All rights reserved.
//

import UIKit


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


extension UIColor
{
    func isLight() -> Bool
    {
        let components = self.cgColor.components
        let r = ((components?[0])! * 299)
        let b = ((components?[1])! * 587)
        let g = ((components?[2])! * 114)
        let brightness = (r + b + g)
            / 1000
        
        if brightness < 0.5
        {
            return false
        }
        else
        {
            return true
        }
    }
}
