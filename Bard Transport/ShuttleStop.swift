//
//  ShuttleStop.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/24/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class ShuttleStop: NSObject, MKAnnotation {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: State
    public var name: String
    public var icon: UIImage?
    public var flagImage: UIImage?
    public var title: String? = "Shuttle Stop"
    public var absoluteIndex: Int
    
    public var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override public var description: String {
        get {
            return name
        }
    }
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (name: String, absoluteIndex: Int) {
        
        self.absoluteIndex = absoluteIndex
        self.name = name
        
        super.init()
        
    }
    
    override public convenience init () {
        self.init(name: "Unnamed", absoluteIndex: -1)
    }
    
}