//
//  ScheduleSelectorHelpScreen.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/24/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSelectorHelpScreen: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSelectorHelpScreenDelegate?
    
    // MARK: State
    public var open = false
    private var textColor = UIColor(white: 0.2, alpha: 1)
    
    // MARK: UI
    private let blurredBackground = UIVisualEffectView()
    private let instructionLabel = UILabel()
    private let closeButton = JABButton()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var widthOfInstructionLabel = CGFloat(0)
    
    private var topBufferForCloseButton = CGFloat(0)
    private var rightBufferForCloseButton = CGFloat(0)
    private var widthOfCloseButton = CGFloat(0)
    private var heightOfCloseButton = CGFloat(0)
    
    
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
        
        
        widthOfInstructionLabel = 0.7
        
        topBufferForCloseButton = 0
        rightBufferForCloseButton = 0
        widthOfCloseButton = 0.2
        heightOfCloseButton = 0.2
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addBlurredBackground()
        addInstructionLabel()
        addCloseButton()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureBlurredBackground()
        positionBlurredBackground()
        
        configureInstructionLabel()
        positionInstructionLabel()
        
        configureCloseButton()
        positionCloseButton()
        
    }
    
    
    // MARK: Adding
    private func addBlurredBackground () {
        addSubview(blurredBackground)
    }
    
    private func addInstructionLabel () {
        addSubview(instructionLabel)
    }
    
    private func addCloseButton () {
        addSubview(closeButton)
    }
    
    
    
    
    
    // MARK: Blurred Background
    private func configureBlurredBackground () {
        
        blurredBackground.effect = UIBlurEffect(style: .Light)
        blurredBackground.cornerRadius = cornerRadius
        
    }
    
    private func positionBlurredBackground () {
        
        blurredBackground.frame = bounds
        
    }
    
    
    
    // MARK: Instruction Label
    private func configureInstructionLabel () {
        
        instructionLabel.text = "To view the shuttle schedule, drag your finger along your route and let go."
        instructionLabel.textAlignment = NSTextAlignment.Center
        instructionLabel.textColor = textColor
        instructionLabel.font = UIFont(name: "Avenir", size: 15)
        
        instructionLabel.numberOfLines = 0
        
        
        if open {
            instructionLabel.opacity = 1
        } else {
            instructionLabel.opacity = 0
        }
        
    }
    
    private func positionInstructionLabel () {
        
        if width != 0 {
            if let text = instructionLabel.text {
                var newFrame = CGRectZero
                let size = instructionLabel.font.sizeOfString(text, constrainedToWidth: width * widthOfInstructionLabel)
                
                newFrame.size.width = size.width
                newFrame.size.height = size.height
                
                newFrame.origin.x = (width - newFrame.size.width)/2
                newFrame.origin.y = (height - newFrame.size.height)/2
                
                instructionLabel.frame = newFrame
            }
        }
    }
    
    
    
    // MARK: Close Button
    private func configureCloseButton () {
        
        closeButton.type = JABButtonType.Text
        closeButton.buttonDelegate = self
        
        closeButton.text = "x"
        closeButton.textAlignment = NSTextAlignment.Center
        closeButton.textColor = textColor
        closeButton.font = UIFont(name: "Avenir", size: 26)
        
        closeButton.dimsWhenPressed = true
        
        closeButton.updateAllUI()
        
    }
    
    private func positionCloseButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfCloseButton
        newFrame.size.height = width * heightOfCloseButton
        
        newFrame.origin.x = width - newFrame.size.width - (width * rightBufferForCloseButton)
        newFrame.origin.y = width * topBufferForCloseButton
        
        closeButton.frame = newFrame
        
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Buttons
    private func closeButtonPressed () {
        delegate?.scheduleSelectorHelpScreenCloseButtonWasPressed(self)
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
            case closeButton:
                closeButtonPressed()
            default:
                print("Hit default when switching over button in ScheduleSelectorHelpScreen.buttonWasUntouched:")
            }
        }
        
    }
    
}


public protocol ScheduleSelectorHelpScreenDelegate {
    func scheduleSelectorHelpScreenCloseButtonWasPressed (scheduleSelectorHelpScreen: ScheduleSelectorHelpScreen)
}
