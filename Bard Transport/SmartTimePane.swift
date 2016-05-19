//
//  SmartTimePane.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 9/1/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


private enum SmartTimePaneState {
    case HoursAndMinutes
    case Minutes
    case EndOfLine
}

public class SmartTimePane: JABView, SmartTimeDataSubscriber {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    private var state = SmartTimePaneState.HoursAndMinutes
    public var smartTime: SmartTime {
        didSet {
            smartTimeInitialized = true
            oldValue.removeDataSubscriber(self)
            smartTime.addDataSubscriber(self)
        }
    }
    public var smartTimeInitialized = false
    
    // MARK: UI
    private let directionLabel = UILabel()
    private let shuttleStopIcon = UIImageView()
    private let shuttleStopLabel = UILabel()
    
    
    private let minutesLabel = UILabel()
    private let minutesTitleLabel = UILabel()
    
    private let hoursLabel = UILabel()
    private let hoursTitleLabel = UILabel()
    
    private let endOfLineErrorView = SmartTimesPaneEndOfLineErrorView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var leftBufferForDirectionLabel = CGFloat(0)
    private var topBufferForDirectionLabel = CGFloat(0)
    
    private var heightOfShuttleStopIcon = CGFloat(0)
    
    private var bufferBetweenDirectionLabelAndShuttleStopIcon = CGFloat(0)
    private var bufferBetweenShuttleStopIconAndShuttleStopLabel = CGFloat(0)
    
    private var rightBufferForMinutesTitleLabel = CGFloat(0)
    private var bufferBetweenMinutesLabelAndMinutesTitleLabel = CGFloat(0)
    private var bufferBetweenHoursTitleLabelAndMinutesTitleLabel = CGFloat(0)
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public init (smartTime: SmartTime) {
        
        self.smartTime = smartTime
        
        super.init()
        
        smartTime.addDataSubscriber(self)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        smartTime = SmartTime(direction: .Southbound)
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        leftBufferForDirectionLabel = 0.07
        topBufferForDirectionLabel = 0.07
        
        heightOfShuttleStopIcon = 0.1
        
        bufferBetweenDirectionLabelAndShuttleStopIcon = 0.007
        bufferBetweenShuttleStopIconAndShuttleStopLabel = 0.01
        
        
        rightBufferForMinutesTitleLabel = 0.07
        bufferBetweenMinutesLabelAndMinutesTitleLabel = -0.04
        bufferBetweenHoursTitleLabelAndMinutesTitleLabel = 0.05
        
        
        if iPad {
            
        }
        
    }
    
    
    public func printStuff () {
        print("printing stuff")
        print("minute label width is \(minutesLabel.width)")
        print("minute title label width is \(minutesTitleLabel.width)")
        print("")
        print("minuteLabel x is \(minutesLabel.x)")
        print("minuteTitleLabel x is \(minutesTitleLabel.x)")
    }
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addDirectionLabel()
        addShuttleStopIcon()
        addShuttleStopLabel()
        
        
        addMinutesTitleLabel()
        addMinutesLabel()
        
        addHoursTitleLabel()
        addHoursLabel()
        
        
        addEndOfLineErrorView()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        
        configureDirectionLabel()
        positionDirectionLabel()
        
        configureShuttleStopIcon()
        positionShuttleStopIcon()
        
        configureShuttleStopLabel()
        positionShuttleStopLabel()
        
        
        
        
        configureMinutesTitleLabel()
        positionMinutesTitleLabel()
        
        configureMinutesLabel()
        positionMinutesLabel()
        
        
        
        configureHoursTitleLabel()
        positionHoursTitleLabel()
        
        configureHoursLabel()
        positionHoursLabel()
        
        
        
