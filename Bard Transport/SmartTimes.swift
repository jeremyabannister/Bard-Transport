//
//  SmartTimes.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/22/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


public class SmartTimes: SidebarItem, SmartTimeErrorSubscriber, SmartTimesInsufficientAccessPrivilegesErrorViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    private var error: SmartTimeError?
    
    // MARK: UI
    private let northboundSmartTimePane = SmartTimePane(smartTime: SmartTime(direction: .Northbound))
    private let divider = UIView()
    private let southboundSmartTimePane = SmartTimePane(smartTime: SmartTime(direction: .Southbound))
    
    private let tooFarFromCampusErrorView = SmartTimesTooFarFromCampusErrorView()
    private let insufficientAccessPrivilegesErrorView = SmartTimesInsufficientAccessPrivilegesErrorView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var widthOfDivider = CGFloat(0)
    private var heightOfDivider = CGFloat(0) // Static pixel amount
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        heightToWidthRatio = 0.6
        
        //        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "sendUserToAppSettings", userInfo: nil, repeats: false)
        
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
        
        widthOfDivider = 0.95
        heightOfDivider = 1 // Static pixel amount
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addNorthboundSmartTimePane()
        addDivider()
        addSouthboundSmartTimePane()
        
        addTooFarFromCampusErrorView()
        addInsufficientAccessPrivilegesErrorView()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        
        configureNorthboundSmartTimePane()
        positionNorthboundSmartTimePane()
        
        configureDivider()
        positionDivider()
        
        configureSouthboundSmartTimePane()
        positionSouthboundSmartTimePane()
        
        
        
        
        
        configureTooFarFromCampusErrorView()
        positionTooFarFromCampusErrorView()
        
        configureInsufficientAccessPrivilegesErrorView()
        positionInsufficientAccessPrivilegesErrorView()
        
    }
    
    
    // MARK: Adding
    private func addNorthboundSmartTimePane () {
        addSubview(northboundSmartTimePane)
    }
    
    private func addDivider () {
        addSubview(divider)
    }
    
    private func addSouthboundSmartTimePane () {
        addSubview(southboundSmartTimePane)
    }
    
    
    
    
    
    private func addTooFarFromCampusErrorView () {
        addSubview(tooFarFromCampusErrorView)
    }
    
    private func addInsufficientAccessPrivilegesErrorView () {
        addSubview(insufficientAccessPrivilegesErrorView)
    }
    
    
    
    
    // MARK: Northbound Smart Time Pane
    private func configureNorthboundSmartTimePane () {
        
        northboundSmartTimePane.smartTime.addErrorSubscriber(self)
        
        
        if error == nil {
            northboundSmartTimePane.opacity = 1
        } else {
            northboundSmartTimePane.opacity = 0
        }
        
    }
    
    private func positionNorthboundSmartTimePane () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = (height - heightOfDivider)/2
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = 0
        
        northboundSmartTimePane.frame = newFrame
        
    }
    
    
    
    // MARK: Divider
    private func configureDivider () {
        
        divider.backgroundColor = blackColor
        
        if error == nil {
            divider.opacity = 1
        } else {
            divider.opacity = 0
        }
        
    }
    
    private func positionDivider () {
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfDivider
        newFrame.size.height = heightOfDivider
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = northboundSmartTimePane.bottom
        
        divider.frame = newFrame
    }
    
    
    
    // MARK: Southbound Smart Time Pane
    private func configureSouthboundSmartTimePane () {
        
        if error == nil {
            southboundSmartTimePane.opacity = 1
        } else {
            southboundSmartTimePane.opacity = 0
        }
        
        
    }
    
    private func positionSouthboundSmartTimePane () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = (height - heightOfDivider)/2
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = divider.bottom
        
        southboundSmartTimePane.frame = newFrame
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: Too Far From Campus Error View
    private func configureTooFarFromCampusErrorView () {
        
        if error == .TooFarFromCampus {
            tooFarFromCampusErrorView.opacity = 1
        } else {
            tooFarFromCampusErrorView.opacity = 0
        }
        
    }
    
    private func positionTooFarFromCampusErrorView () {
        
        tooFarFromCampusErrorView.frame = relativeFrame
    }
    
    
    
    // MARK: Insufficient Access Privileges Error View
    private func configureInsufficientAccessPrivilegesErrorView () {
        
        insufficientAccessPrivilegesErrorView.delegate = self
        
        if error == .InsufficientAccessPrivileges {
            insufficientAccessPrivilegesErrorView.opacity = 1
        } else {
            insufficientAccessPrivilegesErrorView.opacity = 0
        }
        
    }
    
    private func positionInsufficientAccessPrivilegesErrorView () {
        
        insufficientAccessPrivilegesErrorView.frame = relativeFrame
        
    }
    
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Error Views
    /// Sends the user to app settings
    public func sendUserToAppSettings () {
        if let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Insufficient
    public func smartTimesInsufficientAccessPrivilegesErrorViewWasPressed(smartTimesInsufficientAccessPrivilegesErrorView: SmartTimesInsufficientAccessPrivilegesErrorView) {
        sendUserToAppSettings()
    }
    
    
    // MARK:
    // MARK: Subscriptions
    // MARK:
    
    // MARK: Smart Time
    public func smartTimeErrorDidChange (smartTime: SmartTime) {
        
        error = smartTime.error
        animatedUpdate()
        
    }
}
