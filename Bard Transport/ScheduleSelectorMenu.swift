//
//  ScheduleSelectorMenu.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 5/24/16.
//  Copyright © 2016 Jeremy Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSelectorMenu: JABView, ScheduleSelectorMenuItemViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSelectorMenuDelegate?
    
    // MARK: State
    private var menuItems = [ScheduleSelectorMenuItem()]
    
    public var open = false
    
    private let heightToWidthRatioOfSingleItem = CGFloat(0.25)
    public var heightToWidthRatio: CGFloat {
        get {
            return (CGFloat(menuItems.count) * heightToWidthRatioOfSingleItem)
        }
    }
    
    // MARK: UI
    private let blurLayer = UIVisualEffectView()
    private var menuItemViews = [ScheduleSelectorMenuItemView]()
    private var menuItemDividers = [UIView]()
    
    
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
        
        createMenuItems()
    }
    
    required public init(coder aDecoder: NSCoder) {
        
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
        
        addBlurLayer()
        addMenuItemViews()
        addMenuItemDividers()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureBlurLayer()
        positionBlurLayer()
        
        
        configureMenuItemViews()
        positionMenuItemViews()
        
        
        
        configureMenuItemDividers()
        positionMenuItemDividers()
        
    }
    
    
    // MARK: Adding
    private func addBlurLayer () {
        addSubview(blurLayer)
    }
    
    private func addMenuItemViews () {
        
        for menuItemView in menuItemViews {
            addSubview(menuItemView)
        }
        
    }
    
    private func addMenuItemDividers () {
        
        for menuItemDivider in menuItemDividers {
            addSubview(menuItemDivider)
        }
    }
    
    
    // MARK: Blur Layer
    private func configureBlurLayer () {
        blurLayer.effect = UIBlurEffect(style: .ExtraLight)
    }
    
    private func positionBlurLayer () {
        blurLayer.frame = bounds
    }
    
    
    
    // MARK: Menu Item Views
    private func configureMenuItemViews () {
        
        for menuItemView in menuItemViews {
            menuItemView.delegate = self
            menuItemView.open = open
        }
        
    }
    
    private func positionMenuItemViews () {
        
        for i in 0..<menuItemViews.count {
            let menuItemView = menuItemViews[i]
            
            var newFrame = CGRectZero
            
            newFrame.size.width = width
            newFrame.size.height = newFrame.size.width * heightToWidthRatioOfSingleItem
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = CGFloat(i) * newFrame.size.height
            
            menuItemView.frame = newFrame
        }
        
    }
    
    
    
    
    // MARK: Menu Item Dividers
    private func configureMenuItemDividers () {
        
        for menuItemDivider in menuItemDividers {
            menuItemDivider.backgroundColor = UIColor(white: 0.7, alpha: 0.3)
        }
        
    }
    
    private func positionMenuItemDividers () {
        
        for i in 0 ..< menuItemDividers.count {
            if menuItemViews.count > i {
                let menuItemDivider = menuItemDividers[i]
                
                var newFrame = CGRectZero
                
                newFrame.size.width = width
                newFrame.size.height = 1
                
                newFrame.origin.x = (width - newFrame.size.width)/2
                newFrame.origin.y = menuItemViews[i].bottom + (newFrame.size.height/2)
                
                
                menuItemDivider.frame = newFrame
            }
        }
        
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Creation
    private func createMenuItems () {
        
        menuItems.removeAll() // This is because the menu starts with an empty menuItem by default
        
        
        // Help Item
        let helpMenuItem = ScheduleSelectorMenuItem()
        
        helpMenuItem.identifier = "help"
        helpMenuItem.image = UIImage(named: "Help Button.png")
        helpMenuItem.text = "Help"
        
        menuItems.append(helpMenuItem)
        
        
        
        // Profile Item
        let profileMenuItem = ScheduleSelectorMenuItem()
        
        profileMenuItem.identifier = "profile"
        profileMenuItem.image = UIImage(named: "Profile Button.png")
        profileMenuItem.text = "Profile"
        
        menuItems.append(profileMenuItem)
        
        
        
        createMenuItemViews()
    }
    
    private func createMenuItemViews () {
        
        for menuItem in menuItems {
            
            let menuItemView = ScheduleSelectorMenuItemView()
            menuItemView.menuItem = menuItem
            
            menuItemViews.append(menuItemView)
        }
        
        createMenuItemDividers()
        
        addAllUI()
        updateAllUI()
    }
    
    
    private func createMenuItemDividers () {
        
        for _ in 0 ..< (menuItemViews.count - 1) {
            let divider = UIView()
            menuItemDividers.append(divider)
        }
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK: Schedule Selector Menu Item View
    public func scheduleSelectorMenuItemViewWasPressed(scheduleSelectorMenuItemView: ScheduleSelectorMenuItemView) {
        delegate?.scheduleSelectorMenuDidSelectMenuItemWithIdentifier(self, identifier: scheduleSelectorMenuItemView.menuItem.identifier)
    }

}


public protocol ScheduleSelectorMenuDelegate {
    func scheduleSelectorMenuDidSelectMenuItemWithIdentifier(scheduleSelectorMenu: ScheduleSelectorMenu, identifier: String)
}
