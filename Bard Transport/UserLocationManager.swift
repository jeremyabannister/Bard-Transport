//
//  UserLocationManager.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 9/1/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore
import CoreLocation


public enum UserLocationManagerError {
    case InsufficientAccessPrivileges
    case NoLocationData
}

private enum UserLocationDebugMode {
    case Off
    case Tivoli
    case Hannaford
}


public class UserLocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Subscribers
    private var subscribers = [UserLocationManagerSubscriber]()
    
    
    // MARK: State
    private let locationManager = CLLocationManager()
    
    private var fakeSetting = false
    public var currentUserLocation: CLLocation? {
        didSet {
            notifySubscribersOfLocationChange()
        }
    }
    
    public var error: UserLocationManagerError? {
        didSet {
            notifySubscribersOfLocationChange()
        }
    }
    
    
    // Debug
    private var debugMode = UserLocationDebugMode.Off
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    override public init () {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Location
    public func tryForLocationData () {
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK:
    // MARK: Subscribers
    // MARK:
    
    /// Adds subscriber
    ///
    /// - author: Jeremy Bannister
    public func addSubscriber (subscriber: UserLocationManagerSubscriber) {
        
        var found = false
        for oldSubscriber in subscribers {
            if subscriber === oldSubscriber {
                found = true
            }
        }
        
        if !found {
            if subscribers.count > 0 {
                subscribers.insert(subscriber, atIndex: 0)
            } else {
                subscribers.append(subscriber)
            }
        }
    }
    
    public func removeSubscriber (subscriber: UserLocationManagerSubscriber) {
        for i in 0 ..< subscribers.count {
            if subscribers[i] === subscriber {
                subscribers.removeAtIndex(i)
            }
        }
    }
    
    public func notifySubscribersOfLocationChange () {
        for subscriber in subscribers {
            subscriber.userLocationDidChange()
        }
    }
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Location Manager
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            if debugMode == .Off {
                currentUserLocation = locations[0]
            } else if debugMode == .Tivoli {
                currentUserLocation = CLLocation(latitude: 42.0599000, longitude: -73.9100421) // Tivoli
            } else if debugMode == .Hannaford {
                currentUserLocation = CLLocation(latitude: 41.9799000, longitude: -73.8808082) // Hannaford
            }
            
            error = nil
        }
        
    }
    
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            self.error = UserLocationManagerError.InsufficientAccessPrivileges
            currentUserLocation = nil
        } else {
            self.error = UserLocationManagerError.NoLocationData
            currentUserLocation = nil
        }
        
    }
}


public protocol UserLocationManagerSubscriber: class {
    func userLocationDidChange ()
}
