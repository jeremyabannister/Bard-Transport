//
//  ScheduledRun.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/27/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public enum ScheduledRunDirection {
    case Northbound
    case Southbound
}

public class ScheduledRun: NSObject {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    
    // MARK: Printable
    override public var description: String {
        get {
            var output = "{ "
            for i in 0 ..< scheduledStops.count {
                let stop = scheduledStops[i]
                output += stop.description
                if i != scheduledStops.count - 1 {
                    output += ",\n"
                }
            }
            output += " }"
            return output
        }
    }
    
    // MARK: State
    public var direction = ScheduledRunDirection.Southbound
    public var scheduledStops = [ScheduledStop]()
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
}
