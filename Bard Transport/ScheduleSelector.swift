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
    case MenuEngorged
    case MenuOpen
    case HelpOpen
}

public class ScheduleSelector: JABView, ShuttleStopStackDelegate, ScheduleSelectorHelpScreenDelegate, JABTouchableViewDelegate, JABButtonDelegate, ScheduleSelectorMenuDelegate, ScheduleSheetDelegate {
    
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
    
    private let dimmer = UIView()
    private let shuttleStopStack = ShuttleStopStack()
    private let helpScreen = ScheduleSelectorHelpScreen()
    
    private let sidebarButton = JABButton()
    private let mapButton = JABButton()
    private let stackTransitionButton = JABButton()
    private let menuButton = JABButton()
    
    private let blurLayer = UIVisualEffectView()
    private let menu = ScheduleSelectorMenu()
    
    private let scheduleSheet = ScheduleSheet()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var topBufferForShuttleStopStack = CGFloat(0)
    private var bottomBufferForShuttleStopStack = CGFloat(0)
    private var widthOfShuttleStopStack = CGFloat(0)
    
    
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
    
    private var leftBufferForMenuButton = CGFloat(0)
    private var bottomBufferForMenuButton = CGFloat(0)
    private var widthOfMenuButton = CGFloat(0)
    private var heightOfMenuButton = CGFloat(0)
    private var horizontalContentInsetForMenuButton = CGFloat(0)
    private var verticalContentInsetForMenuButton = CGFloat(0)
    
    
    private var engorgedBufferForMenu = CGFloat(0)
    private var leftBufferForMenu = CGFloat(0)
    private var bufferBetweenMenuAndMenuButton = CGFloat(0)
    private var widthOfMenu = CGFloat(0)
    private var heightOfMenu = CGFloat(0)
    
    
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
        
        
        topBufferForShuttleStopStack = 0.18
        bottomBufferForShuttleStopStack = 0.1
        widthOfShuttleStopStack = 0.23
        widthOfShuttleStopStack = 0.35
        
        
        
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
        
        leftBufferForMenuButton = 0.03
        bottomBufferForMenuButton = 0.02
        widthOfMenuButton = 0.1
        heightOfMenuButton = widthOfMenuButton
        horizontalContentInsetForMenuButton = leftBufferForMenuButton
        verticalContentInsetForMenuButton = horizontalContentInsetForMenuButton
        
        
        engorgedBufferForMenu = 0.001
        leftBufferForMenu = leftBufferForMenuButton
        bufferBetweenMenuAndMenuButton = 0.005
        widthOfMenu = 0.6
        heightOfMenu = widthOfMenu * menu.heightToWidthRatio
        
        
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
        
        addDimmer()
        addShuttleStopStack()
        addHelpScreen()
        
        addSidebarButton()
        addMapButton()
        addStackTransitionButton()
        addMenuButton()
        
        addBlurLayer()
        addMenu()
        
