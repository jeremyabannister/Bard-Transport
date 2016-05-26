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
    case Sidebar
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
    let sidebar = Sidebar()
    let map = Map()
    let scheduleSelector = ScheduleSelector()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    private var widthOfOpenSidebarVisibleSelector = CGFloat(0)
    
    
    
    
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
        
        widthOfOpenSidebarVisibleSelector = 0.15
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addSidebar()
        addMap()
        addScheduleSelector()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureSidebar()
        positionSidebar()
        
        configureMap()
        positionMap()
        
        configureScheduleSelector()
        positionScheduleSelector()
        
    }
    
    
    
    // MARK: Adding
    
    func addSidebar () {
        addSubview(sidebar)
    }
    
    func addMap () {
        addSubview(map)
    }
    
    func addScheduleSelector () {
        addSubview(scheduleSelector)
    }
    
    
    // MARK: Sidebar
    func configureSidebar () {
        
        sidebar.backgroundColor = UIColor(red: (112.0/255.0), green: (17.0/255.0), blue: (9.0/255.0), alpha: 1)
        sidebar.visibleWidth = width - (width * widthOfOpenSidebarVisibleSelector)
        
        if state == MainSectorState.Sidebar {
            insertSubview(sidebar, aboveSubview: map)
        }
        
        sidebar.updateAllUI()
        
    }
    
    func positionSidebar () {
        sidebar.frame = relativeFrame
    }
    
    
    // MARK: Map
    func configureMap () {
        
        map.delegate = self
        map.backgroundColor = whiteColor
        
        if state == MainSectorState.Map {
            insertSubview(map, aboveSubview: sidebar)
        }
        
        map.updateAllUI()
    }
    
    func positionMap () {
        
        var newFrame = relativeFrame
        
        if state == MainSectorState.ScheduleSelector {
            
            newFrame.x = width * partialSlideFraction
            
        } else if state == MainSectorState.Sidebar {
            
            newFrame.x = width
            
        }
        
        
        map.frame = newFrame
    }
    
    // MARK: Schedule Selector
    func configureScheduleSelector () {
        
        scheduleSelector.delegate = self
        scheduleSelector.backgroundColor = UIColor(red: (19.0/255.0), green: (180.0/255.0), blue: (25.0/255.0), alpha: 1)
        
        scheduleSelector.shadowRadius = 5
        scheduleSelector.shadowOpacity = 0.3
        
        if state == MainSectorState.Sidebar {
            scheduleSelector.state = ScheduleSelectorState.SidebarOpen
        }
        
        scheduleSelector.updateAllUI()
    }
    
    func positionScheduleSelector () {
        
        var newFrame = relativeFrame
        
        if state == MainSectorState.Sidebar {
            
            newFrame.x = width - (width * widthOfOpenSidebarVisibleSelector)
            
        } else if state == MainSectorState.Map {
            
            newFrame.x = -width
            
        }
        
        scheduleSelector.frame = newFrame
    }
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Map
    public func mapBackPanTouchCoverWasDragged(map: Map, distance: CGFloat, velocity: CGFloat) {
        
        if state == MainSectorState.Map {
            
            var newFrame = scheduleSelector.frame
            newFrame.x += distance
            scheduleSelector.frame = newFrame
            
            var newMapFrame = map.frame
            newMapFrame.x += partialSlideFraction * distance
            map.frame = newMapFrame
            
        }
    }
    
    public func mapBackPanTouchCoverWasReleased(map: Map, velocity: CGFloat) {
        
        if state == MainSectorState.Map {
            
            var durationToRetainVelocity:CGFloat = 0.3
            let velocityMultiplier: CGFloat = 0.2
            
            let prospectiveX = scheduleSelector.x + (velocity * velocityMultiplier)
            let mapPullInflectionPoint = -width/2
            
            if prospectiveX > mapPullInflectionPoint {
                
                durationToRetainVelocity = scheduleSelector.x/velocity
                state = MainSectorState.ScheduleSelector
                
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
        
        if state == MainSectorState.Map {
            state = MainSectorState.ScheduleSelector
            scheduleSelector.state = ScheduleSelectorState.Normal
        }
        
        animatedUpdate()
        
    }
    
    
    
    // MARK: Schedule Selector
    public func scheduleSelectorWasDragged(scheduleSelector: ScheduleSelector, distance: CGFloat, velocity: CGFloat, methodCallNumber: Int) {
        
        var newScheduleSelectorFrame = scheduleSelector.frame
        newScheduleSelectorFrame.x += distance
        
        if newScheduleSelectorFrame.x < 0 {
            insertSubview(map, aboveSubview: sidebar)
        } else if newScheduleSelectorFrame.right > width {
            insertSubview(sidebar, aboveSubview: map)
        }
        
        scheduleSelector.frame = newScheduleSelectorFrame
        
        
        var newMapFrame = map.frame
        newMapFrame.x += partialSlideFraction * distance
        map.frame = newMapFrame
        
    }
    
    public func scheduleSelectorWasReleased(scheduleSelector: ScheduleSelector, velocity: CGFloat, methodCallNumber: Int) {
        var durationToRetainVelocity:CGFloat = 0.3
        let velocityMultiplier: CGFloat = 0.2
        
        let prospectiveX = scheduleSelector.x + (velocity * velocityMultiplier)
        let sidebarPullInflectionPoint = (width - widthOfOpenSidebarVisibleSelector)/2
        let mapPullInflectionPoint = -width/2
        
        var animationCurve = UIViewAnimationOptions.CurveLinear
        
        
        if state == MainSectorState.ScheduleSelector {
            
            if prospectiveX > sidebarPullInflectionPoint {
                
                state = MainSectorState.Sidebar
                scheduleSelector.state = ScheduleSelectorState.SidebarOpen
                durationToRetainVelocity = (width - widthOfOpenSidebarVisibleSelector - scheduleSelector.x)/velocity
                
            } else if prospectiveX < mapPullInflectionPoint {
                
                state = MainSectorState.Map
                durationToRetainVelocity = scheduleSelector.right/velocity
                
            }
            
        } else if state == MainSectorState.Sidebar {
            
            if methodCallNumber < 5 {
                
                state = MainSectorState.ScheduleSelector
                scheduleSelector.state = ScheduleSelectorState.Normal
                durationToRetainVelocity = CGFloat(defaultAnimationDuration)
                animationCurve = UIViewAnimationOptions.CurveEaseInOut
                
            } else {
                if prospectiveX < sidebarPullInflectionPoint {
                    
                    state = MainSectorState.ScheduleSelector
                    scheduleSelector.state = ScheduleSelectorState.Normal
                    durationToRetainVelocity = scheduleSelector.x/velocity
                    
                }
            }
            
        } else if state == MainSectorState.Map {
            
            if prospectiveX > mapPullInflectionPoint {
                
                state = MainSectorState.ScheduleSelector
                scheduleSelector.state = ScheduleSelectorState.Normal
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
        
        if state == MainSectorState.ScheduleSelector {
            
            state = MainSectorState.Sidebar
            scheduleSelector.state = ScheduleSelectorState.SidebarOpen
            
        } else if state == MainSectorState.Sidebar {
            
            state = MainSectorState.ScheduleSelector
            scheduleSelector.state = ScheduleSelectorState.Normal
            
        }
        animatedUpdate()
        
    }
    
    public func scheduleSelectorMapButtonWasPressed(scheduleSelector: ScheduleSelector) {
        
        if state == MainSectorState.ScheduleSelector {
            
            state = MainSectorState.Map
            
        }
        
        animatedUpdate()
    }
    
    public func scheduleSelectorMenuButtonWasPressed(scheduleSelector: ScheduleSelector) {
        
        if state == MainSectorState.Sidebar {
            state = MainSectorState.ScheduleSelector
            scheduleSelector.state = ScheduleSelectorState.Normal
        }
        
        
        animatedUpdate { (Bool) -> Void in
            scheduleSelector.openMenu()
        }
        
    }
    
    
}
