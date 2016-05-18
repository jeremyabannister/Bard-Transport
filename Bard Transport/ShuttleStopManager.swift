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
        
        
        // Southbound: Tivoli, Monument, Campus Road, Robbins, Ward Gate, Kline, Gahagan, Triangle, Red Hook, MAT/UBS, Hannaford
        // Northbound: Hannaford, MAT/UBS, Red Hook, Church St., Triangle, Gahagan, Kline, Robbins, Campus Road, Monument, Tivoli
        
        let tivoli = ShuttleStop(name: "Tivoli", absoluteIndex: 0)
        tivoli.icon = UIImage(named: tivoli.name + ".png")
        tivoli.flagImage = UIImage(named: tivoli.name + " Fancy Flag.png")
        tivoli.coordinate = CLLocationCoordinate2D(latitude: 42.0599000, longitude: -73.9100421)
        tivoli.title = tivoli.name + " Shuttle Stop"
        
        
        let monument = ShuttleStop(name: "Monument", absoluteIndex: 1)
        monument.icon = UIImage(named: monument.name + ".png")
        monument.flagImage = UIImage(named: monument.name + " Fancy Flag.png")
        monument.coordinate = CLLocationCoordinate2D(latitude: 42.0599000, longitude: -73.9100421)
        monument.title = monument.name + " Shuttle Stop"
        
        
        let campusRoad = ShuttleStop(name: "Campus Road", absoluteIndex: 2)
        campusRoad.icon = UIImage(named: campusRoad.name + ".png")
        campusRoad.flagImage = UIImage(named: campusRoad.name + " Fancy Flag.png")
        campusRoad.coordinate = CLLocationCoordinate2D(latitude: 42.0599000, longitude: -73.9100421)
        campusRoad.title = campusRoad.name + " Shuttle Stop"
        
        
        let robbins = ShuttleStop(name: "Robbins", absoluteIndex: 3)
        robbins.icon = UIImage(named: robbins.name + ".png")
        robbins.flagImage = UIImage(named: robbins.name + " Fancy Flag.png")
        robbins.coordinate = CLLocationCoordinate2D(latitude: 42.0287648, longitude: -73.9046179)
        robbins.title = robbins.name + " Shuttle Stop"
        
        
        let wardGate = ShuttleStop(name: "Ward Gate", absoluteIndex: 4)
        wardGate.icon = UIImage(named: wardGate.name + ".png")
        wardGate.flagImage = UIImage(named: wardGate.name + " Fancy Flag.png")
        wardGate.coordinate = CLLocationCoordinate2D(latitude: 42.0599000, longitude: -73.9100421)
        wardGate.title = wardGate.name + " Shuttle Stop"
        
        
        let kline = ShuttleStop(name: "Kline", absoluteIndex: 5)
        kline.icon = UIImage(named: kline.name + ".png")
        kline.flagImage = UIImage(named: kline.name + " Fancy Flag.png")
        kline.coordinate = CLLocationCoordinate2D(latitude: 42.0220182, longitude: -73.9083328)
        kline.title = kline.name + " Shuttle Stop"
        
        
        let gahagan = ShuttleStop(name: "Gahagan", absoluteIndex: 6)
        gahagan.icon = UIImage(named: gahagan.name + ".png")
        gahagan.flagImage = UIImage(named: gahagan.name + " Fancy Flag.png")
        gahagan.coordinate = CLLocationCoordinate2D(latitude: 42.0287648, longitude: -73.9046179)
        gahagan.title = gahagan.name + " Shuttle Stop"
        
        
        let triangle = ShuttleStop(name: "Triangle", absoluteIndex: 7)
        triangle.icon = UIImage(named: triangle.name + ".png")
        triangle.flagImage = UIImage(named: triangle.name + " Fancy Flag.png")
        triangle.coordinate = CLLocationCoordinate2D(latitude: 42.0220182, longitude: -73.9083328)
        triangle.title = triangle.name + " Shuttle Stop"
        
        
        let churchSt = ShuttleStop(name: "Church St", absoluteIndex: 8)
        churchSt.icon = UIImage(named: churchSt.name + ".png")
        churchSt.flagImage = UIImage(named: churchSt.name + " Fancy Flag.png")
        churchSt.coordinate = CLLocationCoordinate2D(latitude: 42.0220182, longitude: -73.9083328)
        churchSt.title = churchSt.name + " Shuttle Stop"
        
        
        let redHook = ShuttleStop(name: "Red Hook", absoluteIndex: 9)
        redHook.icon = UIImage(named: redHook.name + ".png")
        redHook.flagImage = UIImage(named: redHook.name + " Fancy Flag.png")
        redHook.coordinate = CLLocationCoordinate2D(latitude: 41.9946578, longitude: -73.8760999)
        redHook.title = redHook.name + " Shuttle Stop"
        
        
        let matUbs = ShuttleStop(name: "MAT-UBS", absoluteIndex: 10)
        matUbs.icon = UIImage(named: matUbs.name + ".png")
        matUbs.flagImage = UIImage(named: matUbs.name + " Fancy Flag.png")
        matUbs.coordinate = CLLocationCoordinate2D(latitude: 42.0220182, longitude: -73.9083328)
        matUbs.title = matUbs.name + " Shuttle Stop"
        
        
        let hannaford = ShuttleStop(name: "Hannaford", absoluteIndex: 11)
        hannaford.icon = UIImage(named: hannaford.name + ".png")
        hannaford.flagImage = UIImage(named: hannaford.name + " Fancy Flag.png")
        hannaford.coordinate = CLLocationCoordinate2D(latitude: 41.9799000, longitude: -73.8808082)
        hannaford.title = hannaford.name + " Shuttle Stop"
        
        
        
        mainShuttleStops = [tivoli, robbins, kline, redHook, hannaford]
        allShuttleStops = [tivoli, monument, campusRoad, robbins, wardGate, kline, gahagan, triangle, churchSt, redHook, matUbs, hannaford]
        
    }
    
    
    
    public func stopsValidForDirection (direction: ScheduledRunDirection) -> [ShuttleStop] {
        
        var stops = [ShuttleStop]()
        
        for stop in mainShuttleStops {
            if (direction == .Northbound && stop.name != "Ward Gate") || (direction == .Southbound && stop.name != "Church St.") {
                stops.append(stop)
            }
        }
        
        return stops
        
    }
}