//
//  ScheduleSheetTableViewSectionHeader.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 9/1/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class ScheduleSheetTableViewSectionHeader: JABView {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    public var origin = ShuttleStop()
    public var destination = ShuttleStop()
    
    // MARK: UI
    private let departsLabel = UILabel()
    private let originLabel = UILabel()
    
    private let arrivesLabel = UILabel()
    private let destinationLabel = UILabel()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var topBufferForDepartsLabel = CGFloat(0)
    private var leftBufferForDepartsLabel = CGFloat(0)
    private var rightBufferForArrivesLabel = CGFloat(0)
    private var bufferBetweenDepartsLabelAndOriginLabel = CGFloat(0)
    private var fontSize = CGFloat(9)
    
    
    
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
        
        topBufferForDepartsLabel = 0.007
        leftBufferForDepartsLabel = 0.07
        rightBufferForArrivesLabel = leftBufferForDepartsLabel
        bufferBetweenDepartsLabelAndOriginLabel = 0.005
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addDepartsLabel()
        addOriginLabel()
        
        addArrivesLabel()
        addDestinationLabel()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureDepartsLabel()
        positionDepartsLabel()
        
        configureOriginLabel()
        positionOriginLabel()
        
        
        
        
        configureArrivesLabel()
        positionArrivesLabel()
        
        configureDestinationLabel()
        positionDestinationLabel()
        
    }
    
    
    // MARK: Adding
    private func addDepartsLabel () {
        addSubview(departsLabel)
    }
    
    private func addOriginLabel () {
        addSubview(originLabel)
    }
    
    
    
    private func addArrivesLabel () {
        addSubview(arrivesLabel)
    }
    
    private func addDestinationLabel () {
        addSubview(destinationLabel)
    }
    
    
    
    
    // MARK: Departs Label
    private func configureDepartsLabel () {
        
        departsLabel.text = "Departs from"
        departsLabel.textAlignment = NSTextAlignment.Center
        departsLabel.textColor = blackColor
        departsLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        
    }
    
    private func positionDepartsLabel () {
        
        if let text = departsLabel.text {
            
            var newFrame = CGRectZero
            let size = departsLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForDepartsLabel
            newFrame.origin.y = width * topBufferForDepartsLabel
            
            departsLabel.frame = newFrame
        }
    }
    
    
    // MARK: Origin Label
    private func configureOriginLabel () {
        
        originLabel.text = origin.name + ":"
        originLabel.textAlignment = NSTextAlignment.Center
        originLabel.textColor = blackColor
        originLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        
    }
    
    private func positionOriginLabel () {
        
        if let text = originLabel.text {
            
            var newFrame = CGRectZero
            let size = originLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = departsLabel.x
            newFrame.origin.y = departsLabel.bottom + (width * bufferBetweenDepartsLabelAndOriginLabel)
            
            originLabel.frame = newFrame
        }
    }
    
    
    
    
    
    // MARK: Arrives Label
    private func configureArrivesLabel () {
        
        arrivesLabel.text = "Arrives at"
        arrivesLabel.textAlignment = NSTextAlignment.Center
        arrivesLabel.textColor = blackColor
        arrivesLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        
    }
    
    private func positionArrivesLabel () {
        
        if let text = arrivesLabel.text {
            
            var newFrame = CGRectZero
            let size = departsLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width - newFrame.size.width - (width * rightBufferForArrivesLabel)
            newFrame.origin.y = width * topBufferForDepartsLabel
            
            arrivesLabel.frame = newFrame
        }
    }
    
    
    // MARK: Destination Label
    private func configureDestinationLabel () {
        
        destinationLabel.text = destination.name + ":"
        destinationLabel.textAlignment = NSTextAlignment.Center
        destinationLabel.textColor = blackColor
        destinationLabel.font = UIFont(name: "AvenirNext-DemiBold", size: fontSize)
        
    }
    
    private func positionDestinationLabel () {
        
        if let text = destinationLabel.text {
            
            var newFrame = CGRectZero
            let size = destinationLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = arrivesLabel.x
            newFrame.origin.y = arrivesLabel.bottom + (width * bufferBetweenDepartsLabelAndOriginLabel)
            
            destinationLabel.frame = newFrame
        }
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
}
