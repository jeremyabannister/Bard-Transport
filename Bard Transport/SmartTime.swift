//
//  SmartTime.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 9/1/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


public enum SmartTimeError {
    case TooFarFromCampus
    case InsufficientAccessPrivileges
    case NoLocationData
}

public class SmartTime: NSObject, UserLocationManagerSubscriber {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Subscribers
    private var dataSubscribers = [SmartTimeDataSubscriber]()
    private var errorSubscribers = [SmartTimeErrorSubscriber]()
    
    // MARK: State
    public var direction: ScheduledRunDirection
    public var endOfLine = false {
        didSet {
            notifyDataSubscribersOfDataChange()
        }
    }
    
    public var closestShuttleStop: ShuttleStop?
    public var minutesUntilNextDeparture: Int?
    
    public var error: SmartTimeError? {
        didSet {
            notifyErrorSubscribersOfErrorChange()
        }
    }
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (direction: ScheduledRunDirection) {
        self.direction = direction
        
        super.init()
        
        userLocationManager.addSubscriber(self)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "determineMinutesUntilNextDeparture", userInfo: nil, repeats: true)
        
        // Give location manager enough time to update error status (1 second), then check for closest shuttle stop. Check every 10 seconds after that
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "determineClosestShuttleStopAndNotify", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "determineClosestShuttleStopAndNotify", userInfo: nil, repeats: true)
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    
    public func determineClosestShuttleStopAndNotify () {
        
        if determineClosestShuttleStop() {
            notifyDataSubscribersOfDataChange()
        }
        
    }
    
    private func determineClosestShuttleStop () -> Bool { // Returns true if the new shuttle stop is different from the previous one
        
        var different = false
        let previousClosestStop = closestShuttleStop
        let maximumDistance = CGFloat(0.5)
        
        if let userLocation = userLocationManager.currentUserLocation?.coordinate {
            
            let userPoint = CGPoint(x: userLocation.latitude, y: userLocation.longitude)
            var smallestDistance: CGFloat?
            var closestStop: ShuttleStop?
            
            for stop in shuttleStopManager.stopsValidForDirection(direction) {
                
                let stopPoint = CGPoint(x: stop.coordinate.latitude, y: stop.coordinate.longitude)
                let distance = distanceBetweenPoints(userPoint, point2: stopPoint)
                if let verifiedSmallestDistance = smallestDistance {
                    if distance < verifiedSmallestDistance {
                        smallestDistance = distance
                        closestStop = stop
                    }
                } else {
                    smallestDistance = distance
                    closestStop = stop
                }
            }
            
            var closeEnough = true
            
            if let verifiedSmallestDistance = smallestDistance {
                if verifiedSmallestDistance > maximumDistance {
                    closeEnough = false
                }
            }
            
            if closeEnough {
                if closestStop != nil {
                    closestShuttleStop = closestStop
                    error = nil
                }
            } else {
                error = .TooFarFromCampus
            }
        } else {
            if userLocationManager.error == .InsufficientAccessPrivileges {
                error = .InsufficientAccessPrivileges
            } else if userLocationManager.error == .NoLocationData {
                error = .NoLocationData
            } else {
                error = nil
            }
        }
        
        if previousClosestStop != closestShuttleStop {
            different = true
        }
        
        
        if (closestShuttleStop?.name == "Tivoli" && direction == .Northbound) || (closestShuttleStop?.name == "Hannaford" && direction == .Southbound) {
            different = false
            endOfLine = true
        } else {
            endOfLine = false
        }
        
        return different
    }
    
    
    public func determineMinutesUntilNextDeparture () {
        
        let previousMinutes = minutesUntilNextDeparture
        
        if let closestStop = closestShuttleStop {
            
            // If the time is before 5 am then get schedules for the previous day
            var dayAdjustedForLateNight = false
            var dayOfWeek = rightNow.dayOfWeek
            if ScheduledTime(date: rightNow).time < lateNightThreshold {
                dayOfWeek = rightNow.tomorrow().dayOfWeek
                dayAdjustedForLateNight = true
            }
            
            
            let scheduledStops = schedule.scheduledStopsAtShuttleStop(closestStop, onDay: dayOfWeek, inDirection: direction)
            let currentTime = ScheduledTime(date: rightNow)
            var found = false
            
            for stop in scheduledStops {
                if !found {
                    if let departureTime = stop.departureTime {
                        var adjustedDepartureTime = departureTime
                        if departureTime.time < lateNightThreshold {
                            adjustedDepartureTime = ScheduledTime(time: departureTime.time + 1440)
                        }
                        
                        if currentTime <= adjustedDepartureTime {
                            minutesUntilNextDeparture = adjustedDepartureTime.time - currentTime.time
                            found = true
                        }
                    }
                }
            }
            
            // If not found then there are no more shuttles today. Give the time until tomorrow's shuttle
            if !found {
                // Advance the day to tomorrow
                var adjustedDayOfWeekIndex = rightNow.dayOfWeek + 1
                
                // Wrap the index back to 0 (Sunday) if it has surpassed 6
                if adjustedDayOfWeekIndex > 6 {
                    adjustedDayOfWeekIndex = 0
                }
                
                // However, if it is late night and there are no more shuttles then we actually want the schedules for today because we had been showing the schedule for yesterday.
                if dayAdjustedForLateNight {
                    adjustedDayOfWeekIndex = rightNow.dayOfWeek
                }
                
                // Get the new schedule
                let tomorrowsStops = schedule.scheduledStopsAtShuttleStop(closestStop, onDay: adjustedDayOfWeekIndex, inDirection: direction)
                
                // Assuming there is a shuttle tomorrow morning, show the minutes until that one
                if tomorrowsStops.count > 0 {
                    if let firstBusTime = tomorrowsStops[0].departureTime?.time {
                        minutesUntilNextDeparture = (1440 - ScheduledTime(date: rightNow).time) + firstBusTime
                    } else {
                        minutesUntilNextDeparture = nil
                    }
                } else {
                    minutesUntilNextDeparture = nil
                }
            }
        }
        
        // If there is a new amount of minutes, notify subscribers
        if minutesUntilNextDeparture != previousMinutes {
            notifyDataSubscribersOfDataChange()
        }
    }
    
    
    // MARK:
    // MARK: Subscriptions
    // MARK:
    
    // MARK: User Location Manager
    public func userLocationDidChange() {
        
        if determineClosestShuttleStop() {
            determineMinutesUntilNextDeparture()
            notifyDataSubscribersOfDataChange()
        }
    }
    
    
    
    // MARK:
    // MARK: Subscribers
    // MARK:
    
    // MARK: Data
    
    public func addDataSubscriber (subscriber: SmartTimeDataSubscriber) {
        
        var found = false
        for oldSubscriber in dataSubscribers {
            if subscriber === oldSubscriber {
                found = true
            }
        }
        
        if !found {
            if dataSubscribers.count > 0 {
                dataSubscribers.insert(subscriber, atIndex: 0)
            } else {
                dataSubscribers.append(subscriber)
            }
        }
    }
    
    public func removeDataSubscriber (subscriber: SmartTimeDataSubscriber) {
        for i in 0 ..< dataSubscribers.count {
            if dataSubscribers[i] === subscriber {
                dataSubscribers.removeAtIndex(i)
            }
        }
    }
    
    public func notifyDataSubscribersOfDataChange () {
        for subscriber in dataSubscribers {
            subscriber.smartTimeDataDidChange()
        }
    }
    
    
    // MARK: Error
    public func addErrorSubscriber (subscriber: SmartTimeErrorSubscriber) {
        
        var found = false
        for oldSubscriber in errorSubscribers {
            if subscriber === oldSubscriber {
                found = true
            }
        }
        
        if !found {
            if errorSubscribers.count > 0 {
                errorSubscribers.insert(subscriber, atIndex: 0)
            } else {
                errorSubscribers.append(subscriber)
            }
        }
    }
    
    public func removeErrorSubscriber (subscriber: SmartTimeErrorSubscriber) {
        for i in 0 ..< errorSubscribers.count {
            if errorSubscribers[i] === subscriber {
                errorSubscribers.removeAtIndex(i)
            }
        }
    }
    
    public func notifyErrorSubscribersOfErrorChange () {
        for subscriber in errorSubscribers {
            subscriber.smartTimeErrorDidChange(self)
        }
    }
}

public protocol SmartTimeDataSubscriber: class {
    func smartTimeDataDidChange ()
}

public protocol SmartTimeErrorSubscriber: class {
    func smartTimeErrorDidChange (smartTime: SmartTime)
}