        addScheduleSheet()
        
    }
    
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureBackgroundImageView()
        positionBackgroundImageView()
        
        configureOmniPanTouchCover()
        positionOmniPanTouchCover()
        
        
        
        
        configureDimmer()
        positionDimmer()
        
        configureShuttleStopStack()
        positionShuttleStopStack()
        
        configureHelpScreen()
        positionHelpScreen()
        
        
        
        configureSidebarButton()
        positionSidebarButton()
        
        configureMapButton()
        positionMapButton()
        
        configureStackTransitionButton()
        positionStackTransitionButton()
        
        configureMenuButton()
        positionMenuButton()
        
        
        
        configureBlurLayer()
        positionBlurLayer()
        
        configureMenu()
        positionMenu()
        
        
        
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
    
    
    
    
    private func addDimmer () {
        addSubview(dimmer)
    }
    
    private func addShuttleStopStack () {
        addSubview(shuttleStopStack)
    }
    
    private func addHelpScreen () {
        addSubview(helpScreen)
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
    
    private func addMenuButton () {
        addSubview(menuButton)
    }
    
    
    
    
    private func addBlurLayer () {
        addSubview(blurLayer)
    }
    
    private func addMenu () {
        addSubview(menu)
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
        
        if scheduleSheetOpen || state == .HelpOpen || state == .MenuOpen {
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
//        helpScreen.backgroundColor = blackColor
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
            
            newFrame.origin.x = menuButton.center.x - newFrame.size.width/2
            newFrame.origin.y = menuButton.center.y - newFrame.size.height/2
            
        }
        
        
        helpScreen.frame = newFrame
        
    }
    
    
    
    
    
    
    
    
    // MARK: Sidebar Button
    private func configureSidebarButton () {
        
        sidebarButton.buttonDelegate = self
        sidebarButton.type = JABButtonType.Image
        
        sidebarButton.horizontalContentInset = width * horizontalContentInsetForSidebarButton
        sidebarButton.verticalContentInset = width * verticalContentInsetForSidebarButton
        
        sidebarButton.image = UIImage(named: "Sidebar Button.png")
        
        if state == .HelpOpen || state == .MenuOpen || state == .SidebarOpen {
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
        
        if state == .HelpOpen || state == .MenuOpen || state == .SidebarOpen {
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
        
        
        if state == .HelpOpen || state == .MenuOpen || scheduleSheetOpen || shuttleStopStackIsAnimating {
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
    private func configureMenuButton () {
        
        menuButton.buttonDelegate = self
        menuButton.type = JABButtonType.Image
        
        menuButton.horizontalContentInset = width * horizontalContentInsetForMenuButton
        menuButton.verticalContentInset = width * verticalContentInsetForMenuButton
        
        menuButton.image = UIImage(named: "Menu Button.png")
        
        if state == .HelpOpen || state == .MenuOpen || scheduleSheetOpen {
            menuButton.userInteractionEnabled = false
        } else {
            menuButton.userInteractionEnabled = true
        }
        
        menuButton.updateAllUI()
    }
    
    private func positionMenuButton () {
        
        var newFrame = CGRectZero
        
        newFrame.width = (width * widthOfMenuButton) + (2 * width * horizontalContentInsetForMenuButton)
        newFrame.height = (width * heightOfMenuButton) + (2 * width * verticalContentInsetForMenuButton)
        
        newFrame.x = width * (leftBufferForMenuButton - horizontalContentInsetForMenuButton)
        newFrame.y = height - newFrame.size.height - (width * (bottomBufferForMenuButton - verticalContentInsetForMenuButton))
        
        menuButton.frame = newFrame
    }
    
    
    
    
    
    
    
    // MARK: Blur Layer
    private func configureBlurLayer () {
        
        
        if state == .MenuOpen || state == .MenuEngorged {
            blurLayer.effect = UIBlurEffect(style: .Light)
        } else {
            blurLayer.effect = nil
        }
        
        blurLayer.userInteractionEnabled = false
        
    }
    
    private func positionBlurLayer () {
        blurLayer.frame = bounds
    }
    
    
    
    
    // MARK: Menu
    private func configureMenu () {
        
        menu.delegate = self
        menu.cornerRadius = 10
        menu.clipsToBounds = true
        
        if state == .MenuOpen {
            menu.opacity = 1
            menu.open = true
        } else if state == .MenuEngorged {
            menu.opacity = 1
            menu.open = false
        } else {
            menu.opacity = 0
            menu.open = false
        }
        
    }
    
    private func positionMenu () {
        
        var newFrame = CGRectZero
        
        
        if state == .MenuOpen {
            newFrame.size.width = width * widthOfMenu
            newFrame.size.height = width * heightOfMenu
            
            newFrame.origin.x = width * leftBufferForMenu
            newFrame.origin.y = menuButton.y - newFrame.size.height - (width * bufferBetweenMenuAndMenuButton)
            
        } else if state == .MenuEngorged {
            
            newFrame.size.width = (width * widthOfMenuButton) + (2 * width * horizontalContentInsetForMenuButton) + (2 * width * engorgedBufferForMenu)
            newFrame.size.height = (width * heightOfMenuButton) + (2 * width * verticalContentInsetForMenuButton) + (2 * width * engorgedBufferForMenu)
            
            newFrame.origin.x = menuButton.x - (width * engorgedBufferForMenu)
            newFrame.origin.y = menuButton.y - (width * engorgedBufferForMenu)
            
        } else {
            
            newFrame.size.width = width * widthOfMenuButton
            newFrame.size.height = width * heightOfMenuButton
            
            newFrame.origin.x = menuButton.x + (width * horizontalContentInsetForMenuButton)
            newFrame.origin.y = menuButton.y + (width * verticalContentInsetForMenuButton)
            
        }
        
        
        menu.frame = newFrame
        
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
    
    
    
    public func openMenu () {
        openMenu { (Bool) -> () in }
    }
    
    public func openMenu (completion: (Bool) -> () ) {
        
        
        bringSubviewToFront(blurLayer)
        bringSubviewToFront(menu)
        bringSubviewToFront(menuButton)
        bringSubviewToFront(scheduleSheet)
        
        
        state = .MenuEngorged
        animatedUpdate(defaultAnimationDuration/2, options: .CurveLinear) { (Bool) in
            self.state = .MenuOpen
            self.animatedUpdate(defaultAnimationDuration/2, options: .CurveEaseOut, completion: completion)
        }
        
    }
    
    
    public func closeMenu () {
        closeMenu { (Bool) -> () in }
    }
    
    public func closeMenu (completion: (Bool) -> () ) {
        
        state = .MenuEngorged
        animatedUpdate(defaultAnimationDuration/2, options: .CurveLinear) { (Bool) in
            self.state = .Normal
            self.animatedUpdate(defaultAnimationDuration/2, options: .CurveEaseOut, completion: completion)
        }
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
    
    private func menuButtonPressed () {
        
        if state == .SidebarOpen {
            delegate?.scheduleSelectorMenuButtonWasPressed(self)
        } else {
            openMenu()
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
            if state != .HelpOpen && state != .MenuOpen && state != .MenuEngorged {
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
            
        } else if state == .MenuOpen {
            
            if methodCallNumber < 5 {
                
                closeMenu()
                
            }
            
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
                case menuButton:
                    menuButtonPressed()
                default:
                    print("Hit default when switching over button in ScheduleSelector.buttonWasTouched:")
                }
            }
        }
    }
    
    
    
    
    // MARK: Schedule Selector Menu
    public func scheduleSelectorMenuDidSelectMenuItemWithIdentifier(scheduleSelectorMenu: ScheduleSelectorMenu, identifier: String) {
        
        switch identifier {
        case "help":
            closeMenu({ (Bool) in
                self.openHelpScreen()
            })
        default:
            print("ScheduleSelectorMenu did select item with unknown identifier: \(identifier)")
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
    func scheduleSelectorMenuButtonWasPressed(scheduleSelector: ScheduleSelector)
    
}
