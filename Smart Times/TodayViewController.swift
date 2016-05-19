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
        smartTimes.backgroundColor = UIColor.whiteColor()
        
        let widthOfSmartTimes = CGFloat(0.9)
        let topBufferForSmartTimes = CGFloat(0.05)
        
        var newFrame = CGRectZero
        
        newFrame.size.width = view.width * widthOfSmartTimes
        newFrame.size.height = newFrame.size.width * smartTimes.heightToWidthRatio
        
        newFrame.origin.x = (view.width - newFrame.size.width)/2
        newFrame.origin.y = view.width * topBufferForSmartTimes
        
        smartTimes.frame = newFrame
        
        view.addSubview(smartTimes)
        
        smartTimes.cornerRadius = 10
        
        
        
        // Shade
        let shade = UIView()
        shade.backgroundColor = UIColor.blackColor()
        shade.opacity = 0.05
        shade.frame = smartTimes.frame
        shade.cornerRadius = smartTimes.cornerRadius
        view.addSubview(shade)
        
        
        
        self.preferredContentSize = CGSize(width: 0, height: (2 * view.width * topBufferForSmartTimes) + smartTimes.height)
        
        
        let test = UILabel()
        test.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        //        view.addSubview(test)
        test.backgroundColor = UIColor.whiteColor()
        test.text = "width is \(view.width) and then \(newFrame.origin.x)"
        
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
