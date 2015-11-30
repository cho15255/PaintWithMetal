//
//  JHUtil.swift
//  PaintWithMetal
//
//  Created by Jae Hee Cho on 2015-11-29.
//  Copyright © 2015 Jae Hee Cho. All rights reserved.
//

import Foundation
import UIKit

func distanceBetween(pointA a:CGPoint, pointB b:CGPoint) -> CGFloat {
    let difference = CGPointMake(b.x - a.x, b.y - a.y)
    return mag(difference)
}

func mag(v:CGPoint) -> CGFloat {
    return sqrt(v.x * v.x + v.y * v.y)
}

func normalize(v:CGPoint) -> CGPoint {
    let l = mag(v)
    return CGPointMake(v.x / l, v.y / l)
}

func getMetalCoordinate(forPoint point:CGPoint, forFrame frame:CGRect) -> (Float, Float) {
    let xCoord = Float( 2 * (point.x / frame.width) - 1 )
    let yCoord = Float( 2 * (frame.height - point.y) / frame.height - 1 )
    
    return (xCoord, yCoord)
}

func getColorFromHex(var hexValue:UInt) -> UIColor {
    if hexValue > 0xffffff {
        hexValue = 0xffffff
    }
    
    return UIColor(red: CGFloat(Double((hexValue & 0xFF0000) >> 16)/255.0), green: CGFloat(Double((hexValue & 0x00FF00) >> 8)/255.0), blue: CGFloat(Double((hexValue & 0x0000FF) >> 0)/255.0), alpha: 1)
}
