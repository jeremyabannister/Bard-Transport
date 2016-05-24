//
//  ScheduleSelectorButtonsLayer.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 5/23/16.
//  Copyright © 2016 Jeremy Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore


public enum ScheduleSelectorButtonsLayerState {
    case Normal
    case MenuOpen
    case HelpOpen
}

public enum ScheduleSelectorButtonsLayerStackTransitionButtonState {
    case Plus
    case Minus
}


public class ScheduleSelectorButtonsLayer: JABView, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSelectorButtonsLayerDelegate?
    
    // MARK: State
    public var state = ScheduleSelectorButtonsLayerState.Normal
    public var stackTransitionButtonState = ScheduleSelectorButtonsLayerStackTransitionButtonState.Plus
    
    public var sidebarButtonDisabled = false
    public var mapButtonDisabled = false
    public var stackTransitionButtonDisabled = false
    public var helpButtonDisabled = false
    
    // MARK: UI
    
    private let sidebarButton = JABButton()
    private let mapButton = JABButton()
    private let stackTransitionButton = JABButton()
    private let helpButton = JABButton()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var leftBufferForSidebarButton = CGFloat(0)
    private var topBufferForSidebarButton = CGFloat(0)
    private var widthOfSidebarButton = CGFloat(0)
    private var heightOfSidebarButton = CGFloat(0)
    private var horizontalContentInsetForSidebarButton = CGFloat(0)
    private var verticalContentInsetForSidebarButton = CGFloat(0)
    
    private var rightBufferForMapButton = CGFloat(0)
    private var topBufferForMapButton = CGFloat(0)
    private var widthOfMapButton = CGFloat(0)
    private var heightOfMapButton = CGFloat(0)
    private var horizontalContentInsetForMapButton = CGFloat(0)
    private var verticalContentInsetForMapButton = CGFloat(0)
    
    private var rightBufferForStackTransitionButton = CGFloat(0)
    private var bottomBufferForStackTransitionButton = CGFloat(0)
    private var widthOfStackTransitionButton = CGFloat(0)
    private var heightOfStackTransitionButton = CGFloat(0)
    private var horizontalContentInsetForStackTransitionButton = CGFloat(0)
    private var verticalContentInsetForStackTransitionButton = CGFloat(0)
    
    private var leftBufferForHelpButton = CGFloat(0)
    private var bottomBufferForHelpButton = CGFloat(0)
    private var widthOfHelpButton = CGFloat(0)
    private var heightOfHelpButton = CGFloat(0)
    private var horizontalContentInsetForHelpButton = CGFloat(0)
    private var verticalContentInsetForHelpButton = CGFloat(0)
    
    
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
        
        
        leftBufferForSidebarButton = 0.04
        topBufferForSidebarButton = 0.1
        widthOfSidebarButton = 0.075
        heightOfSidebarButton = widthOfSidebarButton * 0.8
        horizontalContentInsetForSidebarButton = 0.05
        verticalContentInsetForSidebarButton = horizontalContentInsetForSidebarButton
        
        rightBufferForMapButton = 0.04
        topBufferForMapButton = 0.1
        widthOfMapButton = 0.08
        heightOfMapButton = widthOfMapButton
        horizontalContentInsetForMapButton = 0.05
        verticalContentInsetForMapButton = horizontalContentInsetForMapButton
        
        rightBufferForStackTransitionButton = 0.03
        bottomBufferForStackTransitionButton = 0.03
        widthOfStackTransitionButton = 0.1
        heightOfStackTransitionButton = widthOfStackTransitionButton
        horizontalContentInsetForStackTransitionButton = 0.05
        verticalContentInsetForStackTransitionButton = horizontalContentInsetForStackTransitionButton
        
        leftBufferForHelpButton = 0.03
        bottomBufferForHelpButton = 0.03
        widthOfHelpButton = 0.1
        heightOfHelpButton = widthOfHelpButton
        horizontalContentInsetForHelpButton = 0.05
        verticalContentInsetForHelpButton = horizontalContentInsetForHelpButton
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addSidebarButton()
        addMapButton()
        addStackTransitionButton()
        addHelpButton()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureSidebarButton()
        positionSidebarButton()
        
        configureMapButton()
        positionMapButton()
        
        configureStackTransitionButton()
        positionStackTransitionButton()
        
        configureHelpButton()
        positionHelpButton()
        
        
    }
    
    
    // MARK: Adding
    
    private func addSidebarButton () {
        addSubview(sidebarButton)
    }
    
    private func addMapButton () {
        addSubview(mapButton)
    }
    
    private func addStackTransitionButton () {
        addSubview(stackTransitionButton)
    }
    
    private func addHelpButton () {
        addSubview(helpButton)
    }
    
    
    
    // MARK: Sidebar Button
    private func configureSidebarButton () {
        
        sidebarButton.buttonDelegate = self
        sidebarButton.type = JABButtonType.Image
        
        sidebarButton.horizontalContentInset = width * horizontalContentInsetForSidebarButton
        sidebarButton.verticalContentInset = width * verticalContentInsetForSidebarButton
        
        sidebarButton.image = UIImage(named: "Sidebar Button.png")
        
        if sidebarButtonDisabled || state == .HelpOpen {
            sidebarButton.userInteractionEnabled = false
        } else {
            sidebarButton.userInteractionEnabled = true
        }
        
        sidebarButton.updateAllUI()
    }
    
    private func positionSidebarButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = (width * widthOfSidebarButton) + (2 * width * horizontalContentInsetForSidebarButton)
        newFrame.size.height = (width * heightOfSidebarButton) + (2 * width * verticalContentInsetForSidebarButton)
        
        newFrame.origin.x = width * (leftBufferForSidebarButton - horizontalContentInsetForSidebarButton)
        newFrame.origin.y = width * (topBufferForSidebarButton - verticalContentInsetForSidebarButton)
        
        sidebarButton.frame = newFrame
    }
    
    
    // MARK: Map Button
    private func configureMapButton () {
        
        mapButton.buttonDelegate = self
        mapButton.type = JABButtonType.Image
        
        mapButton.horizontalContentInset = width * horizontalContentInsetForMapButton
        mapButton.verticalContentInset = width * verticalContentInsetForMapButton
        
        mapButton.image = UIImage(named: "Map Button 2D.png")
        
        if mapButtonDisabled || state == .HelpOpen {
            mapButton.userInteractionEnabled = false
        } else {
            mapButton.userInteractionEnabled = true
        }
        
        mapButton.updateAllUI()
        
    }
    
    private func positionMapButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = (width * widthOfMapButton) + (2 * width * horizontalContentInsetForMapButton)
        newFrame.size.height = (width * heightOfMapButton) + (2 * width * verticalContentInsetForMapButton)
        
        newFrame.origin.x = width - newFrame.size.width + (width * horizontalContentInsetForMapButton) - (width * rightBufferForMapButton)
        newFrame.origin.y = width * (topBufferForMapButton - verticalContentInsetForMapButton)
        
        mapButton.frame = newFrame
        
    }
    
    
    // MARK: Stack Transform Button
    private func configureStackTransitionButton () {
        
        stackTransitionButton.buttonDelegate = self
        stackTransitionButton.type = JABButtonType.Image
        
        stackTransitionButton.horizontalContentInset = width * horizontalContentInsetForStackTransitionButton
        stackTransitionButton.verticalContentInset = width * verticalContentInsetForStackTransitionButton
        
        if stackTransitionButtonState == .Plus {
            stackTransitionButton.image = UIImage(named: "Plus Button.png")
        } else {
            stackTransitionButton.image = UIImage(named: "Minus Button.png")
        }
        
        
        if stackTransitionButtonDisabled || state == .HelpOpen {
            stackTransitionButton.userInteractionEnabled = false
        } else {
            stackTransitionButton.userInteractionEnabled = true
        }
        
        stackTransitionButton.updateAllUI()
        
    }
    
    private func positionStackTransitionButton () {
        
        var newFrame = CGRectZero
        
        newFrame.width = (width * widthOfStackTransitionButton) + (2 * width * horizontalContentInsetForStackTransitionButton)
        newFrame.height = (width * heightOfStackTransitionButton) + (2 * width * verticalContentInsetForStackTransitionButton)
        
        newFrame.x = width - (width * widthOfStackTransitionButton) - (width * (rightBufferForStackTransitionButton + horizontalContentInsetForStackTransitionButton))
        newFrame.y = height - newFrame.size.height - (width * (bottomBufferForStackTransitionButton - verticalContentInsetForStackTransitionButton))
        
        stackTransitionButton.frame = newFrame
        
    }
    
    
    // MARK: Help Button
    private func configureHelpButton () {
        
        helpButton.buttonDelegate = self
        helpButton.type = JABButtonType.Image
        
        helpButton.horizontalContentInset = width * horizontalContentInsetForHelpButton
        helpButton.verticalContentInset = width * verticalContentInsetForHelpButton
        
        helpButton.image = UIImage(named: "Help Button.png")
        
        if helpButtonDisabled || state == .HelpOpen {
            helpButton.userInteractionEnabled = false
        } else {
            helpButton.userInteractionEnabled = true
        }
        
        helpButton.updateAllUI()
    }
    
    private func positionHelpButton () {
        
        var newFrame = CGRectZero
        
        newFrame.width = (width * widthOfHelpButton) + (2 * width * horizontalContentInsetForHelpButton)
        newFrame.height = (width * heightOfHelpButton) + (2 * width * verticalContentInsetForHelpButton)
        
        newFrame.x = width * (leftBufferForHelpButton - horizontalContentInsetForHelpButton)
        newFrame.y = height - newFrame.size.height - (width * (bottomBufferForHelpButton - verticalContentInsetForHelpButton))
        
        helpButton.frame = newFrame
    }
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK: Buttons
    private func sidebarButtonPressed () {
        delegate?.scheduleSelectorButtonsLayerSidebarButtonWasPressed(self)
    }
    
    private func mapButtonPressed () {
        delegate?.scheduleSelectorButtonsLayerMapButtonWasPressed(self)
    }
    
    private func stackTransitionButtonPressed () {
        /*
        shuttleStopStackIsAnimating = true
        updateAllUI()
        shuttleStopStack.transition { (Bool) -> () in
            self.shuttleStopStackIsAnimating = false
            self.updateAllUI()
        }
 */
    }
    
    private func helpButtonPressed () {
        /*
        if state == .SidebarOpen {
            delegate?.scheduleSelectorHelpButtonWasPressed(self)
        } else {
            openHelpScreen()
        }
 */
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
            case sidebarButton:
                sidebarButtonPressed()
            case mapButton:
                mapButtonPressed()
            case stackTransitionButton:
                stackTransitionButtonPressed()
            case helpButton:
                helpButtonPressed()
            default:
                print("Hit default when switching over button in ScheduleSelector.buttonWasTouched:")
            }
        }
    }
    
}


public protocol ScheduleSelectorButtonsLayerDelegate: class {
    func scheduleSelectorButtonsLayerSidebarButtonWasPressed (scheduleSelectorButtonsLayer: ScheduleSelectorButtonsLayer)
    func scheduleSelectorButtonsLayerMapButtonWasPressed (scheduleSelectorButtonsLayer: ScheduleSelectorButtonsLayer)
    func scheduleSelectorButtonsLayerStackTransitionButtonWasPressed (scheduleSelectorButtonsLayer: ScheduleSelectorButtonsLayer)
}
