//
//  SidebarMenuHeader.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/23/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


public class SidebarMenuHeader: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: SidebarMenuHeaderDelegate?
    
    // MARK: State
    public var currentMenuItem: SidebarMenuItem?
    
    // MARK: UI
    private let backButton = JABButton()
    private let headerLabel = UILabel()
    private let bottomBorder = UIView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var leftBufferForBackButton = CGFloat(0)
    private var topBufferForBackButton = CGFloat(0)
    private var widthOfBackButton = CGFloat(0)
    private var heightOfBackButton = CGFloat(0)
    
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
        
        leftBufferForBackButton = 0.03
        topBufferForBackButton = 0
        widthOfBackButton = 0.2
        heightOfBackButton = 0.2
        
        heightOfBottomBorder = 1
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addBackButton()
        addHeaderLabel()
        addBottomBorder()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        
        configureBackButton()
        positionBackButton()
        
        configureHeaderLabel()
        positionHeaderLabel()
        
        configureBottomBorder()
        positionBottomBorder()
        
    }
    
    
    // MARK: Adding
    private func addBackButton () {
        addSubview(backButton)
    }
    
    private func addHeaderLabel () {
        addSubview(headerLabel)
    }
    
    private func addBottomBorder () {
        addSubview(bottomBorder)
    }
    
    
    
    
    // MARK: Back Button
    private func configureBackButton () {
        
        backButton.type = JABButtonType.Text
        backButton.buttonDelegate = self
        
        backButton.text = "Back"
        backButton.textAlignment = NSTextAlignment.Center
        backButton.textColor = blackColor
        backButton.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        
        backButton.dimsWhenPressed = true
        
        
        if currentMenuItem == nil {
            backButton.opacity = 0
        } else {
            backButton.opacity = 1
        }
        
        backButton.updateAllUI()
    }
    
    private func positionBackButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfBackButton
        newFrame.size.height = width * heightOfBackButton
        
        newFrame.origin.x = width * leftBufferForBackButton
        newFrame.origin.y = width * topBufferForBackButton
        
        backButton.frame = newFrame
    }
    
    
    // MARK: Header
    private func configureHeaderLabel () {
        
        if currentMenuItem == nil {
            headerLabel.text = "Main Menu"
        } else {
            headerLabel.text = currentMenuItem!.title
        }
        
        headerLabel.textColor = blackColor
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.font = UIFont(name: "Avenir", size: 16)
        
        headerLabel.numberOfLines = 0
        
    }
    
    private func positionHeaderLabel () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width - (2 * backButton.right)
        newFrame.size.height = height
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = (height - newFrame.size.height)/2
        
        headerLabel.frame = newFrame
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
    private func backButtonPressed () {
        delegate?.sidebarMenuHeaderBackButtonWasPressed(self)
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Button
    public func buttonWasTouched(button: JABButton) {
        
    }
    
    public func buttonWasUntouched(button: JABButton, triggered: Bool) {
        
        if triggered {
            switch button {
            case backButton:
                backButtonPressed()
            default:
                print("Default was hit when switching over button in SidebarMenuHeader.buttonWasUntouched:")
            }
        }
        
    }
    
}


public protocol SidebarMenuHeaderDelegate {
    func sidebarMenuHeaderBackButtonWasPressed (sidebarMenuHeader: SidebarMenuHeader)
}
