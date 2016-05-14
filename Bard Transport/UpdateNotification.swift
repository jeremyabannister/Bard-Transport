//
//  UpdateNotification.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/24/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class UpdateNotification: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: UpdateNotificationDelegate?
    
    // MARK: State
    
    // MARK: UI
    private let updateButton = JABButton()
    private let updateButtonBorder = UIView()
    private let notificationLabel = UILabel()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var heightOfUpdateButton = CGFloat(0)
    private var heightOfUpdateButtonBorder = CGFloat(0)
    
    private var widthOfNotificationLabel = CGFloat(0)
    
    
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
        
        heightOfUpdateButton = 0.3
        heightOfUpdateButtonBorder = 0.005
        
        widthOfNotificationLabel = 0.9
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addUpdateButton()
        addUpdateButtonBorder()
        addNotificationLabel()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureUpdateButton()
        positionUpdateButton()
        
        configureUpdateButtonBorder()
        positionUpdateButtonBorder()
        
        configureNotificationLabel()
        positionNotificationLabel()
        
    }
    
    
    // MARK: Adding
    private func addUpdateButton () {
        addSubview(updateButton)
    }
    
    private func addUpdateButtonBorder () {
        addSubview(updateButtonBorder)
    }
    
    private func addNotificationLabel () {
        addSubview(notificationLabel)
    }
    
    
    
    
    
    
    
    
    // MARK: Update Button
    private func configureUpdateButton () {
        
        updateButton.type = JABButtonType.Text
        updateButton.buttonDelegate = self
        updateButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
        
        updateButton.text = "U P D A T E"
        updateButton.textAlignment = NSTextAlignment.Center
        updateButton.textColor = UIColor(white: 0.92, alpha: 1)
        updateButton.font = UIFont(name: "AvenirNext-DemiBold", size: 27)
        
        updateButton.dimsWhenPressed = true
        updateButton.textButtonDimsBackground = true
        updateButton.userInteractionEnabled = true
        
        updateButton.updateAllUI()
    }
    
    private func positionUpdateButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = width * heightOfUpdateButton
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = height - newFrame.size.height
        
        updateButton.frame = newFrame
        
    }
    
    
    // MARK: Update Button Border
    private func configureUpdateButtonBorder () {
        
        updateButtonBorder.backgroundColor = updateButton.backgroundColor?.dim(0.7)
        
    }
    
    private func positionUpdateButtonBorder () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = updateButton.width
        newFrame.size.height = width * heightOfUpdateButtonBorder
        
        newFrame.origin.x = updateButton.x + (updateButton.width - newFrame.size.width)/2
        newFrame.origin.y = updateButton.y - newFrame.size.height
        
        updateButtonBorder.frame = newFrame
        
    }
    
    
    
    // MARK: Notification Label
    private func configureNotificationLabel () {
        
        notificationLabel.text = "An update is available for this app! To update your app for free, tap the button below."
        notificationLabel.textAlignment = NSTextAlignment.Center
        notificationLabel.textColor = blackColor
        notificationLabel.font = UIFont(name: "Avenir", size: 16)
        
        notificationLabel.numberOfLines = 0
        
    }
    
    private func positionNotificationLabel () {
        
        if let text = notificationLabel.text {
            var newFrame = CGRectZero
            let size = notificationLabel.font.sizeOfString(text, constrainedToWidth: width * widthOfNotificationLabel)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = (updateButton.y - newFrame.size.height)/2 - 2
            
            notificationLabel.frame = newFrame
        }
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Buttons
    private func updateButtonPressed () {
        delegate?.updateNotificationUpdateButtonWasPressed(self)
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
            case updateButton:
                updateButtonPressed()
            default:
                print("Hit default when switching over button in UpdateNotification.buttonWasTouched:")
            }
        }
        
    }
    
}


public protocol UpdateNotificationDelegate {
    func updateNotificationUpdateButtonWasPressed (updateNotification: UpdateNotification)
}
