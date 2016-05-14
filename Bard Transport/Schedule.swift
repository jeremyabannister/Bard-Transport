//
//  Schedule.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/26/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class Schedule: NSObject {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: State
    private var shuttleStops: [ShuttleStop] {
        get {
            return shuttleStopManager.mainShuttleStops
        }
    }
    public var days = [ScheduledDay]()
    
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    override public init () {
        
        super.init()
        
        createSchedule()
    }
    
    
    public func createSchedule () {
        
        // Create the scheduled day corresponding to Mondays, Tuesdays and Wednesdays and append it to the days array three times to represent each day (Monday, Tuesday and Wednesday)
        
        days.append(scheduleForDay(false, lateNight: false))
        days.append(scheduleForDay(true, lateNight: false))
        days.append(scheduleForDay(true, lateNight: false))
        days.append(scheduleForDay(true, lateNight: false))
        days.append(scheduleForDay(true, lateNight: true))
        days.append(scheduleForDay(true, lateNight: true))
        days.append(scheduleForDay(false, lateNight: true))
        
    }
    
    
    public func scheduleForDay (weekday:Bool, lateNight: Bool) -> ScheduledDay {
        
        let day = ScheduledDay()
        
        
        // Tivoli, Monument, Campus Road, Robbins, Ward Gate, Kline, Gahagan, Triangle, Red Hook, MAT/UBS, Hannaford
        // Hannaford, MAT/UBS, Red Hook, Church St., Triangle, Gahagan, Kline, Robbins, Campus Road, Monument, Tivoli
        
        
        var dayRuns = [([(String, Int)], ScheduledRunDirection)]()
        
        
        if weekday { // Weekdays all have identical day time schedules
            
            dayRuns.append(([("7:50 am", 0), ("7:52 am", 0), ("7:56 am", 0), ("7:57 am", 0), ("7:58 am", 0), ("8:00 am", 0), ("8:01 am", 0), ("8:02 am", 0), ("8:10 am", 0), ("**", 0), ("**", 0)], .Southbound))
            dayRuns.append(([("**", 0), ("**", 0), ("8:10 am", 0), ("8:11 am", 0), ("8:17 am", 0), ("8:18 am", 0), ("8:20 am", 0), ("8:22 am", 0), ("8:23 am", 0), ("8:28 am", 0), ("8:30 am", 0)], .Northbound))
            
            
            
            dayRuns.append(([("8:30 am", 0), ("8:32 am", 0), ("8:36 am", 0), ("8:37 am", 0), ("8:38 am", 0), ("8:40 am", 0), ("8:41 am", 0), ("8:42 am", 0), ("8:50 am", 0), ("**", 0), ("**", 0)], .Southbound))
            dayRuns.append(([("**", 0), ("**", 0), ("8:50 am", 0), ("8:51 am", 0), ("8:58 am", 0), ("8:59 am", 0), ("9:00 am", 0), ("9:02 am", 0), ("9:03 am", 0), ("9:08 am", 0), ("9:10 am", 0)], .Northbound))
            
            
            dayRuns.append(([("9:10 am", 0), ("9:12 am", 0), ("9:16 am", 0), ("9:17 am", 0), ("9:18 am", 0), ("9:20 am", 0), ("9:21 am", 0), ("9:22 am", 0), ("9:30 am", 0), ("**", 0), ("**", 0)], .Southbound))
            dayRuns.append(([("**", 0), ("**", 0), ("9:30 am", 0), ("9:31 am", 0), ("9:38 am", 0), ("9:39 am", 0), ("9:40 am", 0), ("9:42 am", 0), ("9:43 am", 0), ("9:48 am", 0), ("9:50 am", 0)], .Northbound))
            
            
            dayRuns.append(([("9:50 am", 0), ("9:52 am", 0), ("9:56 am", 0), ("9:57 am", 0), ("9:58 am", 0), ("10:00 am", 0), ("10:21 am", 0), ("10:22 am", 0), ("10:30 am", 0), ("**", 0), ("**", 0)], .Southbound))
            dayRuns.append(([("**", 0), ("**", 0), ("10:30 am", 0), ("10:31 am", 0), ("10:38 am", 0), ("10:39 am", 0), ("10:40 am", 0), ("10:42 am", 0), ("10:43 am", 0), ("10:48 am", 0), ("10:50 am", 0)], .Northbound))
            
            
            dayRuns.append(([("10:50 am", 0), ("10:52 am", 0), ("10:56 am", 0), ("10:57 am", 0), ("10:58 am", 0), ("11:00 am", 0), ("11:01 am", 0), ("11:02 am", 0), ("11:10 am", 0), ("11:11 am", 0), ("11:20 am", 5)], .Southbound))
            dayRuns.append(([("11:25 am", 0), ("11:28 am", 0), ("11:30 am", 0), ("11:31 am", 0), ("11:38 am", 0), ("11:39 am", 0), ("11:40 am", 0), ("11:42 am", 0), ("11:43 am", 0), ("11:48 am", 0), ("11:50 am", 0)], .Northbound))
            
            dayRuns.append(([("11:50 am", 0), ("11:52 am", 0), ("11:56 am", 0), ("11:57 am", 0), ("11:58 am", 0), ("12:00 pm", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Southbound))
            dayRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("1:00 pm", 0), ("1:01 pm", 0), ("1:02 pm", 0), ("1:10 pm", 0), ("1:11 pm", 0), ("1:20 pm", 5)], .Southbound))
            dayRuns.append(([("1:25 pm", 0), ("1:28 pm", 0), ("1:30 pm", 0), ("1:31 pm", 0), ("1:38 pm", 0), ("1:39 pm", 0), ("1:40 pm", 0), ("1:42 pm", 0), ("1:43 pm", 0), ("1:48 pm", 0), ("1:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("1:50 pm", 0), ("1:52 pm", 0), ("1:56 pm", 0), ("1:57 pm", 0), ("1:58 pm", 0), ("2:00 pm", 0), ("2:01 pm", 0), ("2:02 pm", 0), ("2:10 pm", 0), ("2:11 pm", 0), ("2:20 pm", 5)], .Southbound))
            dayRuns.append(([("2:25 pm", 0), ("2:28 pm", 0), ("2:30 pm", 0), ("2:31 pm", 0), ("2:38 pm", 0), ("2:39 pm", 0), ("2:40 pm", 0), ("2:42 pm", 0), ("2:43 pm", 0), ("2:48 pm", 0), ("2:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("2:50 pm", 0), ("2:52 pm", 0), ("2:56 pm", 0), ("2:57 pm", 0), ("2:58 pm", 0), ("3:00 pm", 0), ("3:01 pm", 0), ("3:02 pm", 0), ("3:10 pm", 0), ("3:11 pm", 0), ("3:20 pm", 5)], .Southbound))
            dayRuns.append(([("3:25 pm", 0), ("3:28 pm", 0), ("3:30 pm", 0), ("3:31 pm", 0), ("3:38 pm", 0), ("3:39 pm", 0), ("3:40 pm", 0), ("3:42 pm", 0), ("3:43 pm", 0), ("3:48 pm", 0), ("3:50 pm", 0)], .Northbound))
            
            dayRuns.append(([("3:50 pm", 0), ("3:52 pm", 0), ("3:56 pm", 0), ("3:57 pm", 0), ("3:58 pm", 0), ("4:00 pm", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Southbound))
            
        } else { // Saturday and Sunday have identical day time schedules
            
            dayRuns.append(([("11:50 am", 0), ("11:52 am", 0), ("11:56 am", 0), ("11:57 am", 0), ("11:58 am", 0), ("12:00 pm", 0), ("12:01 pm", 0), ("12:02 pm", 0), ("12:10 pm", 0), ("**", 0), ("12:20 pm", 5)], .Southbound))
            dayRuns.append(([("12:25 pm", 0), ("**", 0), ("12:30 pm", 0), ("12:31 pm", 0), ("12:38 pm", 0), ("12:39 pm", 0), ("12:40 pm", 0), ("12:41 pm", 0), ("12:42 pm", 0), ("12:48 pm", 0), ("12:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("12:50 pm", 0), ("12:52 pm", 0), ("12:56 pm", 0), ("12:57 pm", 0), ("12:58 pm", 0), ("1:00 pm", 0), ("1:01 pm", 0), ("1:02 pm", 0), ("1:10 pm", 0), ("**", 0), ("1:20 pm", 5)], .Southbound))
            dayRuns.append(([("1:25 pm", 0), ("**", 0), ("1:30 pm", 0), ("1:31 pm", 0), ("1:38 pm", 0), ("1:39 pm", 0), ("1:40 pm", 0), ("1:41 pm", 0), ("1:42 pm", 0), ("1:48 pm", 0), ("1:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("1:50 pm", 0), ("1:52 pm", 0), ("1:56 pm", 0), ("1:57 pm", 0), ("1:58 pm", 0), ("2:00 pm", 0), ("2:01 pm", 0), ("2:02 pm", 0), ("2:10 pm", 0), ("**", 0), ("2:20 pm", 5)], .Southbound))
            dayRuns.append(([("2:25 pm", 0), ("**", 0), ("2:30 pm", 0), ("2:31 pm", 0), ("2:38 pm", 0), ("2:39 pm", 0), ("2:40 pm", 0), ("2:41 pm", 0), ("2:42 pm", 0), ("2:48 pm", 0), ("2:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("2:50 pm", 0), ("2:52 pm", 0), ("2:56 pm", 0), ("2:57 pm", 0), ("2:58 pm", 0), ("3:00 pm", 0), ("3:01 pm", 0), ("3:02 pm", 0), ("3:10 pm", 0), ("**", 0), ("3:20 pm", 5)], .Southbound))
            dayRuns.append(([("3:25 pm", 0), ("**", 0), ("3:30 pm", 0), ("3:31 pm", 0), ("3:38 pm", 0), ("3:39 pm", 0), ("3:40 pm", 0), ("3:41 pm", 0), ("3:42 pm", 0), ("3:48 pm", 0), ("3:50 pm", 0)], .Northbound))
            
            
            dayRuns.append(([("3:50 pm", 0), ("3:52 pm", 0), ("3:56 pm", 0), ("3:57 pm", 0), ("3:58 pm", 0), ("4:00 pm", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Southbound))
            
            
        }
        
        
        
        for runList in dayRuns {
            day.runs.append(runFromListOfTimes(runList.0, direction: runList.1))
        }
        
        
        
        var eveningRuns = [([(String, Int)], ScheduledRunDirection)]()
        
        
        // Evening
        eveningRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("5:00 pm", 0), ("5:01 pm", 0), ("5:02 pm", 0), ("5:10 pm", 0), ("5:11 pm", 0), ("5:20 pm", 5)], .Southbound))
        eveningRuns.append(([("5:25 pm", 0), ("5:28 pm", 0), ("5:30 pm", 0), ("5:31 pm", 0), ("5:38 pm", 0), ("5:39 pm", 0), ("5:40 pm", 0), ("5:42 pm", 0), ("5:43 pm", 0), ("5:48 pm", 0), ("5:50 pm", 0)], .Northbound))
        
        
        eveningRuns.append(([("5:50 pm", 0), ("5:52 pm", 0), ("5:56 pm", 0), ("5:57 pm", 0), ("5:58 pm", 0), ("6:00 pm", 0), ("6:01 pm", 0), ("6:02 pm", 0), ("6:10 pm", 0), ("**", 0), ("6:20 pm", 5)], .Southbound))
        eveningRuns.append(([("6:25 pm", 0), ("**", 0), ("6:30 pm", 0), ("6:31 pm", 0), ("6:38 pm", 0), ("6:39 pm", 0), ("6:40 pm", 0), ("6:42 pm", 0), ("6:43 pm", 0), ("6:48 pm", 0), ("6:50 pm", 0)], .Northbound))
        
        
        eveningRuns.append(([("6:50 pm", 0), ("6:52 pm", 0), ("6:56 pm", 0), ("6:57 pm", 0), ("6:58 pm", 0), ("7:00 pm", 0), ("7:01 pm", 0), ("7:02 pm", 0), ("7:10 pm", 0), ("**", 0), ("7:20 pm", 5)], .Southbound))
        eveningRuns.append(([("7:25 pm", 0), ("**", 0), ("7:30 pm", 0), ("7:31 pm", 0), ("7:38 pm", 0), ("7:39 pm", 0), ("7:40 pm", 0), ("7:42 pm", 0), ("7:43 pm", 0), ("7:48 pm", 0), ("7:50 pm", 0)], .Northbound))
        
        
        eveningRuns.append(([("7:50 am", 0), ("7:52 am", 0), ("7:56 am", 0), ("7:57 am", 0), ("7:58 am", 0), ("8:00 pm", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Southbound))
        
        
        
        for runList in eveningRuns {
            day.runs.append(runFromListOfTimes(runList.0, direction: runList.1))
        }
        
        
        
        
        var nightRuns = [([(String, Int)], ScheduledRunDirection)]()
        
        
        // Evening
        nightRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("9:00 pm", 0), ("9:01 pm", 0), ("9:02 pm", 0), ("9:10 pm", 0), ("**", 0), ("**", 0)], .Southbound))
        nightRuns.append(([("**", 0), ("**", 0), ("9:10 pm", 0), ("**", 0), ("9:17 pm", 0), ("9:18 pm", 0), ("9:20 pm", 0), ("9:22 pm", 0), ("9:23 pm", 0), ("9:28 pm", 0), ("9:30 pm", 0)], .Northbound))
        
        
        nightRuns.append(([("9:30 pm", 0), ("9:32 pm", 0), ("9:36 pm", 0), ("9:37 pm", 0), ("**", 0), ("9:40 pm", 0), ("9:41 pm", 0), ("9:42 pm", 0), ("9:50 pm", 0), ("**", 0), ("**", 0)], .Southbound))
        nightRuns.append(([("**", 0), ("**", 0), ("9:50 pm", 0), ("**", 0), ("9:57 pm", 0), ("9:58 pm", 0), ("10:00 pm", 0), ("10:02 pm", 0), ("10:03 pm", 0), ("10:08 pm", 0), ("10:10 pm", 0)], .Northbound))
        
        
        nightRuns.append(([("10:10 pm", 0), ("10:12 pm", 0), ("10:16 pm", 0), ("10:17 pm", 0), ("**", 0), ("10:20 pm", 0), ("10:22 pm", 0), ("10:23 pm", 0), ("10:30 pm", 0), ("**", 0), ("**", 0)], .Southbound))
        nightRuns.append(([("**", 0), ("**", 0), ("10:30 pm", 0), ("**", 0), ("10:37 pm", 0), ("10:38 pm", 0), ("10:40 pm", 0), ("10:42 pm", 0), ("10:43 pm", 0), ("10:48 pm", 0), ("10:50 pm", 0)], .Northbound))
        
        
        nightRuns.append(([("10:50 pm", 0), ("10:52 pm", 0), ("10:56 pm", 0), ("10:57 pm", 0), ("**", 0), ("11:00 pm", 0), ("11:02 pm", 0), ("11:03 pm", 0), ("11:10 pm", 0), ("**", 0), ("**", 0)], .Southbound))
        nightRuns.append(([("**", 0), ("**", 0), ("11:10 pm", 0), ("**", 0), ("11:17 pm", 0), ("11:18 pm", 0), ("11:20 pm", 0), ("11:22 pm", 0), ("11:23 pm", 0), ("11:28 pm", 0), ("11:30 pm", 0)], .Northbound))
        
        
        nightRuns.append(([("11:30 pm", 0), ("11:32 pm", 0), ("11:36 pm", 0), ("11:37 pm", 0), ("**", 0), ("11:40 pm", 0), ("11:41 pm", 0), ("11:42 pm", 0), ("11:50 pm", 0), ("**", 0), ("**", 0)], .Southbound))
        nightRuns.append(([("**", 0), ("**", 0), ("11:50 pm", 0), ("**", 0), ("11:57 pm", 0), ("11:58 pm", 0), ("12:00 am", 0), ("12:02 am", 0), ("12:03 am", 0), ("12:08 pm", 0), ("12:10 pm", 0)], .Northbound))
        
        
        if !lateNight {
            nightRuns.append(([("12:10 am", 0), ("12:12 am", 0), ("12:16 am", 0), ("12:17 am", 0), ("**", 0), ("12:20 pm", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Southbound))
        }
        
        
        
        for runList in nightRuns {
            day.runs.append(runFromListOfTimes(runList.0, direction: runList.1))
        }
        
        
        
        var lateNightRuns = [([(String, Int)], ScheduledRunDirection)]()
        
        if lateNight {
            
            lateNightRuns.append(([("12:10 am", 0), ("12:12 am", 0), ("12:16 am", 0), ("12:17 am", 0), ("**", 0), ("12:20 pm", 20), ("12:41 am", 0), ("12:42 am", 0), ("12:50 am", 0), ("**", 0), ("**", 0)], .Southbound))
            lateNightRuns.append(([("**", 0), ("**", 0), ("12:50 am", 0), ("**", 0), ("12:57 am", 0), ("12:58 am", 0), ("1:00 am", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Northbound))
            
            lateNightRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("1:00 am", 0), ("1:01 am", 0), ("1:02 am", 0), ("1:10 am", 0), ("**", 0), ("**", 0)], .Southbound))
            lateNightRuns.append(([("**", 0), ("**", 0), ("1:10 am", 0), ("**", 0), ("1:17 am", 0), ("1:18 am", 0), ("1:20 am", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Northbound))
            
            lateNightRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("1:20 am", 0), ("1:21 am", 0), ("1:22 am", 0), ("1:30 am", 0), ("**", 0), ("**", 0)], .Southbound))
            lateNightRuns.append(([("**", 0), ("**", 0), ("1:30 am", 0), ("**", 0), ("1:37 am", 0), ("1:38 am", 0), ("1:40 am", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Northbound))
            
            lateNightRuns.append(([("**", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0), ("1:40 am", 0), ("1:41 am", 0), ("1:42 am", 0), ("1:50 am", 0), ("**", 0), ("**", 0)], .Southbound))
            lateNightRuns.append(([("**", 0), ("**", 0), ("1:50 am", 0), ("**", 0), ("1:57 am", 0), ("1:58 am", 0), ("2:00 am", 0), ("**", 0), ("**", 0), ("**", 0), ("**", 0)], .Northbound))
            
        }
        
        for runList in lateNightRuns {
            day.runs.append(runFromListOfTimes(runList.0, direction: runList.1))
        }
        
        
        
        return day
    }
    
    
    
    private func runFromListOfTimes (times: [(String, Int)], direction: ScheduledRunDirection) -> ScheduledRun {
        
        let run = ScheduledRun()
        run.direction = direction
        for i in 0 ..< times.count {
            let timeString = times[i].0
            if timeString != "**" {
                var shuttleStop: ShuttleStop? // Create an optional shuttle stop that will only be filled if the time corresponds to one of the main 5 shuttle stops
                
                if direction == ScheduledRunDirection.Southbound {
                    if i == 0 {
                        shuttleStop = shuttleStops[0]
                    } else if i == 3 {
                        shuttleStop = shuttleStops[1]
                    } else if i == 5 {
                        shuttleStop = shuttleStops[2]
                    } else if i == 8 {
                        shuttleStop = shuttleStops[3]
                    } else if i == 10 {
                        shuttleStop = shuttleStops[4]
                    }
                } else {
                    if i == 0 {
                        shuttleStop = shuttleStops[4]
                    } else if i == 2 {
                        shuttleStop = shuttleStops[3]
                    } else if i == 6 {
                        shuttleStop = shuttleStops[2]
                    } else if i == 7 {
                        shuttleStop = shuttleStops[1]
                    } else if i == 10 {
                        shuttleStop = shuttleStops[0]
                    }
                }
                
                
                if shuttleStop != nil { // If shuttle stop
                    let scheduledStop = ScheduledStop(shuttleStop: shuttleStop!, arrivalString: timeString, intervalToDeparture: times[i].1)
                    run.scheduledStops.append(scheduledStop)
                }
            }
        }
        
        return run
    }
    
    
    
    // MARK:
    // MARK: Query
    // MARK:
    
    public func itinerariesStopsForDay (day: Int, origin: ShuttleStop, destination: ShuttleStop) -> [Itinerary] {
        
        var itineraries = [Itinerary]()
        let scheduledDay = days[day]
        
        // Determine direction of desired route
        var direction = ScheduledRunDirection.Southbound
        if origin.absoluteIndex > destination.absoluteIndex {
            direction = ScheduledRunDirection.Northbound
        } else if origin.absoluteIndex == destination.absoluteIndex {
            print("Returning empty array from Schedule.scheduledTimesForDay because origin index (\(origin.absoluteIndex)) was equal to destination index (\(destination.absoluteIndex))")
            return itineraries // Return an empty array if the origin is equal to the destination
        }
        
        
        for run in scheduledDay.runs { // Iterate over all of the runs for that day
            if run.direction == direction { // Only check the runs which go in the correct direction
                // Check if this run stops at both the origin and the destination. Save the origin stop if it is found because that is the data that needs to be returned
                var scheduledStopAtOrigin: ScheduledStop?
                var scheduledStopAtDestination: ScheduledStop?
                
                for scheduledStop in run.scheduledStops {
                    if scheduledStop.shuttleStop == origin {
                        scheduledStopAtOrigin = scheduledStop
                    } else if scheduledStop.shuttleStop == destination {
                        scheduledStopAtDestination = scheduledStop
                    }
                }
                
                
                // If the run stops at the origin and the destination then append the origin stop to the array
                if let originStop = scheduledStopAtOrigin {
                    if let destinationStop = scheduledStopAtDestination {
                        itineraries.append(Itinerary(departure: originStop, arrival: destinationStop))
                    }
                }
            }
        }
        
        
        // Return all stops at the origin that were found to also stop at the destination on that day
        return itineraries
    }
    
    
    public func scheduledStopsAtShuttleStop (shuttleStop: ShuttleStop, onDay day: Int, inDirection direction: ScheduledRunDirection) -> [ScheduledStop] {
        
        var stops = [ScheduledStop]()
        if days.count > day {
            let runs = days[day].runs
            
            for run in runs {
                if run.direction == direction {
                    for scheduledStop in run.scheduledStops {
                        if scheduledStop.shuttleStop == shuttleStop {
                            
                            stops.append(scheduledStop)
                            
                        }
                    }
                }
            }
            
            
        }
        
        return stops
    }
    
}
