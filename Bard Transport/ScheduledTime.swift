//
//  ScheduledTime.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/26/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduledTime: NSObject, Comparable {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    
    // MARK: Printable
    override public var description: String {
        get {
            var output = ""
            var pm = false
            
            if hour > 12 {
                output += "\(hour - 12):"
                pm = true
            } else if hour == 12 {
                output += "\(hour):"
                pm = true
            } else if hour == 0 {
                output += "12:"
            } else {
                output += "\(hour):"
            }
            
            output += String(format: "%02d", minute)
            
            if pm {
                output += " pm"
            } else {
                output += " am"
            }
            
            return output
        }
    }
    
    
    // MARK: Equatable
    override public func isEqual(object: AnyObject?) -> Bool {
        if let rhs = object as? ScheduledTime {
            return time == rhs.time
        }
        return false
    }
    
    
    
    // MARK: State
    public var time: Int {
        didSet {
            if time >= 1440 {
                time = time % 1440
            }
        }
    }
    
    public var hour: Int {
        get {
            return (time - (time % 60))/60
        }
    }
    
    public var minute: Int {
        get {
            return time - (hour * 60)
        }
    }
    
    
    
    
    
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (time: Int) {
        
        self.time = time
        super.init()
        
    }
    
    
    public convenience init (timeString: String) {
        
        var time = 0
        
        let components = timeString.componentsSeparatedByString(" ")
        if components.count == 2 {
            var am: Bool?
            if components[1].lowercaseString == "am" {
                am = true
            } else if components[1].lowercaseString == "pm" {
                am = false
            }
            
            if am != nil {
                let timeComponents = components[0].componentsSeparatedByString(":")
                if timeComponents.count == 2 {
                    
                    if var hour = Int(timeComponents[0]) {
                        if let minute = Int(timeComponents[1]) {
                            if am! {
                                if hour == 12 {
                                    hour = 0
                                }
                            } else {
                                if hour != 12 {
                                    hour += 12
                                }
                            }
                            time = (hour * 60 + minute)
                        }
                    }
                }
            }
        }
        
        self.init(time: time)
    }
    
    
    public convenience init (date: NSDate) {
        
        let time = (date.hour * 60) + date.minute
        
        self.init(time: time)
    }
    
    
    override public convenience init () {
        
        self.init(time: 0)
        
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
}


public func + (lhs: ScheduledTime, rhs: Int) -> ScheduledTime {
    
    return ScheduledTime(time: lhs.time + rhs)
}

public func + (lhs: ScheduledTime, rhs: ScheduledTime) -> ScheduledTime {
    return ScheduledTime(time: lhs.time + rhs.time)
}

public func < (lhs: ScheduledTime, rhs: ScheduledTime) -> Bool {
    return lhs.time < rhs.time
}

public func > (lhs: ScheduledTime, rhs: ScheduledTime) -> Bool {
    return lhs.time > rhs.time
}


