//
//  Itinerary.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/28/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class Itinerary: NSObject {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    
    // MARK: State
    public var departure: ScheduledStop
    public var arrival: ScheduledStop
    
    
    override public var description: String {
        get {
            return "\(departure) -> \(arrival)"
        }
    }
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (departure: ScheduledStop, arrival: ScheduledStop) {
        
        self.departure = departure
        self.arrival = arrival
        
        super.init()
        
    }
    
    override public convenience init () {
        
        self.init(departure: ScheduledStop(), arrival: ScheduledStop())
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
}
