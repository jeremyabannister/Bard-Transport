//
//  SidebarMenu.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/22/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class SidebarMenu: SidebarItem, SidebarMenuHeaderDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    private var currentMenuItem: SidebarMenuItem?
    private var menuItems = [SidebarMenuItem]()
    
    // MARK: UI
    private let header = SidebarMenuHeader()
    private let tableView = UITableView()
    private let textView = UITextView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var heightOfHeader = CGFloat(0)
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        
        makeMenuItems()
        
        heightToWidthRatio = 1.5
        
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
        
        heightOfHeader = 0.2
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        super.addAllUI() // This is because the generic sidebar item adds a blur layer to itself which must happen first
        
        addHeader()
        addTableView()
        addTextView()
        
    }
    
    override public func updateAllUI() {
        
        super.updateAllUI() // This is because the generic sidebar item adds a blur layer to itself which must happen first
        
        updateParameters()
        
        
        configureHeader()
        positionHeader()
        
        configureTableView()
        positionTableView()
        
        configureTextView()
        positionTextView()
        
    }
    
    
    // MARK: Adding
    private func addHeader () {
        addSubview(header)
    }
    
    private func addTableView () {
        addSubview(tableView)
    }
    
    private func addTextView () {
        addSubview(textView)
    }
    
    
    
    // MARK: Header
    private func configureHeader () {
        
        header.delegate = self
        header.currentMenuItem = currentMenuItem
        
        header.updateAllUI()
    }
    
    private func positionHeader () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = width * heightOfHeader
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = 0
        
        header.frame = newFrame
        
    }
    
    
    // MARK: Table View
    private func configureTableView () {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = clearColor
        
        tableView.registerClass(SidebarMenuTableViewCell.self, forCellReuseIdentifier: "SidebarMenuTableViewCell")
        
        tableView.showsVerticalScrollIndicator = false
        
        if currentMenuItem == nil {
            tableView.opacity = 1
        } else {
            tableView.opacity = 0
        }
    }
    
    private func positionTableView () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.size.height = height - header.bottom
        
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = header.bottom
        
        tableView.frame = newFrame
        
    }
    
    
    // MARK: Text View
    private func configureTextView () {
        
        textView.backgroundColor = clearColor
        
        textView.text = currentMenuItem?.text
        textView.textAlignment = NSTextAlignment.Center
        textView.textColor = blackColor
        textView.font = UIFont(name: "Avenir", size: 14)
        
        textView.showsVerticalScrollIndicator = false
        
        textView.editable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.All
        
        
        if currentMenuItem == nil {
            textView.opacity = 0
        } else {
            textView.opacity = 1
        }
        
    }
    
    private func positionTextView () {
        
        textView.frame = tableView.frame
        
    }
    
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK: Data Initialization
    
    private func makeMenuItems () {
        
        let bardCollegeShuttle = SidebarMenuItem()
        bardCollegeShuttle.title = "Bard College Shuttle"
        bardCollegeShuttle.text = "\nThe Bard College Shuttle is a shuttle bus that operates every day of the week for most of the day, during the school year. It travels from the town of Tivoli (which is to the north of campus) down to campus, and then it continues further south to the town of Red Hook. At certain times of day it goes on to Hannaford supermarket in south Red Hook. It then turns around and goes back up to campus, and then to Tivoli to start over again. As of April 2014 Bard Transportation has instituted an ID check upon boarding the shuttle. In order to be allowed to ride the shuttle, you must display a valid Bard ID, or if you are a visitor you must go to Bard Security to get a guest pass.\n\nTo view the schedule for the Bard Shuttle, return to the main (green) screen and drag your finger from the stop you will be departing from to the stop you wish to arrive at. The schedule is different for different days of the week so be sure to select the day you wish to see the schedule for. To see which shuttle stop each icon represents tap the icon you are wondering about and the name of the stop will appear to the right of the icon.\n\n"
        
        let golfCart = SidebarMenuItem()
        golfCart.title = "Golf Cart"
        golfCart.text = "\nThe Golf Cart is driven by a student every night of the week. It will pick up Bard students anywhere on campus and drive them to any other location on campus. Its hours of operation are 9:00 PM to 1:00 AM. To request the Golf Cart call Bard Security at (845) 758-7460. The Golf Cart is brought to you by Bard's Student Resource Group.\n\n*The Golf Cart does not operate in the rain or snow, or when it is exceptionally cold outside.\n\n"
        
        let tivoliDelivery = SidebarMenuItem()
        tivoliDelivery.title = "Tivoli Delivery"
        tivoliDelivery.text = "\nTivoli Delivery (A.K.A. Tiv-Deliv) is a school service which brings residents of Tivoli from campus to their houses on Thursday, Friday and Saturday nights from 12:00 AM to 3:00 AM. Tivoli Delivery cars leave from the security building (the Old Gym) every half hour. To be taken to Tivoli, you must be a registered resident of Tivoli. For inquiries call (845) 752-4444. Tivoli Delivery is brought to you by Bard's Student Resource Group.\n\n\n\n\n\n\n"
        
        let safeRide = SidebarMenuItem()
        safeRide.title = "Safe Ride"
        safeRide.text = "\nSafe Ride is a school service which will pick up Bard Students who live on campus from anywhere in the surrounding area and drop them at their dorm. This service is available on Thursday, Friday and Saturday nights from 12:00 AM to 3:00 AM. To request Safe Ride call (845) 752-4444. Safe Ride is brought to you by Bard's Student Resource Group.\n\n\n\n\n\n\n"
        
        let smartTimes = SidebarMenuItem()
        smartTimes.title = "Smart Times"
        smartTimes.text = "\nSmart Times is the name of the upper one of the two white windows in this menu. It uses your location to figure out which of the Bard College shuttle stops is closest to you and then displays the amount of time until the next shuttle leaves from that stop. The top half of the window displays the amount of time until the next northbound shuttle leaves from that stop, while the lower half of the window displays the amount of time until the next southbound shuttle leaves.\n\n\nTROUBLESHOOTING\n\nIf the Smart Times window seems to think that you are somewhere other than you are, it is probably due to the inaccuracy of the iPhone\'s GPS system. However, this can usually be fixed without even leaving the app. Simply swipe up from the very bottom of the screen to open the control center and tap the Wi-Fi symbol to turn on your phone\'s Wi-Fi. Then tap the Smart Times window to refresh it. Turning on Wi-Fi on your phone dramatically improves the accuracy of location data. This will work regardless of your proximity to an actual Wi-Fi network.\n\nIf the Smart Times window is displaying the message, \"Smart Times cannot access your location[...]\", then first make sure there isn\'t a litle airplane symbol in the upper left corner of the screen. If there is, then swipe up from the very bottom of the screen to open the control center. The airplane icon on the left should be white. Tap it and it should turn black. If your phone is not on airplane mode and you are still getting the error message then you probably did not grant the app permission to access your location when you first installed it. To fix this you must exit the app and go to the Settings app. Once there you go to Privacy/Location Services and make sure the switch next to the word \"Location Services\" at the top is on. Finally, scroll down until you see Bard Transportation in the list of apps and switch on the switch that is next to it. Return to the Bard Transport app and Smart Times should be working.\n"
        
        let localCabServices = SidebarMenuItem()
        localCabServices.title = "Local Cab Services"
        localCabServices.text = "\nBard Area \n\nVillage Taxi: (845) 757-2244 \n-------------------------------------------\n\nKingston Area\n\nKingston Kabs: (845) 331-8294\nSonia Cabs: (845) 336-2400\n-------------------------------------------\n\nDutchess Area\n\n Kingston Kabs: (845) 758-8294\n\n"
        
        let bardSecurity = SidebarMenuItem()
        bardSecurity.title = "Bard Security"
        bardSecurity.text = "\nBard Security is available 24/7. They can be reached at their main line: (845) 758-7460 or at their emergency line: (845) 758-7777. If you have locked yourself out of your room in the middle of the night, call security and they will let you back in. Note: $10 will be charged to your student account for every lock-out. In certain situations security will also give you a ride (if you, for example, are injured or need to transport a heavy item). If you ever feel unsafe on campus, call Bard Security and they will help you. The security office is located in the Old Gym next to Olin."
        
        let areaShuttles = SidebarMenuItem()
        areaShuttles.title = "Area Shuttles"
        areaShuttles.text = "\nBard provides shuttles between campus andr various surrounding areas. The schedule for these shuttles for the Fall 2015 semester is as follows:\n\n\nHUDSON VALLEY MALL IN KINGSTON\n\nA shuttle leaves from the Kline shuttle stop going to Kingston at 6:00 PM, most Wednesdays of the year. This shuttle stays in Kingston 9:00 PM, and then departs for Bard. The shuttle leaves from the same place in Kingston as it drops you off. This shuttle runs every Wednesday between September 2nd and December 17th EXCEPT FOR November 25th.\n\nThere is also a shuttle to Kingston on Saturdays which departs from the Kline shuttle stop at 2:00 PM and returns at 5:00 PM. This shuttle runs every Saturday between August 29th and December 12th EXCEPT FOR November 28th and December 5th.\n\n\nDOWNTOWN RHINEBECK\n\nBard provides shuttle service to Rhinebeck most Fridays of the year. There are seven shuttles to Rhinebeck on these days, leaving from Kline at 12:00 PM, 1:00 PM, 2:00 PM, 3:00 PM, 4:00 PM, 5:00 PM and 6:00 PM. The seven returning shuttles depart at 12:30 PM, 1:30 PM, 2:30 PM, 3:30 PM, 4:30 PM, 5:30 PM and 6:30 PM. Upon boarding the shuttle students may request to be dropped at the Rhinecliff train station. This shuttle runs every Friday between September 4th and Decemeber 11th EXCEPT FOR November 27th.\n\n\nWOODBURY COMMONS MALL\n\nFinally, there is a single trip to the Woodbury Commons Mall each semester. In the Fall 2015 semester this trip is on Saturday, December 5th. It leaves at 1:00 PM and returns at 7:00 PM.\n"
        
        let weekendTrainShuttles = SidebarMenuItem()
        weekendTrainShuttles.title = "Weekend Train Shuttles"
        weekendTrainShuttles.text = "\nBard provides weekend shuttle service which is coordinated with certain Amtrak and Metro-North trains. The weekend train shuttle service for the Fall 2015 semester is as follows:\n\n\nAMTRAK TRAINS FROM THE RHINECLIFF STATION\n\nFRIDAYS\n\nOn Fridays the shuttle to the Rhinecliff station is the same as the Area Shuttle to Downtown Rhinebeck. The shuttle travels from Kline to the Municipal Lot in Rhinebeck, and then, if someone has requested it, to the train station. You can board the shuttle either on campus, or in Rhinebeck, but to be taken to the train station YOU MUST REQUEST IT. Otherwise the shuttle will go straight back to campus. You can board the shuttle at Kline at 12:00 PM, 1:00 PM, 2:00 PM. 3:00 PM, 4:00 PM, 5:00 PM and 6:00 PM. You can also board the shuttle at its stop in Downtown Rhinebeck at 12:30 PM, 1:30 PM, 2:30 PM, 3:30 PM, 4:30 PM, 5:30 PM and 6:30 PM.\n\nSATURDAYS\n\nThere are no shuttles to the Rhinecliff train station on Saturdays. A cab from campus to the station is about $20.\n\nSUNDAYS\n\nOn Sundays there are two shuttles that go to the Rhinecliff station, which leave Kline at 5:45 PM and 8:15 PM. They arrive at the station with time to board the 6:26 PM and 9:01 PM trains to New York, respectively. They wait to pick up students arriving on the 6:55 PM and 8:55 PM trains respectively.\n\n\nMETRO-NORTH TRAINS FROM THE POUGHKEEPSIE STATION\n\nFRIDAYS\n\nOn Fridays there are three shuttles from campus to the Poughkeepsie train station. They depart from Kline at 1:45 PM, 3:45 PM and 5:45 PM, arriving at the station with enough time to board the 2:54 PM, 4:54 PM and 6:56 PM trains respectively. They wait to pick up students arriving on the 2:33 PM, 4:33 PM and 6:35 PM trains respectively. All trains are Metro-North.\n\nSATURDAYS\n\nOn Saturdays there is a morning bus and two evening buses to the Poughkeepsie train station which leave at 9:45 AM, 6:45 PM and 8:45 PM, arriving in time for students to board the 10:54 AM, 7:54 PM and 9:54 PM trains respectively. They wait to pick up students arriving on the 10:39 AM, 7:33 PM and 9:33 PM trains respectively. All trains are Metro-North.\n\nSUNDAYS\n\nOn Sundays there are three shuttles to the Poughkeepsie station. They leave Kline at 4:45 PM, 6:45 PM and 8:45 PM, dropping students off with enough time to board the 5:54 PM, 7:54 PM and 9:54 PM trains respectively. They wait to pick up students arriving on the 5:33 PM, 7:33 PM and 9:33 PM trains respectively. All trains are Metro-North.\n"
        
        
        // Currently not included because Jeremy does not want to continue repairing iPhones
        let campusiPhoneRepair = SidebarMenuItem()
        campusiPhoneRepair.title = "Campus iPhone Repair"
        campusiPhoneRepair.text = "\nIf you've cracked your iPhone screen and want it repaired now you can contact Uncracked™ iPhone Repair. They repair the screens of the iPhone 4, 4S, 5, 5C and 5S.\n Email uncrackedrepair@gmail.com or call (917) 579-3195 for more information.\n\n\n\n\n\n\n"
        
        let appFeedback = SidebarMenuItem()
        appFeedback.title = "App Feedback"
        appFeedback.text = "\nQuestions, comments, or suggestions about the app? Email them to bardtransportapp@gmail.com\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        
        let credits = SidebarMenuItem()
        credits.title = "Credits"
        credits.text = "\nDeveloped by\nJeremy Bannister\n\nGraphic Design by\nSonja Tsypin\n\nBotstein's bow tie courtesy of\nLeo Kaupert\n\nWith special thanks to\nMo King and Maja Nguyen\n\nLast but not least, the App Guru, for when all hope was lost. Thank you Greg Lanweber.\n\n"
        
        
        
        
        
        menuItems = [bardCollegeShuttle, golfCart, tivoliDelivery, safeRide, smartTimes, localCabServices, bardSecurity, areaShuttles, weekendTrainShuttles, appFeedback, credits]
        
    }
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Header
    public func sidebarMenuHeaderBackButtonWasPressed(sidebarMenuHeader: SidebarMenuHeader) {
        
        currentMenuItem = nil
        animatedUpdate(defaultAnimationDuration, options: .CurveEaseInOut) { (Bool) -> () in
            self.tableView.scrollRectToVisible(CGRectZero, animated: false)
        }
        
    }
    
    
    // MARK: Table View (data source)
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SidebarMenuTableViewCell") as? SidebarMenuTableViewCell {
            
            if menuItems.count > indexPath.row {
                cell.menuItem = menuItems[indexPath.row]
            }
            
            cell.backgroundColor = clearColor
            return cell
        }
        
        let newCell = SidebarMenuTableViewCell()
        newCell.backgroundColor = clearColor
        return newCell
        
    }
    
    
    // MARK: Table View (delegate)
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if menuItems.count > indexPath.row {
            currentMenuItem = menuItems[indexPath.row]
            animatedUpdate()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    
}
