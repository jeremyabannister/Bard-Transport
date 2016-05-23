//
//  ApplicationRoot.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/20/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//


// NEW FEATURE DESCRIPTION:
//
// Add +/- button to lower right corner to switch between All Stops and Main Stops

import UIKit
import JABSwiftCore

private enum ApplicationRootNotificationState {
    case None
    case Update
}

public class ApplicationRoot: JABApplicationRoot, UpdateNotificationDelegate {
    
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: State
    private var versionNumber = JABVersionNumber(string: "3.0")
    private var latestVersionNumber: JABVersionNumber? {
        didSet {
            compareVersionNumbers()
        }
    }
    private var notificationState = ApplicationRootNotificationState.None
    private var versionCheckTimer: NSTimer? // The timer that triggers the version check
    private let versionCheckInterval: NSTimeInterval = 120 // Number of seconds user gets to use the app before update notification reappears
    
    private let laboratoryEnabled = false
    
    // MARK: UI
    private var mainSector = MainSector()
    private var notificationBackgroundBlur = UIVisualEffectView()
    private var updateNotification = UpdateNotification()
    
    private var laboratory = UIView() // The laboratory is a view which covers the entire app and is used as a test ground. Usually it is transparent and userInteractionEnabled is set to false, but when laboratoryEnabled is set to true at startup the laboratory takes the foreground and runExperiment() is called.
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public func breakApp () {
        
    }
    
