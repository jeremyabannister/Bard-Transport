//
//  Global.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 5/19/16.
//  Copyright © 2016 Jeremy Bannister. All rights reserved.
//

import Foundation
import UIKit

public var userLocationManager = UserLocationManager()
public var shuttleStopManager = ShuttleStopManager()
public var schedule = Schedule()


public var widthOfNotifications = CGFloat(0.6)
public var heightOfNotifications = CGFloat(0.555)

public let lateNightThreshold = 300


public func distanceBetweenPoints (point1: CGPoint, point2: CGPoint) -> CGFloat {
    
    let difference = CGPoint(x: point1.x - point2.x, y: point1.y - point2.y)
    return sqrt(pow(difference.x, 2) + pow(difference.y, 2))
    
}


public var rightNow: NSDate {
get {
    return NSDate()
}
}


public func resizeImage(image: UIImage?, newWidth: CGFloat) -> UIImage? {
    
    if let nonNilImage = image {
        let scale = newWidth / nonNilImage.size.width
        let newHeight = nonNilImage.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        nonNilImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    return image
}