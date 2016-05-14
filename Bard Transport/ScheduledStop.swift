//
//  ScheduledStop.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/26/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduledStop: NSObject {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Printable
    override public var description: String {
        get {
            var output = ""
            
            output += shuttleStop.name
            output += ": "
            output += arrivalTime.description
            output += " -> "
            if let interval = intervalToDeparture {
                output += (arrivalTime + interval).description
            } else {
                output += "(End of line)"
            }
            
            
            return output
        }
    }
    
    // MARK: State
    public var shuttleStop: ShuttleStop
    public var arrivalTime: ScheduledTime
    public var intervalToDeparture: Int?
    public var departureTime: ScheduledTime? {
        get {
            if let interval = intervalToDeparture {
                return arrivalTime + interval
            } else {
                return nil
            }
            
        }
    }
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (shuttleStop: ShuttleStop, arrivalString: String, intervalToDeparture: Int) {
        
        self.shuttleStop = shuttleStop
        self.arrivalTime = ScheduledTime(timeString: arrivalString)
        self.intervalToDeparture = intervalToDeparture
        
        super.init()
    }
    
    public init (shuttleStop: ShuttleStop, arrival: Int, intervalToDeparture: Int) {
        
        self.shuttleStop = shuttleStop
        self.arrivalTime = ScheduledTime(time: arrival)
        self.intervalToDeparture = intervalToDeparture
        
        super.init()
    }
    
    
    override public convenience init () {
        self.init(shuttleStop:ShuttleStop(), arrivalString: "12:00 am", intervalToDeparture: 0)
    }
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
}
