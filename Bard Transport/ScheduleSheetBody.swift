//
//  ScheduleSheetBody.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/30/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSheetBody: JABView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSheetBodyDelegate?
    
    // MARK: State
    public var origin = ShuttleStop()
    public var destination = ShuttleStop()
    public var dayOfWeekIndex = rightNow.dayOfWeek {
        didSet {
            if dayOfWeekIndex != oldValue {
                animateChangeOfDay(fromOldValue: oldValue)
                determineIndexPathOfNextShuttle()
                scrollToNextShuttle()
            }
        }
    }
    private var nextShuttleIndexPath: NSIndexPath? {
        didSet {
            if nextShuttleIndexPath != oldValue { // Only take action if the value has actually been changed
                if oldValue != nil { // If there was a previous value, animate it back to normal state (not the next shuttle)
                    if let oldCell = tableView.cellForRowAtIndexPath(oldValue!) as? ScheduledTimeTableViewCell {
                        oldCell.nextShuttle = false
                        oldCell.animatedUpdate()
                    }
                }
                if nextShuttleIndexPath != nil { // If there is a new value, animate to the selected state (next shuttle)
                    if let cell = tableView.cellForRowAtIndexPath(nextShuttleIndexPath!) as? ScheduledTimeTableViewCell {
                        cell.nextShuttle = true
                        cell.animatedUpdate()
                    }
                }
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    public var itineraries = [[Itinerary]]() {
        didSet {
            determineIndexPathOfNextShuttle()
            reloadTableData()
        }
    }
    
    private var gestureRecognizerAddedToTable = false
    
    // MARK: UI
    private let tableView = UITableView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ScheduleSheetBody.determineIndexPathOfNextShuttle), userInfo: nil, repeats: true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addTableView()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        configureTableView()
        positionTableView()
        
        
    }
    
    
    // MARK: Adding
    private func addTableView () {
        addSubview(tableView)
    }
    
    
    
    // MARK: Table View
    private func configureTableView () {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(ScheduledTimeTableViewCell.self, forCellReuseIdentifier: "scheduledTimeTableViewCell")
        
        tableView.allowsSelection = false
        
        
        if !gestureRecognizerAddedToTable {
            
            let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ScheduleSheetBody.leftSwipeDetected))
            leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
            tableView.addGestureRecognizer(leftSwipeRecognizer)
            
            let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ScheduleSheetBody.rightSwipeDetected))
            rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.Right
            tableView.addGestureRecognizer(rightSwipeRecognizer)
            
            gestureRecognizerAddedToTable = true
            
        }
        
    }
    
    private func positionTableView () {
        
        tableView.frame = relativeFrame
        
    }
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK: Calculations
    public func determineIndexPathOfNextShuttle () {
        
        var indexPath: NSIndexPath?
        
        func timeOfNextShuttle () -> ScheduledTime? {
            var time: ScheduledTime?
            let rightNowTime = ScheduledTime(date: rightNow)
            
            var adjustedDayOfWeek = rightNow.dayOfWeek
            if rightNowTime.time < lateNightThreshold {
                adjustedDayOfWeek -= 1
                
                if adjustedDayOfWeek < 0 {
                    adjustedDayOfWeek = 6
                }
            }
            
            if dayOfWeekIndex == adjustedDayOfWeek {
                
                if itineraries.count > dayOfWeekIndex && dayOfWeekIndex > 0 {
                    for itinerary in itineraries[dayOfWeekIndex] {
                        if var adjustedDepartureTime = itinerary.departure.departureTime?.time {
                            if adjustedDepartureTime < lateNightThreshold {
                                adjustedDepartureTime += 1440
                            }
                            
                            if ScheduledTime(date: rightNow).time <= adjustedDepartureTime {
                                if time == nil {
                                    time = itinerary.departure.departureTime
                                }
                            }
                        }
                    }
                }
            }
            
            
            return time
        }
        
        
        if itineraries.count > dayOfWeekIndex && dayOfWeekIndex > 0 {
            for i in 0 ..< itineraries[dayOfWeekIndex].count {
                let itinerary = itineraries[dayOfWeekIndex][i]
                if itinerary.departure.departureTime == timeOfNextShuttle() {
                    nextShuttleIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    return
                }
            }
        }
        
        nextShuttleIndexPath = nil
    }
    
    
    // MARK: Table View
    public func reloadTableData () {
        tableView.reloadData()
    }
    
    private func animateChangeOfDay (fromOldValue oldValue: Int) {
        
        var key = "pushFromRight"
        var subtype = kCATransitionFromRight
        var fromLeft = false {
            didSet {
                if fromLeft {
                    key = "pushFromLeft"
                    subtype = kCATransitionFromLeft
                } else {
                    key = "pushFromRight"
                    subtype = kCATransitionFromRight
                }
            }
        }
        
        if oldValue == 0 && dayOfWeekIndex == 6 {
            fromLeft = true
        } else if oldValue == 6 && dayOfWeekIndex == 0 {
            fromLeft = false // This line actually does nothing since fromLeft is alreay equal to false, but it makes the meaning more clear. If the condition is removed altogether then it will be caught by the next condition in which case we do not want fromLeft to be true
        } else if oldValue > dayOfWeekIndex {
            fromLeft = true
        }
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = subtype
        
        tableView.layer.addAnimation(transition, forKey: key)
        reloadTableData()
    }
    
    
    
    public func leftSwipeDetected () {
        delegate?.scheduleSheetBodyWasSwiped(self, direction: .Left)
    }
    
    public func rightSwipeDetected () {
        delegate?.scheduleSheetBodyWasSwiped(self, direction: .Right)
    }
    
    
    
    public func scrollToNextShuttle () {
        
        if let indexPath = nextShuttleIndexPath {
            var adjustedRow = indexPath.row
            if adjustedRow > 0 {
                adjustedRow -= 1
            }
            
            let adjustedIndexPath = NSIndexPath(forRow: adjustedRow, inSection: indexPath.section)
            
            tableView.scrollToRowAtIndexPath(adjustedIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        
    }
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK: Table View (data source)
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itineraries.count > dayOfWeekIndex && dayOfWeekIndex >= 0 {
            return itineraries[dayOfWeekIndex].count
        }
        
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("scheduledTimeTableViewCell") as? ScheduledTimeTableViewCell {
            
            if itineraries.count > dayOfWeekIndex && dayOfWeekIndex >= 0 {
                if itineraries[dayOfWeekIndex].count > indexPath.row && indexPath.row >= 0 {
                    
                    cell.itinerary = itineraries[dayOfWeekIndex][indexPath.row]
                    
                    if let nextPath = nextShuttleIndexPath {
                        if nextPath.row == indexPath.row {
                            cell.nextShuttle = true
                            cell.backgroundColor = UIColor(white: 0.5, alpha: 0.7)
                            nextShuttleIndexPath = indexPath
                        } else {
                            cell.nextShuttle = false
                            cell.backgroundColor = clearColor
                        }
                    } else {
                        cell.nextShuttle = false
                        cell.backgroundColor = clearColor
                        nextShuttleIndexPath = nil
                    }
                    
                }
            }
            
            cell.updateAllUI()
            
            return cell
        }
        
        return ScheduledTimeTableViewCell()
    }
    
    
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = ScheduleSheetTableViewSectionHeader()
        header.backgroundColor = UIColor(white: 0.8, alpha: 1)
        header.origin = origin
        header.destination = destination
        return header
        
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "."
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let path = nextShuttleIndexPath {
            if path.row == indexPath.row {
                return 60
            }
        }
        
        return 44
    }
    
    // MARK: Table View (delegate)
    
}


public protocol ScheduleSheetBodyDelegate {
    func scheduleSheetBodyWasSwiped (scheduleSheetBody: ScheduleSheetBody, direction: UISwipeGestureRecognizerDirection)
}
