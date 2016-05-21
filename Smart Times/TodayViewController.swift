//
//  TodayViewController.swift
//  Smart Times
//
//  Created by Jeremy Bannister on 5/19/16.
//  Copyright © 2016 Jeremy Bannister. All rights reserved.
//

import UIKit
import NotificationCenter
//import JABSwiftCore

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        // Smart Times
        let smartTimes = SmartTimes()
        
        smartTimes.cornerRadius = 10
//        smartTimes.backgroundColor = UIColor(white: 1, alpha: 0.5)
        smartTimes.todayWidget = true
        
        let widthOfSmartTimes = CGFloat(0.9)
        let topBufferForSmartTimes = CGFloat(0.05)
        
        var newFrame = CGRectZero
        
        newFrame.size.width = view.width * widthOfSmartTimes
        newFrame.size.height = newFrame.size.width * smartTimes.heightToWidthRatio
        
        newFrame.origin.x = (view.width - newFrame.size.width)/2
        newFrame.origin.y = view.width * topBufferForSmartTimes
        
        smartTimes.frame = newFrame
        
        
        // Blurred Background
        let blurredBackground = UIVisualEffectView()
        
        blurredBackground.effect = UIBlurEffect(style: .ExtraLight)
        blurredBackground.frame = smartTimes.frame
        blurredBackground.cornerRadius = smartTimes.cornerRadius
        blurredBackground.clipsToBounds = true
        
        view.addSubview(blurredBackground)
        view.addSubview(smartTimes)
        
        
        
        
        // Shade
        let shade = UIView()
        shade.backgroundColor = UIColor.blackColor()
        shade.opacity = 0.05
        shade.frame = smartTimes.frame
        shade.cornerRadius = smartTimes.cornerRadius
//        view.addSubview(shade)
        
        
        
        self.preferredContentSize = CGSize(width: 0, height: (2 * view.width * topBufferForSmartTimes) + smartTimes.height)
        
        
        let test = UILabel()
        test.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        test.backgroundColor = UIColor.whiteColor()
        test.text = "corner radius is \(blurredBackground.cornerRadius) and then \(smartTimes.cornerRadius)"
        
//        view.addSubview(test)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
