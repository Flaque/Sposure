//
//  Color.swift
//
//  Created by Evan Conrad on 10/5/15.
//  Copyright © 2015 Evan Conrad. All rights reserved.
//

import UIKit

class Color {
    
    static func fontColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0x333333, alpha: alpha)
    }
    
    static func lightFontColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0x777777, alpha: alpha)
    }
    
    static func UIColorFromRGB(rgbValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static func redColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0xc0392b, alpha: alpha)
    }
    
    static func orangeColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0xe67e22, alpha: alpha)
    }
    
    static func blueColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0x3498db, alpha: alpha)
    }
    
    static func turquoiseColor(alpha: CGFloat = 1.0) -> UIColor {
        return self.UIColorFromRGB(0x1abc9c, alpha: alpha)
    }
}