//
//  Sidebar.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/20/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class Sidebar: JABView {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    public var visibleWidth = CGFloat(0)
    
    // MARK: UI
    private var items = [SidebarItem]()
    
    private let smartTimes = SmartTimes()
    private let menu = SidebarMenu()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var topBufferForTopItem = CGFloat(0)
    private var sideBufferForItems = CGFloat(0)
    private var betweenBufferForItems = CGFloat(0)
    
    
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
        
        topBufferForTopItem = 0.1
        sideBufferForItems = 0.05
        betweenBufferForItems = 0.05
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addSmartTimes()
        addMenu()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureSmartTimes()
        configureMenu()
        
        positionSidebarItems()
        
    }
    
    
    // MARK: Adding
    private func addSmartTimes () {
        addSubview(smartTimes)
        items.append(smartTimes)
    }
    
    private func addMenu () {
        addSubview(menu)
        items.append(menu)
    }
    
    
    
    
    // MARK: Smart Times
    private func configureSmartTimes () {
        
        smartTimes.backgroundColor = whiteColor
        smartTimes.cornerRadius = 10
        smartTimes.clipsToBounds = true
        
    }
    
    
    // MARK: Menu
    private func configureMenu () {
        
        menu.backgroundColor = whiteColor
        menu.cornerRadius = 10
        menu.clipsToBounds = true
        
    }
    
    
    
    
    // MARK: Sidebar Items
    private func positionSidebarItems () {
        
        var previousItem = SidebarItem()
        var firstItem = true
        
        for item in items {
            
            var newFrame = CGRectZero
            
            newFrame.size.width = visibleWidth - (visibleWidth * 2 * sideBufferForItems)
            newFrame.size.height = newFrame.size.width * item.heightToWidthRatio
            
            newFrame.origin.x = (visibleWidth - newFrame.size.width)/2
            
            if firstItem {
                newFrame.origin.y = visibleWidth * topBufferForTopItem
                firstItem = false
            } else {
                newFrame.origin.y = previousItem.bottom + (visibleWidth * betweenBufferForItems)
            }
            
            item.frame = newFrame
            
            previousItem = item
        }
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
}
