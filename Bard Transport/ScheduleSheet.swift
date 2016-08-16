//
//  ScheduleSheet.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/21/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSheet: JABView, ScheduleSheetHeaderDelegate, ScheduleSheetBodyDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSheetDelegate?
    
    // MARK: State
    public var origin = ShuttleStop()
    public var destination = ShuttleStop()
    public var visibleHeight = CGFloat(0)
    
    
    // MARK: UI
    private let header = ScheduleSheetHeader()
    private let body = ScheduleSheetBody()
    
    private let tableView = UITableView()
    
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var heightOfHeader = CGFloat(0)
    private let times = ["7:50 am", "8:30 am", "9:10 am", "9:50 am", "10:50 am", "11:50 am", "1:50 pm", "2:50 pm", "3:50 pm", "5:50 pm", "6:50 pm", "7:50 pm", "9:30 pm", "10:10 pm", "10:50 pm", "11:30", "12:10 am"]
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
        
        configureHeader()
        positionHeader()
        
    }
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        heightOfHeader = 0.32
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addHeader()
        addBody()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureHeader()
        positionHeader()
        
        configureBody()
        positionBody()
        
    }
    
    
    // MARK: Adding
    private func addHeader () {
        addSubview(header)
    }
    
    private func addBody () {
        addSubview(body)
    }
    
    
    
    
    // MARK: Header
    private func configureHeader () {
        
        header.delegate = self
        header.clipsToBounds = true
        
        header.origin = origin
        header.destination = destination
        
        header.updateAllUI()
        
    }
    
    private func positionHeader () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = width * heightOfHeader
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = 0
        
        header.frame = newFrame
        
    }
    
    
    // MARK: Body
    private func configureBody () {
        
        body.delegate = self
        body.clipsToBounds = true
        body.origin = origin
        body.destination = destination
        
    }
    
    private func positionBody () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = visibleHeight - (width * heightOfHeader)
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = header.bottom
        
        body.frame = newFrame
        
    }
    
    
    
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Public
    public func reloadTableData () {
        body.reloadTableData()
    }
    
    // MARK: Body
    public func loadWithOrigin (origin: ShuttleStop, destination: ShuttleStop) {
        
        self.origin = origin
        self.destination = destination
        
        // Check if the time is before 5 am, meaning we show the schedule for yesterday.
        if ScheduledTime(date: rightNow).time < lateNightThreshold {
            header.dayOfWeekIndex = rightNow.dayOfWeek - 1
            
            // If the dayOfWeekIndex has dropped below 0 then jump back to 6 (Saturday)
            if header.dayOfWeekIndex < 0 {
                header.dayOfWeekIndex = 6
            }
            
        } else {
            header.dayOfWeekIndex = rightNow.dayOfWeek
        }
        
        
        body.itineraries = [[Itinerary]]()
        
        for i in 0 ..< 7 {
            body.itineraries.append(schedule.itinerariesForStopsAndDay(i, origin: origin, destination: destination))
        }
        
        body.reloadTableData()
        body.scrollToNextShuttle()
        
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK: Schedule Sheet Header
    public func scheduleSheetHeaderWasDragged(scheduleSheetHeader: ScheduleSheetHeader, yDistance: CGFloat) {
        delegate?.scheduleSheetWasDragged(self, yDistance: yDistance)
    }
    
    public func scheduleSheetHeaderWasReleased(scheduleSheetHeader: ScheduleSheetHeader, yVelocity: CGFloat, methodCallNumber: Int) {
        delegate?.scheduleSheetWasReleased(self, yVelocity: yVelocity, methodCallNumber: methodCallNumber)
    }
    
    
    
    
    public func scheduleSheetHeaderDayOfWeekIndexDidChange(scheduleSheetHeader: ScheduleSheetHeader, oldValue: Int) {
        
        body.dayOfWeekIndex = header.dayOfWeekIndex
        
    }
    
    
    
    // MARK: Schedule Sheet Body
    public func scheduleSheetBodyWasSwiped(scheduleSheetBody: ScheduleSheetBody, direction: UISwipeGestureRecognizerDirection) {
        
        if direction == .Left {
            if header.dayOfWeekIndex == 6 {
                header.dayOfWeekIndex = 0
            } else {
                header.dayOfWeekIndex += 1
            }
        } else if direction == .Right {
            if header.dayOfWeekIndex == 0 {
                header.dayOfWeekIndex = 6
            } else {
                header.dayOfWeekIndex -= 1
            }
        }
        
    }
    
    
}


public protocol ScheduleSheetDelegate {
    func scheduleSheetWasDragged (scheduleSheet: ScheduleSheet, yDistance: CGFloat)
    func scheduleSheetWasReleased (scheduleSheet: ScheduleSheet, yVelocity: CGFloat, methodCallNumber: Int)
}
