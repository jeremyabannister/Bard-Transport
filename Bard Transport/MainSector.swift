//
//  MainSector.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/20/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


public enum MainSectorState {
    case ScheduleSelector
    case SidebarOpen
    case Map
}

public class MainSector: JABView, MapDelegate, ScheduleSelectorDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    public var state = MainSectorState.ScheduleSelector
    
    // MARK: UI
    let map = Map()
    let scheduleSelector = ScheduleSelector()
    let sidebar = Sidebar()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    private var widthOfSidebar = CGFloat(0)
    
    
    
    
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
        
        widthOfSidebar = 0.8
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addMap()
        addScheduleSelector()
        addSidebar()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureMap()
        positionMap()
        
        configureScheduleSelector()
        positionScheduleSelector()
        
        configureSidebar()
        positionSidebar()
        
    }
    
    
    
    // MARK: Adding
    
    private func addMap () {
        addSubview(map)
    }
    
    private func addScheduleSelector () {
        addSubview(scheduleSelector)
    }
    
    private func addSidebar () {
        addSubview(sidebar)
    }
    
    
    
    
    // MARK: Map
    private func configureMap () {
        
        map.delegate = self
        map.backgroundColor = whiteColor
        
        if state == .Map {
            insertSubview(map, aboveSubview: sidebar)
        }
        
        map.updateAllUI()
    }
    
    private func positionMap () {
        
        var newFrame = relativeFrame
        
        if state == .ScheduleSelector {
            
            newFrame.x = width * partialSlideFraction
            
        } else if state == .SidebarOpen {
            
            newFrame.x = width
            
        }
        
        
        map.frame = newFrame
    }
    
    // MARK: Schedule Selector
    private func configureScheduleSelector () {
        
        scheduleSelector.delegate = self
        scheduleSelector.backgroundColor = UIColor(red: (19.0/255.0), green: (180.0/255.0), blue: (25.0/255.0), alpha: 1)
        
        scheduleSelector.shadowRadius = 5
        scheduleSelector.shadowOpacity = 0.3
        
        if state == .SidebarOpen {
            scheduleSelector.state = .SidebarOpen
        }
        
        scheduleSelector.updateAllUI()
    }
    
    private func positionScheduleSelector () {
        
        var newFrame = bounds
        
        if state == .Map {
            
            newFrame.x = -width
            
        }
        
        scheduleSelector.frame = newFrame
    }
    
    
    // MARK: Sidebar
    private func configureSidebar () {
        
        sidebar.visibleWidth = width * widthOfSidebar
        
        sidebar.updateAllUI()
        
    }
    
    private func positionSidebar () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfSidebar
        newFrame.size.height = height
        
        newFrame.origin.y = 0
        
        if state == .SidebarOpen {
            newFrame.origin.x = 0
        } else {
            newFrame.origin.x = -newFrame.size.width
        }
        
        sidebar.frame = newFrame
    }
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Map
    public func mapBackPanTouchCoverWasDragged(map: Map, distance: CGFloat, velocity: CGFloat) {
        
        if state == .Map {
            
            var newFrame = scheduleSelector.frame
            newFrame.x += distance
            scheduleSelector.frame = newFrame
            
            var newMapFrame = map.frame
            newMapFrame.x += partialSlideFraction * distance
            map.frame = newMapFrame
            
        }
    }
    
    public func mapBackPanTouchCoverWasReleased(map: Map, velocity: CGFloat) {
        
        if state == .Map {
            
            var durationToRetainVelocity:CGFloat = 0.3
            let velocityMultiplier: CGFloat = 0.2
            
            let prospectiveX = scheduleSelector.x + (velocity * velocityMultiplier)
            let mapPullInflectionPoint = -width/2
            
            if prospectiveX > mapPullInflectionPoint {
                
                durationToRetainVelocity = scheduleSelector.x/velocity
                state = .ScheduleSelector
                
            } else {
                
                durationToRetainVelocity = (width + scheduleSelector.x)/velocity
                
            }
            
            // Edit calculated duration to ensure fluid user experience
            var castedDuration = abs(Double(durationToRetainVelocity))
            let maximumAllowedDuration = 0.4
            let minimumAllowedDuration = 0.1
            
            if castedDuration > maximumAllowedDuration {
                
                castedDuration = maximumAllowedDuration
                
            } else if ( castedDuration < minimumAllowedDuration ) {
                
                castedDuration = minimumAllowedDuration
                
            }
            
            
            animatedUpdate(castedDuration, options: .CurveLinear)
            
        }
    }
    
    
    
    
    public func mapBackButtonWasPressed(map: Map) {
        
        if state == .Map {
            state = .ScheduleSelector
            scheduleSelector.state = .Normal
        }
        
        animatedUpdate()
        
    }
    
    
    
    // MARK: Schedule Selector
    public func scheduleSelectorSidebarTouchCoverWasDragged(scheduleSelector: ScheduleSelector, distance: CGFloat, velocity: CGFloat, methodCallNumber: Int) {
        
        var newSidebarFrame = sidebar.frame
        newSidebarFrame.x += distance
        sidebar.frame = newSidebarFrame
        
    }
    
    public func scheduleSelectorSidebarTouchCoverWasReleased(scheduleSelector: ScheduleSelector, velocity: CGFloat, methodCallNumber: Int) {
        var durationToRetainVelocity:CGFloat = 0.3
        let velocityMultiplier: CGFloat = 0.2
        
        let prospectiveRight = sidebar.right + (velocity * velocityMultiplier)
        let sidebarPullInflectionPoint = (width * widthOfSidebar)/2
        let mapPullInflectionPoint = -width/2
        
        var animationCurve = UIViewAnimationOptions.CurveLinear
        
        
        if state == .ScheduleSelector {
            
            if prospectiveRight > sidebarPullInflectionPoint {
                
                state = .SidebarOpen
                scheduleSelector.state = .SidebarOpen
                durationToRetainVelocity = -sidebar.x/velocity
                
            } else if prospectiveRight < mapPullInflectionPoint {
                
                state = .Map
                durationToRetainVelocity = scheduleSelector.right/velocity
                
            }
            
        } else if state == .SidebarOpen {
            
            if methodCallNumber < 5 {
                
                state = .ScheduleSelector
                scheduleSelector.state = .Normal
                durationToRetainVelocity = CGFloat(defaultAnimationDuration)
                animationCurve = UIViewAnimationOptions.CurveEaseInOut
                
            } else {
                if prospectiveRight < sidebarPullInflectionPoint {
                    
                    state = .ScheduleSelector
                    scheduleSelector.state = .Normal
                    durationToRetainVelocity = scheduleSelector.x/velocity
                    
                }
            }
            
        } else if state == .Map {
            
            if prospectiveRight > mapPullInflectionPoint {
                
                state = .ScheduleSelector
                scheduleSelector.state = .Normal
                durationToRetainVelocity = (width - scheduleSelector.right)/velocity
                
            }
            
        }
        
        var castedDuration = abs(Double(durationToRetainVelocity))
        let maximumAllowedDuration = 0.3
        let minimumAllowedDuration = 0.1
        
        if castedDuration > maximumAllowedDuration {
            
            castedDuration = maximumAllowedDuration
            
        } else if castedDuration < minimumAllowedDuration {
            
            castedDuration = minimumAllowedDuration
            
        }
        
        animatedUpdate(castedDuration, options: animationCurve)
    }
    
    
    
    
    
    public func scheduleSelectorSidebarButtonWasPressed(scheduleSelector: ScheduleSelector) {
        
        if state == .ScheduleSelector {
            
            state = .SidebarOpen
            scheduleSelector.state = .SidebarOpen
            
        } else if state == .SidebarOpen {
            
            state = .ScheduleSelector
            scheduleSelector.state = .Normal
            
        }
        animatedUpdate()
        
    }
    
    public func scheduleSelectorMapButtonWasPressed(scheduleSelector: ScheduleSelector) {
        
        if state == .ScheduleSelector {
            
            state = .Map
            
        }
        
        animatedUpdate()
    }
    
    public func scheduleSelectorMenuButtonWasPressed(scheduleSelector: ScheduleSelector) {
        
        if state == .SidebarOpen {
            state = .ScheduleSelector
            scheduleSelector.state = .Normal
        }
        
        
        animatedUpdate { (Bool) -> Void in
            scheduleSelector.openMenu()
        }
        
    }
    
    
}
