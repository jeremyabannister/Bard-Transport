//
//  SmartTimesInsufficientAccessPrivilegesErrorView.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 9/6/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class SmartTimesInsufficientAccessPrivilegesErrorView: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: SmartTimesInsufficientAccessPrivilegesErrorViewDelegate?
    
    // MARK: State
    
    // MARK: UI
    private let errorLabel = UILabel()
    private let touchCover = JABButton()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var sideBufferForText = CGFloat(0)
    
    
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
        
        sideBufferForText = 0.1
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addErrorLabel()
        addTouchCover()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureErrorLabel()
        positionErrorLabel()
        
        configureTouchCover()
        positionTouchCover()
        
    }
    
    
    // MARK: Adding
    private func addErrorLabel () {
        addSubview(errorLabel)
    }
    
    private func addTouchCover () {
        addSubview(touchCover)
    }
    
    
    
    
    // MARK: Error Label
    private func configureErrorLabel () {
        
        errorLabel.text = "You have not allowed this app to access your location. To start using SmartTimes and other advanced features, tap this message and enable Location Services."
        errorLabel.textAlignment = .Center
        errorLabel.textColor = blackColor
        errorLabel.font = UIFont(name: "Avenir", size: 14)
        
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .ByWordWrapping
    }
    
    private func positionErrorLabel () {
        
        if let text = errorLabel.text {
            
            var newFrame = CGRectZero
            let size = errorLabel.font.sizeOfString(text, constrainedToWidth: width * (1 - 2 * sideBufferForText))
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = (height - newFrame.size.height)/2
            
            errorLabel.frame = newFrame
        }
    }
    
    
    
    // MARK: Touch Cover
    private func configureTouchCover () {
        
        touchCover.buttonDelegate = self
        touchCover.type = JABButtonType.Image
        
        touchCover.dimsWhenPressed = true
        
    }
    
    private func positionTouchCover () {
        
        touchCover.frame = relativeFrame
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Buttons
    private func touchCoverPressed () {
        delegate?.smartTimesInsufficientAccessPrivilegesErrorViewWasPressed(self)
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
            case touchCover:
                touchCoverPressed()
            default:
                print("Hit default when switching over button in SmartTimesInsufficientAccessPrivilegesErrorView.buttonWasUntouched:")
            }
        }
    }
    
}


public protocol SmartTimesInsufficientAccessPrivilegesErrorViewDelegate {
    func smartTimesInsufficientAccessPrivilegesErrorViewWasPressed (smartTimesInsufficientAccessPrivilegesErrorView: SmartTimesInsufficientAccessPrivilegesErrorView)
}