        configureEndOfLineErrorView()
        positionEndOfLineErrorView()
        
    }
    
    
    // MARK: Adding
    private func addDirectionLabel () {
        addSubview(directionLabel)
    }
    
    private func addShuttleStopIcon () {
        addSubview(shuttleStopIcon)
    }
    
    private func addShuttleStopLabel () {
        addSubview(shuttleStopLabel)
    }
    
    
    
    
    
    
    private func addMinutesTitleLabel () {
        addSubview(minutesTitleLabel)
    }
    
    private func addMinutesLabel () {
        addSubview(minutesLabel)
    }
    
    
    
    
    private func addHoursTitleLabel () {
        addSubview(hoursTitleLabel)
    }
    
    private func addHoursLabel () {
        addSubview(hoursLabel)
    }
    
    
    
    private func addEndOfLineErrorView () {
        addSubview(endOfLineErrorView)
    }
    
    
    
    
    
    // MARK: Direction Label
    private func configureDirectionLabel () {
        
        if smartTime.direction == .Southbound {
            directionLabel.text = "Southbound from:"
        } else if smartTime.direction == .Northbound {
            directionLabel.text = "Northbound from:"
        }
        
        directionLabel.textAlignment = .Center
        directionLabel.textColor = blackColor
        directionLabel.font = UIFont(name: "Avenir", size: 12)
        
        
        if state == .HoursAndMinutes || state == .Minutes {
            directionLabel.opacity = 1
        } else {
            directionLabel.opacity = 0
        }
        
    }
    
    private func positionDirectionLabel () {
        
        if let text = directionLabel.text {
            
            var newFrame = CGRectZero
            let size = directionLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForDirectionLabel
            newFrame.origin.y = width * topBufferForDirectionLabel
            
            directionLabel.frame = newFrame
        }
    }
    
    
    
    // MARK: Shuttle Stop Icon
    private func configureShuttleStopIcon () {
        
        shuttleStopIcon.image = smartTime.closestShuttleStop?.icon
        
        if state == .HoursAndMinutes || state == .Minutes {
            shuttleStopIcon.opacity = 1
        } else {
            shuttleStopIcon.opacity = 0
        }
    }
    
    private func positionShuttleStopIcon () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * heightOfShuttleStopIcon
        newFrame.size.height = newFrame.size.width
        
        newFrame.origin.x = directionLabel.x
        newFrame.origin.y = directionLabel.bottom + width * bufferBetweenDirectionLabelAndShuttleStopIcon
        
        shuttleStopIcon.frame = newFrame
        
    }
    
    
    
    // MARK: Shuttle Stop Label
    private func configureShuttleStopLabel () {
        
        shuttleStopLabel.text = smartTime.closestShuttleStop?.name
        shuttleStopLabel.textAlignment = .Center
        shuttleStopLabel.textColor = blackColor
        shuttleStopLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        
        
        if state == .HoursAndMinutes || state == .Minutes {
            shuttleStopLabel.opacity = 1
        } else {
            shuttleStopLabel.opacity = 0
        }
        
    }
    
    private func positionShuttleStopLabel () {
        
        if let text = shuttleStopLabel.text {
            
            var newFrame = CGRectZero
            let size = shuttleStopLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = shuttleStopIcon.right + width * bufferBetweenShuttleStopIconAndShuttleStopLabel
            newFrame.origin.y = shuttleStopIcon.y + (shuttleStopIcon.height - newFrame.size.height)/2
            
            shuttleStopLabel.frame = newFrame
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: Minutes Title Label
    private func configureMinutesTitleLabel () {
        
        if let text = minutesLabel.text {
            if let minuteAmount = Int(text) {
                if minuteAmount == 1 {
                    minutesTitleLabel.text = "Minute"
                } else {
                    minutesTitleLabel.text = "Minutes"
                }
            } else {
                minutesTitleLabel.text = "Minutes"
            }
        } else {
            minutesTitleLabel.text = "Minutes"
        }
        
        minutesTitleLabel.text = "Minutes"
        
        minutesTitleLabel.textAlignment = .Center
        minutesTitleLabel.textColor = blackColor
        minutesTitleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        
        
        if state == .HoursAndMinutes || state == .Minutes {
            minutesTitleLabel.opacity = 1
        } else {
            minutesTitleLabel.opacity = 0
        }
        
    }
    
    private func positionMinutesTitleLabel () {
        
        if let text = minutesTitleLabel.text {
            
            var newFrame = CGRectZero
            let size = minutesTitleLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width - newFrame.size.width - (width * rightBufferForMinutesTitleLabel)
            newFrame.origin.y = (height - (minutesLabel.height + newFrame.size.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)))/2 + minutesLabel.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)
            
            minutesTitleLabel.frame = newFrame
        }
    }
    
    
    // MARK: Minutes Label
    private func configureMinutesLabel () {
        
        if let minutes = smartTime.minutesUntilNextDeparture {
            minutesLabel.text = "\(minutes % 60)"
            if minutes > 5 {
                minutesLabel.textColor = cyanColor
            } else {
                minutesLabel.textColor = redColor
            }
        } else {
            minutesLabel.text = "n/a"
            minutesLabel.textColor = cyanColor
        }
        
        minutesLabel.textAlignment = .Center
        
        minutesLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 36)
        
        if state == .HoursAndMinutes || state == .Minutes {
            minutesLabel.opacity = 1
        } else {
            minutesLabel.opacity = 0
        }
        
    }
    
    private func positionMinutesLabel () {
        
        if let text = minutesLabel.text {
            
            var newFrame = CGRectZero
            let size = minutesLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width + 0.14 // This small correction factor fixes the problem of the minutes title label not being centered on the minute label. I do not know why, but it seems like it might be a screen resolution problem. This problem does not occur on the simulator on the macbook retina screen.
            newFrame.size.height = size.height
            
            newFrame.origin.x = minutesTitleLabel.x + (minutesTitleLabel.width - newFrame.size.width)/2
            newFrame.origin.y = (height - (newFrame.size.height + minutesTitleLabel.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)))/2
            
            minutesLabel.frame = newFrame
        }
        
        positionMinutesTitleLabel()
    }
    
    
    
    
    
    
    
    
    // MARK: Hours Title Label
    private func configureHoursTitleLabel () {
        
        if let minutes = smartTime.minutesUntilNextDeparture {
            if minutes >= 60 && minutes < 120 {
                hoursTitleLabel.text = "Hour"
            } else {
                hoursTitleLabel.text = "Hours"
            }
        } else {
            hoursTitleLabel.text = "Hours"
        }
        
        hoursTitleLabel.textAlignment = .Center
        hoursTitleLabel.textColor = blackColor
        hoursTitleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        
        
        if state == .HoursAndMinutes {
            hoursTitleLabel.opacity = 1
        } else {
            hoursTitleLabel.opacity = 0
        }
        
    }
    
    private func positionHoursTitleLabel () {
        
        if let text = hoursTitleLabel.text {
            
            var newFrame = CGRectZero
            let size = hoursTitleLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = minutesTitleLabel.x - newFrame.size.width - (width * bufferBetweenHoursTitleLabelAndMinutesTitleLabel)
            newFrame.origin.y = (height - (hoursLabel.height + newFrame.size.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)))/2 + hoursLabel.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)
            
            hoursTitleLabel.frame = newFrame
        }
    }
    
    
    // MARK: Hours Label
    private func configureHoursLabel () {
        
        if let minutes = smartTime.minutesUntilNextDeparture {
            hoursLabel.text = "\((minutes - (minutes % 60))/60)"
        } else {
            hoursLabel.text = "n/a"
        }
        
        hoursLabel.textAlignment = .Center
        hoursLabel.textColor = cyanColor
        hoursLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 36)
        
        if state == .HoursAndMinutes {
            hoursLabel.opacity = 1
        } else {
            hoursLabel.opacity = 0
        }
    }
    
    private func positionHoursLabel () {
        
        if let text = hoursLabel.text {
            
            var newFrame = CGRectZero
            let size = hoursLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = hoursTitleLabel.x + (hoursTitleLabel.width - newFrame.size.width)/2
            newFrame.origin.y = (height - (newFrame.size.height + hoursTitleLabel.height + (width * bufferBetweenMinutesLabelAndMinutesTitleLabel)))/2
            
            hoursLabel.frame = newFrame
        }
        positionHoursTitleLabel()
    }
    
    
    
    
    
    
    
    // MARK: End Of Line Error View
    private func configureEndOfLineErrorView () {
        
        if smartTime.closestShuttleStop?.name == "Tivoli" {
            endOfLineErrorView.state = .Tivoli
        } else if smartTime.closestShuttleStop?.name == "Hannaford" {
            endOfLineErrorView.state = .Hannaford
        }
        
        
        if state == .EndOfLine {
            endOfLineErrorView.opacity = 1
        } else {
            endOfLineErrorView.opacity = 0
        }
        
        
        endOfLineErrorView.updateAllUI()
    }
    
    private func positionEndOfLineErrorView () {
        
        endOfLineErrorView.frame = relativeFrame
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK:
    // MARK: Subscriptions
    // MARK:
    
    // MARK: Smart Time
    public func smartTimeDataDidChange() {
        
        if smartTime.error == nil {
            if smartTime.endOfLine {
                state = .EndOfLine
            } else {
                if smartTime.minutesUntilNextDeparture < 60 {
                    state = .Minutes
                } else {
                    state = .HoursAndMinutes
                }
            }
        }
        
        animatedUpdate()
    }
    
}

