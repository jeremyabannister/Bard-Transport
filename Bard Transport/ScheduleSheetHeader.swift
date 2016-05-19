//
//  ScheduleSheetHeader.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/21/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSheetHeader: JABView, JABTouchableViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSheetHeaderDelegate?
    
    // MARK: State
    public var origin = ShuttleStop()
    public var destination = ShuttleStop()
    public var dayOfWeekIndex: Int {
        get {
            return dayOfWeekPicker.selectedSegmentIndex
        }
        set {
            // Ensure that there is a segment represented by the newValue, and if there is, select that one
            if dayOfWeekPicker.numberOfSegments > newValue {
                dayOfWeekPicker.selectedSegmentIndex = newValue
                dayOfWeekPickerPressed() // Calling this method initiates all of the other actions that need to take place when the dayOfWeekIndex has changed
            }
        }
    }
    
    private var dayOfWeekPickerInitialized = false
    private var oldValueOfDayOfWeekIndex = rightNow.dayOfWeek
    
    // MARK: UI
    private let touchCover = JABTouchableView()
    
    private let originLabel = UILabel()
    private let destinationLabel = UILabel()
    private let toLabel = UILabel()
    
    private let dayOfWeekPicker = UISegmentedControl()
    private let bottomBorder = UIView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var betweenBufferForLabels = CGFloat(0)
    
    private var topBufferForOriginLabel = CGFloat(0)
    private var leftBufferForOriginLabel = CGFloat(0)
    
    private var rightBufferForDestinationLabel = CGFloat(0)
    
    
    private var bottomBufferForDayOfWeekPicker = CGFloat(0)
    private var widthOfDayOfWeekPicker = CGFloat(0)
    private var heightOfDayOfWeekPicker = CGFloat(0)
    
    private var heightOfBottomBorder = CGFloat(0) // Static pixel amount
    
    
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
        
    }
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        
        betweenBufferForLabels = 0.1
        
        topBufferForOriginLabel = 0.06
        leftBufferForOriginLabel = 0.1
        rightBufferForDestinationLabel = 0.1
        
        
        bottomBufferForDayOfWeekPicker = 0.03
        widthOfDayOfWeekPicker = 0.95
        heightOfDayOfWeekPicker = 0.1
        
        heightOfBottomBorder = 1
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addTouchCover()
        
        addOriginLabel()
        addDestinationLabel()
        addToLabel()
        
        addDayOfWeekPicker()
        addBottomBorder()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        
        configureTouchCover()
        positionTouchCover()
        
        
        configureOriginLabel()
        positionOriginLabel()
        
        configureDestinationLabel()
        positionDestinationLabel()
        
        configureToLabel()
        positionToLabel()
        
        
        
        configureDayOfWeekPicker()
        positionDayOfWeekPicker()
        
        configureBottomBorder()
        positionBottomBorder()
        
        
    }
    
    
    // MARK: Adding
    private func addTouchCover () {
        addSubview(touchCover)
    }
    
    
    
    private func addOriginLabel () {
        addSubview(originLabel)
    }
    
    private func addDestinationLabel () {
        addSubview(destinationLabel)
    }
    
    private func addToLabel () {
        addSubview(toLabel)
    }
    
    
    
    
    private func addDayOfWeekPicker () {
        addSubview(dayOfWeekPicker)
    }
    
    private func addBottomBorder () {
        addSubview(bottomBorder)
    }
    
    
    
    
    // MARK: Touch Cover
    private func configureTouchCover () {
        
        touchCover.delegate = self
        
    }
    
    private func positionTouchCover () {
        touchCover.frame = relativeFrame
    }
    
    
    
    
    // MARK: Origin Label
    private func configureOriginLabel () {
        
        originLabel.text = origin.name.uppercaseString
        originLabel.textColor = blackColor
        originLabel.textAlignment = NSTextAlignment.Right
        originLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        
    }
    
    private func positionOriginLabel () {
        
        if let text = originLabel.text {
            
            var newFrame = CGRectZero
            let size = originLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForOriginLabel
            newFrame.origin.y = width * topBufferForOriginLabel
            
            originLabel.frame = newFrame
        }
    }
    
    
    // MARK: Destination Label
    private func configureDestinationLabel () {
        
        destinationLabel.text = destination.name.uppercaseString
        destinationLabel.textColor = blackColor
        destinationLabel.textAlignment = NSTextAlignment.Left
        destinationLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        
    }
    
    private func positionDestinationLabel () {
        
        if let text = destinationLabel.text {
            
            var newFrame = CGRectZero
            let size = destinationLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width - newFrame.size.width - (width * rightBufferForDestinationLabel)
            newFrame.origin.y = originLabel.y
            
            destinationLabel.frame = newFrame
        }
    }
    
    
    // MARK: To Label
    private func configureToLabel () {
        
        toLabel.text = "to"
        toLabel.textColor = blackColor
        toLabel.textAlignment = NSTextAlignment.Center
        toLabel.font = UIFont(name: "Avenir", size: 18)
        
    }
    
    private func positionToLabel () {
        
        if let text = toLabel.text {
            
            var newFrame = CGRectZero
            let size = toLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = originLabel.right + (destinationLabel.left - originLabel.right - newFrame.size.width)/2
            newFrame.origin.y = originLabel.y + (originLabel.height - newFrame.size.height)/2
            
            toLabel.frame = newFrame
        }
    }
    
    
    
    
    
    
    
    // MARK: Day Of Week Picker
    private func configureDayOfWeekPicker () {
        
        if !dayOfWeekPickerInitialized {
            dayOfWeekPickerInitialized = true
            let titles = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            var todayIndex: Int?
            for i in 0 ..< titles.count {
                dayOfWeekPicker.insertSegmentWithTitle(titles[i], atIndex: i, animated: false)
                
                if titles[i] == rightNow.dayOfWeekStringShort {
                    todayIndex = i
                }
            }
            
            if let index = todayIndex {
                dayOfWeekPicker.selectedSegmentIndex = index
            }
            
            dayOfWeekPicker.addTarget(self, action: "dayOfWeekPickerPressed", forControlEvents: UIControlEvents.ValueChanged)
        }
        
        
        dayOfWeekPicker.tintColor = blackColor
    }
    
    private func positionDayOfWeekPicker () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfDayOfWeekPicker
        newFrame.size.height = width * heightOfDayOfWeekPicker
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = height - heightOfBottomBorder - newFrame.size.height - (width * bottomBufferForDayOfWeekPicker)
        
        dayOfWeekPicker.frame = newFrame
        
    }
    
    
    
    // MARK: Bottom Border
    private func configureBottomBorder () {
        
        bottomBorder.backgroundColor = blackColor
        
    }
    
    private func positionBottomBorder () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = heightOfBottomBorder
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = height - newFrame.size.height
        
        bottomBorder.frame = newFrame
        
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Buttons
    public func dayOfWeekPickerPressed () {
        
        delegate?.scheduleSheetHeaderDayOfWeekIndexDidChange(self, oldValue: oldValueOfDayOfWeekIndex)
        
        if dayOfWeekIndex != oldValueOfDayOfWeekIndex {
            oldValueOfDayOfWeekIndex = dayOfWeekIndex
        }
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Touchable View
    public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.scheduleSheetHeaderWasDragged(self, yDistance: yDistance)
        
    }
    
    public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.scheduleSheetHeaderWasReleased(self, yVelocity: yVelocity, methodCallNumber: methodCallNumber)
        
    }
    
    public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.scheduleSheetHeaderWasReleased(self, yVelocity: yVelocity, methodCallNumber: methodCallNumber)
        
    }
    
}


public protocol ScheduleSheetHeaderDelegate {
    func scheduleSheetHeaderWasDragged (scheduleSheetHeader: ScheduleSheetHeader, yDistance: CGFloat)
    func scheduleSheetHeaderWasReleased (scheduleSheetHeader: ScheduleSheetHeader, yVelocity: CGFloat, methodCallNumber: Int)
    
    func scheduleSheetHeaderDayOfWeekIndexDidChange (scheduleSheetHeader: ScheduleSheetHeader, oldValue: Int)
}
