//
//  ScheduleSelector.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/20/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public enum ScheduleSelectorState {
    case Normal
    case SidebarOpen
    case HelpOpen
}

public class ScheduleSelector: JABView, ShuttleStopStackDelegate, ScheduleSelectorHelpScreenDelegate, JABTouchableViewDelegate, JABButtonDelegate, ScheduleSheetDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ScheduleSelectorDelegate?
    
    // MARK: State
    public var state = ScheduleSelectorState.Normal
    private var scheduleSheetOpen = false
    private var panGestureInitiated = false
    private var shuttleStopStackIsAnimating = false // This is used to disable the transition button during a transition
    private var buttonsDisabled = false
    
    // MARK: UI
    private let backgroundImageView = UIImageView()
    private let omniPanTouchCover = JABTouchableView()
    
    private let sidebarButton = JABButton()
    private let mapButton = JABButton()
    private let stackTransitionButton = JABButton()
    private let helpButton = JABButton()
    
    
    private let dimmer = UIView()
    private let shuttleStopStack = ShuttleStopStack()
    private let helpScreen = ScheduleSelectorHelpScreen()
    
    private let scheduleSheet = ScheduleSheet()
    
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
    
    
    private var topBufferForShuttleStopStack = CGFloat(0)
    private var bottomBufferForShuttleStopStack = CGFloat(0)
    private var widthOfShuttleStopStack = CGFloat(0)
    
    private var topBufferForScheduleSheet = CGFloat(0)
    private var widthOfScheduleSheet = CGFloat(0)
    
    
    
    
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
        
        
        
        topBufferForShuttleStopStack = 0.18
        bottomBufferForShuttleStopStack = 0.1
        widthOfShuttleStopStack = 0.23
        widthOfShuttleStopStack = 0.35
        
        topBufferForScheduleSheet = 0.42
        widthOfScheduleSheet = 0.95
        
        if iPad {
            
        }
        
    }
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addBackgroundImageView()
        addOmniPanTouchCover()
        
        addSidebarButton()
        addMapButton()
        addStackTransitionButton()
        addHelpButton()
        
        addDimmer()
        addShuttleStopStack()
        addHelpScreen()
        
        addScheduleSheet()
        
    }
    
    
    public func addBlur () {
        
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 100, y: 100, width: 200, height: 300)
        addSubview(blurredEffectView)
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureBackgroundImageView()
        positionBackgroundImageView()
        
        configureOmniPanTouchCover()
        positionOmniPanTouchCover()
        
        
        
        configureSidebarButton()
        positionSidebarButton()
        
        configureMapButton()
        positionMapButton()
        
        configureStackTransitionButton()
        positionStackTransitionButton()
        
        configureHelpButton()
        positionHelpButton()
        
        
        
        
        configureDimmer()
        positionDimmer()
        
        configureShuttleStopStack()
        positionShuttleStopStack()
        
        configureHelpScreen()
        positionHelpScreen()
        
        
        
        configureScheduleSheet()
        positionScheduleSheet()
    }
    
    
    
    // MARK: Adding
    private func addBackgroundImageView () {
        addSubview(backgroundImageView)
    }
    
    private func addOmniPanTouchCover () {
        addSubview(omniPanTouchCover)
    }
    
    
    
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
    
    
    
    
    private func addDimmer () {
        addSubview(dimmer)
    }
    
    private func addShuttleStopStack () {
        addSubview(shuttleStopStack)
    }
    
    private func addHelpScreen () {
        addSubview(helpScreen)
    }
    
    
    
    
    private func addScheduleSheet () {
        addSubview(scheduleSheet)
    }
    
    
    
    // MARK: Background Image View
    private func configureBackgroundImageView () {
        backgroundImageView.image = UIImage(named: "Main Background-4 Inch.JPG")
    }
    
    private func positionBackgroundImageView () {
        
        backgroundImageView.frame = self.relativeFrame
    }
    
    // MARK: Omni-Pan Touch Cover
    private func configureOmniPanTouchCover () {
        omniPanTouchCover.delegate = self
    }
    
    private func positionOmniPanTouchCover () {
        omniPanTouchCover.frame = relativeFrame
    }
    
    
    
    
    
    
    // MARK: Sidebar Button
    private func configureSidebarButton () {
        
        sidebarButton.buttonDelegate = self
        sidebarButton.type = JABButtonType.Image
        
        sidebarButton.horizontalContentInset = width * horizontalContentInsetForSidebarButton
        sidebarButton.verticalContentInset = width * verticalContentInsetForSidebarButton
        
        sidebarButton.image = UIImage(named: "Sidebar Button.png")
        
        if state == .HelpOpen || state == .SidebarOpen {
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
        
        if state == .HelpOpen || state == .SidebarOpen {
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
        
        if shuttleStopStack.mode == ShuttleStopStackMode.MainStops {
            stackTransitionButton.image = UIImage(named: "Plus Button.png")
        } else {
            stackTransitionButton.image = UIImage(named: "Minus Button.png")
        }
        
        
        if state == .HelpOpen || scheduleSheetOpen || shuttleStopStackIsAnimating {
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
        
        if state == .HelpOpen || scheduleSheetOpen {
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
    
    
    
    
    
    
    
    // MARK: Dimmer
    private func configureDimmer () {
        
        dimmer.backgroundColor = blackColor
        dimmer.userInteractionEnabled = false
        
        let dimmedOpacity: Float = 0.6
        
        if scheduleSheetOpen {
            dimmer.opacity = dimmedOpacity
        } else if state == .HelpOpen {
            dimmer.opacity = dimmedOpacity
        } else {
            dimmer.opacity = 0
        }
        
        
    }
    
    private func positionDimmer () {
        
        dimmer.frame = relativeFrame
        
    }
    
    
    
    // MARK: Shuttle Stop Stack
    private func configureShuttleStopStack () {
        
        shuttleStopStack.delegate = self
        
        if scheduleSheetOpen || state == .HelpOpen {
            shuttleStopStack.userInteractionEnabled = false
        } else {
            shuttleStopStack.userInteractionEnabled = true
        }
        
    }
    
    private func positionShuttleStopStack () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfShuttleStopStack
        newFrame.size.height = height - (width * (topBufferForShuttleStopStack + bottomBufferForShuttleStopStack))
        
        newFrame.x = (width - newFrame.size.width)/2
        newFrame.y = width * topBufferForShuttleStopStack
        
        shuttleStopStack.frame = newFrame
        
    }
    
    
    // MARK: Help Screen
    private func configureHelpScreen () {
        
        helpScreen.delegate = self
        helpScreen.backgroundColor = blackColor
        helpScreen.cornerRadius = 10
        helpScreen.clipsToBounds = true
        
        if state == .HelpOpen {
            helpScreen.opacity = 1
        } else {
            helpScreen.opacity = 0
        }
        
    }
    
    private func positionHelpScreen () {
        
        var newFrame = CGRectZero
        
        if state == .HelpOpen {
            
            newFrame.size.width = width * widthOfNotifications
            newFrame.size.height = width * heightOfNotifications
            
            newFrame.origin.x = (width - newFrame.size.width)/2
            newFrame.origin.y = shuttleStopStack.y + (shuttleStopStack.height - newFrame.size.height)/2
            
        } else {
            
            newFrame.size.width = 0
            newFrame.size.height = 0
            
            newFrame.origin.x = helpButton.center.x - newFrame.size.width/2
            newFrame.origin.y = helpButton.center.y - newFrame.size.height/2
            
        }
        
        
        helpScreen.frame = newFrame
        
    }
    
    
    
    
    
    
    
    
    
    // MARK: Schedule Sheet
    private func configureScheduleSheet () {
        
        scheduleSheet.delegate = self
        scheduleSheet.backgroundColor = whiteColor
        scheduleSheet.visibleHeight = height - (width * topBufferForScheduleSheet)
        
        if state == .SidebarOpen {
            scheduleSheet.userInteractionEnabled = false
        } else {
            scheduleSheet.userInteractionEnabled = true
        }
        
        scheduleSheet.updateAllUI()
    }
    
    private func positionScheduleSheet () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfScheduleSheet
        newFrame.size.height = height - (width * topBufferForScheduleSheet) + 300
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        
        if scheduleSheetOpen {
            newFrame.origin.y = width * topBufferForScheduleSheet
        } else {
            newFrame.origin.y = height
        }
        
        
        scheduleSheet.frame = newFrame
        
    }
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Navigation
    private func closeScheduleSheet () {
        closeScheduleSheet { (Bool) -> () in }
    }
    
    private func closeScheduleSheet (completion: (Bool) -> () ) {
        
        scheduleSheetOpen = false
        shuttleStopStack.animateDeselection()
        animatedUpdate(defaultAnimationDuration, options: .CurveEaseInOut, completion: completion)
    }
    
    
    private func closeHelpScreen () {
        closeHelpScreen { (Bool) -> () in }
    }
    
    private func closeHelpScreen (completion: (Bool) -> () ) {
        
        helpScreen.open = false
        helpScreen.animatedUpdate(0.05, completion: { (Bool) -> () in
            self.state = .Normal
            self.animatedUpdate(defaultAnimationDuration, completion: completion)
        })
    }
    
    
    public func openHelpScreen () {
        openHelpScreen { (Bool) -> () in }
    }
    
    public func openHelpScreen (completion: (Bool) -> () ) {
        
        state = .HelpOpen
        animatedUpdate(defaultAnimationDuration) { (Bool) -> () in
            self.helpScreen.open = true
            self.helpScreen.animatedUpdate(0.05, completion: completion)
        }
    }
    
    
    
    private func panScheduleSheet (yDistance: CGFloat) {
        scheduleSheet.y += yDistance
        if scheduleSheet.y < 0 {
            scheduleSheet.y = 0
        }
    }
    
    private func releaseScheduleSheet (yVelocity: CGFloat, methodCallNumber: Int, panGestureInitiated: Bool) {
        if methodCallNumber < 5 {
            if state != .SidebarOpen {
                if !panGestureInitiated {
                    closeScheduleSheet()
                }
            }
        } else {
            if scheduleSheet.y > (width * topBufferForScheduleSheet) + 90 {
                closeScheduleSheet()
            } else {
                animatedUpdate()
            }
        }
    }
    
    
    // MARK: Buttons
    private func sidebarButtonPressed () {
        delegate?.scheduleSelectorSidebarButtonWasPressed(self)
    }
    
    private func mapButtonPressed () {
        delegate?.scheduleSelectorMapButtonWasPressed(self)
    }
    
    private func stackTransitionButtonPressed () {
        
        shuttleStopStackIsAnimating = true
        updateAllUI()
        shuttleStopStack.transition { (Bool) -> () in
            self.shuttleStopStackIsAnimating = false
            self.updateAllUI()
        }
    }
    
    private func helpButtonPressed () {
        
        if state == .SidebarOpen {
            delegate?.scheduleSelectorHelpButtonWasPressed(self)
        } else {
            openHelpScreen()
        }
    }
    
    
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Shuttle Stop Stack
    public func shuttleStopStackSelectionInProgress() {
        
        buttonsDisabled = true
        
    }
    
    public func shuttleStopStackSelectionNoLongerInProgress() {
        
        buttonsDisabled = false
        
    }
    
    public func shuttleStopStack(shuttleStopStack: ShuttleStopStack, didSelectOrigin origin: ShuttleStop, destination: ShuttleStop) {
        
        scheduleSheet.loadWithOrigin(origin, destination: destination)
        
        scheduleSheetOpen = true
        animatedUpdate()
    }
    
    // MARK: Help Screen
    public func scheduleSelectorHelpScreenCloseButtonWasPressed(scheduleSelectorHelpScreen: ScheduleSelectorHelpScreen) {
        closeHelpScreen()
    }
    
    // MARK: Touchable View
    public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
        let location = gestureRecognizer.locationInView(self)
        
        if scheduleSheetOpen {
            if location.x < scheduleSheet.left || location.x > scheduleSheet.right || state == .SidebarOpen {
                panGestureInitiated = true
            }
        } else {
            if state != .HelpOpen {
                panGestureInitiated = true
            }
        }
        
    }
    
    public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        if panGestureInitiated {
            delegate?.scheduleSelectorWasDragged(self, distance: xDistance, velocity: xVelocity, methodCallNumber: methodCallNumber)
        } else {
            if scheduleSheetOpen {
                panScheduleSheet(yDistance)
            }
        }
        
    }
    
    public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        if scheduleSheetOpen {
            
            releaseScheduleSheet(yVelocity, methodCallNumber: methodCallNumber, panGestureInitiated: panGestureInitiated)
            
        } else if state == .HelpOpen {
            
            if methodCallNumber < 5 {
                
                closeHelpScreen()
                
            }
            
        } else {
            if methodCallNumber < 5 {
                shuttleStopStack.animateDeselection()
            }
            
        }
        
        if panGestureInitiated {
            delegate?.scheduleSelectorWasReleased(self, velocity: xVelocity, methodCallNumber: methodCallNumber)
        }
        
        panGestureInitiated = false
        
    }
    
    public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.scheduleSelectorWasReleased(self, velocity: xVelocity, methodCallNumber: methodCallNumber)
        panGestureInitiated = false
        
    }
    
    
    // MARK: Button
    public func buttonWasTouched(button: JABButton) {
        
    }
    
    public func buttonWasUntouched(button: JABButton, triggered: Bool) {
        
        if !buttonsDisabled {
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
    
    
    
    // MARK: Schedule Sheet
    public func scheduleSheetWasDragged(scheduleSheet: ScheduleSheet, yDistance: CGFloat) {
        panScheduleSheet(yDistance)
    }
    
    public func scheduleSheetWasReleased(scheduleSheet: ScheduleSheet, yVelocity: CGFloat, methodCallNumber: Int) {
        releaseScheduleSheet(yVelocity, methodCallNumber: 1000, panGestureInitiated: false) // Put a large arbitrary method call number because we do not want the behavior that tapping the schedule sheet header makes the schedule sheet close
    }
    
    
}




public protocol ScheduleSelectorDelegate {
    
    func scheduleSelectorWasDragged(scheduleSelector: ScheduleSelector, distance: CGFloat, velocity: CGFloat, methodCallNumber: Int)
    func scheduleSelectorWasReleased(scheduleSelector: ScheduleSelector, velocity: CGFloat, methodCallNumber: Int)
    
    func scheduleSelectorSidebarButtonWasPressed(scheduleSelector: ScheduleSelector)
    func scheduleSelectorMapButtonWasPressed(scheduleSelector: ScheduleSelector)
    func scheduleSelectorHelpButtonWasPressed(scheduleSelector: ScheduleSelector)
    
}
