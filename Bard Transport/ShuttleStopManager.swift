//
//  ShuttleStopManager.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/24/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class ShuttleStopManager: NSObject {
    
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: State
    public var mainShuttleStops = [ShuttleStop]()
    public var allShuttleStops = [ShuttleStop]()
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    override public init () {
        
        super.init()
        createStops()
        
    }
    
    
    // MARK: Stops
    private func createStops () {
        
        
        // Southbound: Tivoli, Monument, Campus Rd, Robbins, Ward Gate, Kline, Gahagan, Triangle, Red Hook, MAT/UBS, Hannaford
        // Northbound: Hannaford, MAT/UBS, Red Hook, Church St., Triangle, Gahagan, Kline, Robbins, Campus Rd, Monument, Tivoli
        
        let tivoli = ShuttleStop(name: "Tivoli", absoluteIndex: 0)
        tivoli.icon = UIImage(named: tivoli.name + ".png")
        tivoli.flagImage = UIImage(named: tivoli.name + " Fancy Flag.png")
        tivoli.coordinate = CLLocationCoordinate2D(latitude: 42.059947, longitude: -73.911267)
        tivoli.title = tivoli.name + " Shuttle Stop"
        
        
        let monument = ShuttleStop(name: "Monument", absoluteIndex: 1)
        monument.icon = UIImage(named: monument.name + ".png")
        monument.flagImage = UIImage(named: monument.name + " Fancy Flag.png")
        monument.coordinate = CLLocationCoordinate2D(latitude: 42.057061, longitude: -73.900377)
        monument.title = monument.name + " Shuttle Stop"
        
        
        let campusRd = ShuttleStop(name: "Campus Rd", absoluteIndex: 2)
        campusRd.icon = UIImage(named: campusRd.name + ".png")
        campusRd.flagImage = UIImage(named: campusRd.name + " Fancy Flag.png")
        campusRd.coordinate = CLLocationCoordinate2D(latitude: 42.026458, longitude: -73.903514)
        campusRd.title = campusRd.name + " Shuttle Stop"
        
        
        let robbins = ShuttleStop(name: "Robbins", absoluteIndex: 3)
        robbins.icon = UIImage(named: robbins.name + ".png")
        robbins.flagImage = UIImage(named: robbins.name + " Fancy Flag.png")
        robbins.coordinate = CLLocationCoordinate2D(latitude: 42.029298, longitude: -73.904583)
        robbins.title = robbins.name + " Shuttle Stop"
        
        
        let wardGate = ShuttleStop(name: "Ward Gate", absoluteIndex: 4)
        wardGate.icon = UIImage(named: wardGate.name + ".png")
        wardGate.flagImage = UIImage(named: wardGate.name + " Fancy Flag.png")
        wardGate.coordinate = CLLocationCoordinate2D(latitude: 42.026928, longitude: -73.905945)
        wardGate.title = wardGate.name + " Shuttle Stop"
        
        
        let kline = ShuttleStop(name: "Kline", absoluteIndex: 5)
        kline.icon = UIImage(named: kline.name + ".png")
        kline.flagImage = UIImage(named: kline.name + " Fancy Flag.png")
        kline.coordinate = CLLocationCoordinate2D(latitude: 42.022420, longitude: -73.908418)
        kline.title = kline.name + " Shuttle Stop"
        
        
        let gahagan = ShuttleStop(name: "Gahagan", absoluteIndex: 6)
        gahagan.icon = UIImage(named: gahagan.name + ".png")
        gahagan.flagImage = UIImage(named: gahagan.name + " Fancy Flag.png")
        gahagan.coordinate = CLLocationCoordinate2D(latitude: 42.017789, longitude: -73.908951)
        gahagan.title = gahagan.name + " Shuttle Stop"
        
        
        let triangle = ShuttleStop(name: "Triangle", absoluteIndex: 7)
        triangle.icon = UIImage(named: triangle.name + ".png")
        triangle.flagImage = UIImage(named: triangle.name + " Fancy Flag.png")
        triangle.coordinate = CLLocationCoordinate2D(latitude: 42.013772, longitude: -73.908264)
        triangle.title = triangle.name + " Shuttle Stop"
        
        
        let churchSt = ShuttleStop(name: "Church St", absoluteIndex: 8)
        churchSt.icon = UIImage(named: churchSt.name + ".png")
        churchSt.flagImage = UIImage(named: churchSt.name + " Fancy Flag.png")
        churchSt.coordinate = CLLocationCoordinate2D(latitude: 41.995801, longitude: -73.877857)
        churchSt.title = churchSt.name + " Shuttle Stop"
        
        
        let redHook = ShuttleStop(name: "Red Hook", absoluteIndex: 9)
        redHook.icon = UIImage(named: redHook.name + ".png")
        redHook.flagImage = UIImage(named: redHook.name + " Fancy Flag.png")
        redHook.coordinate = CLLocationCoordinate2D(latitude: 41.994496, longitude: -73.876364)
        redHook.title = redHook.name + " Shuttle Stop"
        
        
        let matUbs = ShuttleStop(name: "MAT-UBS", absoluteIndex: 10)
        matUbs.icon = UIImage(named: matUbs.name + ".png")
        matUbs.flagImage = UIImage(named: matUbs.name + " Fancy Flag.png")
        matUbs.coordinate = CLLocationCoordinate2D(latitude: 41.991304, longitude: -73.879416)
        matUbs.title = matUbs.name + " Shuttle Stop"
        
        
        let hannaford = ShuttleStop(name: "Hannaford", absoluteIndex: 11)
        hannaford.icon = UIImage(named: hannaford.name + ".png")
        hannaford.flagImage = UIImage(named: hannaford.name + " Fancy Flag.png")
        hannaford.coordinate = CLLocationCoordinate2D(latitude: 41.979838, longitude: -73.880832)
        hannaford.title = hannaford.name + " Shuttle Stop"
        
        
        
        mainShuttleStops = [tivoli, robbins, kline, redHook, hannaford]
        allShuttleStops = [tivoli, monument, campusRd, robbins, wardGate, kline, gahagan, triangle, churchSt, redHook, matUbs, hannaford]
        
    }
    
    
    
    public func stopsValidForDirection (direction: ScheduledRunDirection) -> [ShuttleStop] {
        
        var stops = [ShuttleStop]()
        
        for stop in allShuttleStops {
            if (direction == .Northbound && stop.name != "Ward Gate") || (direction == .Southbound && stop.name != "Church St") {
                stops.append(stop)
            }
        }
        
        return stops
        
    }
}