    public override init () {
        super.init()
        
        //        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "breakApp", userInfo: nil, repeats: true)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ApplicationRoot.retrieveVersionNumberFromInternet), userInfo: nil, repeats: false) // This timer is here so that the user is immediately informed of the new version, after which the notification will reappear regularly
        
        versionCheckTimer = NSTimer.scheduledTimerWithTimeInterval(versionCheckInterval, target: self, selector: #selector(ApplicationRoot.retrieveVersionNumberFromInternet), userInfo: nil, repeats: true)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert,
            UIUserNotificationType.Badge], categories: nil
            ))
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        
        
        if laboratoryEnabled {
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ApplicationRoot.runExperiment), userInfo: nil, repeats: false)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
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
        
        addMainSector()
        addNotificationBackgroundBlur()
        addUpdateNotification()
        addLaboratory()
        
    }
    
    override public func updateAllUI() {
        
        configureMainSector()
        positionMainSector()
        
        configureNotificationBackgroundBlur()
        positionNotificationBackgroundBlur()
        
        configureUpdateNotification()
        positionUpdateNotification()
        
        
        
        configureLaboratory()
        positionLaboratory()
        
    }
    
    
    
    // MARK: Adding
    private func addMainSector () {
        addSubview(mainSector)
    }
    
    private func addNotificationBackgroundBlur () {
        addSubview(notificationBackgroundBlur)
    }
    
    private func addUpdateNotification () {
        notificationLayer.addSubview(updateNotification)
    }
    
    private func addLaboratory () {
        addSubview(laboratory)
    }
    
    
    // MARK: Main Sector
    private func configureMainSector () {
        
    }
    
    private func positionMainSector () {
        
        mainSector.frame = relativeFrame
        
    }
    
    
    
    // MARK: Notification Background Blur
    private func configureNotificationBackgroundBlur () {
        
        if notificationState == .None {
            notificationBackgroundBlur.effect = nil
        } else {
            notificationBackgroundBlur.effect = UIBlurEffect(style: .Light)
        }
        
        notificationBackgroundBlur.userInteractionEnabled = false
    }
    
    private func positionNotificationBackgroundBlur () {
        
        notificationBackgroundBlur.frame = bounds
        
    }
    
    
    // MARK: Update Notification
    private func configureUpdateNotification () {
        
        updateNotification.delegate = self
        updateNotification.backgroundColor = UIColor(white: 1, alpha: 1)
        updateNotification.cornerRadius = 10
        updateNotification.clipsToBounds = true
        
        updateNotification.shadowOpacity = 0.3
        updateNotification.shadowRadius = 2
        
        if notificationState == ApplicationRootNotificationState.Update {
            dimNotificationLayer()
            updateNotification.opacity = 1
        } else {
            undimNotificationLayer()
            updateNotification.opacity = 0
        }
        
    }
    
    private func positionUpdateNotification () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfNotifications
        newFrame.size.height = width * heightOfNotifications
        
        newFrame.origin.x = (notificationLayer.width - newFrame.size.width)/2
        newFrame.origin.y = (notificationLayer.height - newFrame.size.height)/2
        
        updateNotification.frame = newFrame
        
        
    }
    
    
    
    // MARK: Laboratory
    private func configureLaboratory () {
        if laboratoryEnabled {
            laboratory.backgroundColor = whiteColor
            laboratory.userInteractionEnabled = true
        } else {
            laboratory.backgroundColor = clearColor
            laboratory.userInteractionEnabled = false
        }
        
    }
    
    private func positionLaboratory () {
        if laboratoryEnabled {
            laboratory.frame = relativeFrame
        } else {
            laboratory.frame = CGRectZero
        }
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Version Number
    public func retrieveVersionNumberFromInternet () {
        
        let urlString = "https://twitter.com/BardAppVersion" // Define url to twitter page
        if let url = NSURL(string: urlString) { // Ensure that url is valid
            let request = NSURLRequest(URL: url) // Create request
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in // Send request
                
                // This is the reponse to the request
                if data != nil {
                    if var pageString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String { // Get page as html string and immediately cast it to String, so that we can use JABSwiftCore String extension methods
                        
                        if let range1 = pageString.rangeOfString("Current Version: ") { // Find the location of the string "Current Version: ", because immediately after this the version number will appear
                            
                            pageString = pageString.substringFromIndex(range1.endIndex) // Cut off all of page string until this string appears
                            if let range2 = pageString.rangeOfString("^**^") { // This set of symbols marks the end of the version number string, so find the location of that set of symbols
                                
                                pageString = pageString.substringToIndex(range2.startIndex) // Cut off everything after those symbols (this includes previous version numbers that are also sandwiched by these strings. This method gets the first instance of this string on the page which should be the latest one.)
                                if pageString.isValidVersionNumber() { // Make sure that the resulting string is a valid version number
                                    self.latestVersionNumber = JABVersionNumber(string: pageString) // Create a new JABVersionNumber out of this string and assign it to the stored property of ApplicationRoot called latestVersionNumber
                                }
                                
                            } else {
                                return
                            }
                        } else {
                            return
                        }
                    }
                } else {
                    return
                }
            })
        }
    }
    
    private func compareVersionNumbers () {
        
        // If the version number that is embeded in this app is lower than the version number posted to twitter then show update notification
        
        if latestVersionNumber != nil {
            if versionNumber < latestVersionNumber {
                versionCheckTimer?.invalidate()
                notificationState = ApplicationRootNotificationState.Update
                animatedUpdate()
            }
        }
    }
    
    
    
    // MARK: Experiment
    public func runExperiment () {
        
        let view1 = UIView()
        view1.red()
        print("width is \(width)")
        view1.frame = CGRect(x: laboratory.width/2 - 2.0, y: laboratory.height/2 - 2.0, width: 4, height: 4)
        
        let width2 = CGFloat(50.0)
        let height2 = CGFloat(100.0)
        
        let view2 = UIImageView()
        view2.blue()
        view2.image = UIImage(named: "botsteincolorheadbowtie100x100.png")
        view2.frame = CGRect(x: view1.center.x - width2/2, y: view1.center.y - height2/2, width: width2, height: height2)
        
        let view3 = UIImageView()
        view3.blue()
        view3.image = UIImage(named: "botsteincolorheadbowtie100x100.png")
        view3.frame = CGRect(x: view1.center.x - width2/2, y: view1.center.y - height2/2 + 200, width: width2, height: height2)
        
        
        
        
        
        laboratory.addSubview(view2)
        laboratory.addSubview(view3)
        
        
        laboratory.addSubview(view1)
        
        view2.transform = CGAffineTransformMakeRotation(CGFloat(pi)/4)
        
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Touchable View
    override public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    override public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
    }
    
    override public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        if !updateNotification.frame.contains ( gestureRecognizer.locationInView(notificationLayer) ) {
            versionCheckTimer = NSTimer.scheduledTimerWithTimeInterval(versionCheckInterval, target: self, selector: #selector(ApplicationRoot.retrieveVersionNumberFromInternet), userInfo: nil, repeats: true)
            notificationState = ApplicationRootNotificationState.None
            animatedUpdate()
        }
        
    }
    
    override public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
    }
    
    // MARK: Update Notification
    public func updateNotificationCloseButtonWasPressed(updateNotification: UpdateNotification) {
        
        
        
    }
    
    public func updateNotificationUpdateButtonWasPressed(updateNotification: UpdateNotification) {
        
        if let url = NSURL(string: "itms-apps://itunes.apple.com/app/id789572922") {
            UIApplication.sharedApplication().openURL(url)
        }
        
        versionCheckTimer = NSTimer.scheduledTimerWithTimeInterval(versionCheckInterval, target: self, selector: #selector(ApplicationRoot.retrieveVersionNumberFromInternet), userInfo: nil, repeats: true)
    }
    
}
