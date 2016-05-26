//
//  ScheduleSelectorMenuItemView.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 5/25/16.
//  Copyright © 2016 Jeremy Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSelectorMenuItemView: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSelectorMenuItemViewDelegate?
    
    // MARK: State
    public var menuItem = ScheduleSelectorMenuItem()
    public var open = false
    
    // MARK: UI
    private let button = JABButton()
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var leftBufferForImageView = CGFloat(0)
    private var topBufferForImageView = CGFloat(0)
    
    private var bufferBetweenImageViewAndTextLabel = CGFloat(0)
    
    
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
    
    required public init(coder aDecoder: NSCoder) {
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    // MARK: Parameters
    override public func updateParameters() {
        
        
        leftBufferForImageView = 0.05
        topBufferForImageView = 0.05
        
        bufferBetweenImageViewAndTextLabel = 0.05
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    // MARK: All
    override public func addAllUI() {
        
        addButton()
        
        addImageView()
        addTextLabel()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureButton()
        positionButton()
        
        
        
        configureImageView()
        positionImageView()
        
        configureTextLabel()
        positionTextLabel()
        
    }
    
    
    // MARK: Adding
    private func addButton () {
        addSubview(button)
    }
    
    
    
    private func addImageView () {
        addSubview(imageView)
    }
    
    private func addTextLabel () {
        addSubview(textLabel)
    }
    
    
    
    
    // MARK: Button
    private func configureButton () {
        
        button.buttonDelegate = self
        
    }
    
    private func positionButton () {
        button.frame = bounds
    }
    
    
    
    
    // MARK: Image View
    private func configureImageView () {
        
        imageView.image = menuItem.image
        
        if open {
            imageView.opacity = 1
        } else {
            imageView.opacity = 0
        }
        
    }
    
    private func positionImageView () {
        
        if let size = imageView.image?.size {
            if size.height != 0 {
                
                let widthToHeightRatio = size.width/size.height
                var newFrame = CGRectZero
                
                newFrame.size.height = height - (2 * width * topBufferForImageView)
                newFrame.size.width = newFrame.size.height * widthToHeightRatio
                
                    
                newFrame.origin.x = width * leftBufferForImageView
                newFrame.origin.y = width * topBufferForImageView
                
                
                imageView.frame = newFrame
            }
        }
    }
    
    
    
    // MARK: Text Label
    private func configureTextLabel () {
        
        textLabel.text = menuItem.text
        textLabel.textColor = blackColor
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        
        if open {
            textLabel.opacity = 1
        } else {
            textLabel.opacity = 0
        }
        
    }
    
    private func positionTextLabel () {
        
        if let text = textLabel.text {
            let size = textLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            var newFrame = CGRectZero
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = imageView.right + ((width - imageView.right) - newFrame.size.width)/2
            newFrame.origin.y = (height - newFrame.size.height)/2
            
            
            textLabel.frame = newFrame
        }
        
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Button
    public func buttonWasTouched(button: JABButton) {
        
        button.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
    }
    
    public func buttonWasUntouched(button: JABButton, triggered: Bool) {
        
        button.backgroundColor = clearColor
        
        if triggered {
            delegate?.scheduleSelectorMenuItemViewWasPressed(self)
        }
        
    }
    
    
}

public protocol ScheduleSelectorMenuItemViewDelegate {
    func scheduleSelectorMenuItemViewWasPressed(scheduleSelectorMenuItemView: ScheduleSelectorMenuItemView)
}