//
//  ScheduledTimeTableViewCell.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/21/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduledTimeTableViewCell: UITableViewCell, GlobalVariablesInitializationNotificationSubscriber {
    
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Override
    public override var frame: CGRect {
        didSet {
            if (frame.size.width != oldValue.size.width) || (frame.size.height != oldValue.size.height) {
                updateAllUI()
            }
        }
    }
    
    // MARK: Delegate
    
    // MARK: State
    public var itinerary = Itinerary() {
        didSet {
            updateAllUI()
        }
    }
    
    public var nextShuttle = false
    
    // MARK: UI
    private let nextShuttleLabel = UILabel()
    
    private let departureTimeLabel = UILabel()
    private let arrivalTimeLabel = UILabel()
    
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var leftBufferForNextShuttleLabel = CGFloat(0)
    private var topBufferForNextShuttleLabel = CGFloat(0)
    
    
    private var bottomBufferForDepartureTimeLabel = CGFloat(0)
    private var leftBufferForDepartureTimeLabel = CGFloat(0)
    private var rightBufferForArrivalTimeLabel = CGFloat(0)
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    
    // MARK:
    // MARK: Default
    // MARK:
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if !globalVariablesInitialized {
            globalVariableInitializationNotificationSubscribers.append(self)
        } else {
            globalVariablesWereInitialized()
        }
        
        addAllUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    
    // MARK: Parameters
    public func updateParameters() {
        
        
        leftBufferForNextShuttleLabel = 0.07
        topBufferForNextShuttleLabel = 0.02
        
        
        bottomBufferForDepartureTimeLabel = 0.02
        leftBufferForDepartureTimeLabel = leftBufferForNextShuttleLabel
        rightBufferForArrivalTimeLabel = leftBufferForDepartureTimeLabel
        
        if iPad {
            
        }
    }
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    // MARK: All
    public func addAllUI () {
        
        addNextShuttleLabel()
        
        addDepartureTimeLabel()
        addArrivelTimeLabel()
        
    }
    
    public func updateAllUI () {
        
        updateParameters()
        
        
        
        configureNextShuttleLabel()
        positionNextShuttleLabel()
        
        
        
        configureDepartureTimeLabel()
        positionDepartureTimeLabel()
        
        configureArrivalTimeLabel()
        positionArrivalTimeLabel()
        
    }
    
    
    
    
    public func animatedUpdate () {
        UIView.animateWithDuration(defaultAnimationDuration, animations: { () -> Void in
            self.updateAllUI()
        })
    }
    
    
    
    
    // MARK: Adding
    private func addNextShuttleLabel () {
        addSubview(nextShuttleLabel)
    }
    
    
    
    
    private func addDepartureTimeLabel () {
        addSubview(departureTimeLabel)
    }
    
    private func addArrivelTimeLabel () {
        addSubview(arrivalTimeLabel)
    }
    
    
    
    // MARK: Next Shuttle Label
    private func configureNextShuttleLabel () {
        
        nextShuttleLabel.text = "Next Shuttle:"
        nextShuttleLabel.textAlignment = .Center
        nextShuttleLabel.textColor = blackColor
        nextShuttleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        
        
        if nextShuttle {
            nextShuttleLabel.opacity = 1
        } else {
            nextShuttleLabel.opacity = 0
        }
        
    }
    
    private func positionNextShuttleLabel () {
        
        if let text = nextShuttleLabel.text {
            var newFrame = CGRectZero
            let size = nextShuttleLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForNextShuttleLabel
            newFrame.origin.y = width * topBufferForNextShuttleLabel
            
            nextShuttleLabel.frame = newFrame
        }
    }
    
    
    
    
    
    // MARK: Departure Time Label
    private func configureDepartureTimeLabel () {
        
        if let departureTime = itinerary.departure.departureTime {
            departureTimeLabel.text = departureTime.description
        }
        
        departureTimeLabel.textColor = blackColor
        departureTimeLabel.textAlignment = NSTextAlignment.Center
        
        
        if nextShuttle {
            departureTimeLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        } else {
            departureTimeLabel.font = UIFont(name: "Avenir", size: 16)
        }
        
    }
    
    private func positionDepartureTimeLabel () {
        
        if let text = departureTimeLabel.text {
            
            var newFrame = CGRectZero
            let size = departureTimeLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForDepartureTimeLabel
            
            if nextShuttle {
                newFrame.origin.y = height - newFrame.size.height - (width * bottomBufferForDepartureTimeLabel)
            } else {
                newFrame.origin.y = (height - newFrame.size.height)/2
            }
            
            
            departureTimeLabel.frame = newFrame
            
        }
    }
    
    
    
    // MARK: Arrival Time Label
    private func configureArrivalTimeLabel () {
        
        arrivalTimeLabel.text = itinerary.arrival.arrivalTime.description
        arrivalTimeLabel.textColor = blackColor
        arrivalTimeLabel.textAlignment = NSTextAlignment.Center
        
        if nextShuttle {
            arrivalTimeLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        } else {
            arrivalTimeLabel.font = UIFont(name: "Avenir", size: 12)
        }
        
        
    }
    
    private func positionArrivalTimeLabel () {
        
        if let text = arrivalTimeLabel.text {
            
            var newFrame = CGRectZero
            let size = arrivalTimeLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width - newFrame.size.width - (width * rightBufferForArrivalTimeLabel)
            
            if nextShuttle {
                newFrame.origin.y = height - newFrame.size.height - (width * bottomBufferForDepartureTimeLabel)
            } else {
                newFrame.origin.y = (height - newFrame.size.height)/2
            }
            
            
            arrivalTimeLabel.frame = newFrame
        }
    }
    
    
}
