//
//  ShuttleStopView.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/24/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public enum ShuttleStopViewFluidState {
    case Top
    case Bottom
    case Full
    case Unrestricted
}

public enum ShuttleStopViewFluidOpacity {
    case Transparent
    case Opaque
}

public enum ShuttleStopViewSelectionState {
    case None
    case Origin
    case Destination
}

public class ShuttleStopView: JABView {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ShuttleStopViewDelegate?
    
    // MARK: State
    public var shuttleStop = ShuttleStop()
    public var fluidState = ShuttleStopViewFluidState.Full
    public var fluidOpacity = ShuttleStopViewFluidOpacity.Transparent
    public var fluidCoordinates = (CGFloat(0), false) // (HeightOfFluid, fromBottom)
    
    public var selectionState = ShuttleStopViewSelectionState.None
    
    // MARK: UI
    private let fancyFlag = UIImageView()
    private let fancyFlagMask = UIView()
    private let selectionLabel = UILabel()
    
    private let background = UIView()
    private let fluid = UIView()
    private let imageView = UIImageView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private var insetForFancyFlag = CGFloat(0)
    private var heightOfFancyFlag = CGFloat(0)
    private var bufferBetweenSelectionLabelAndLeft = CGFloat(0)
    
    
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        selectionLabel.text = "From:"
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init()
        print("Should not be initializing from coder \(self)")
    }
    
    
    convenience init (shuttleStop: ShuttleStop) {
        self.init()
        
        self.shuttleStop = shuttleStop
        
    }
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        insetForFancyFlag = 0.2
        heightOfFancyFlag = 0.4
        
        bufferBetweenSelectionLabelAndLeft = 0.15
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addFancyFlag()
        addFancyFlagMask()
        addSelectionLabel()
        
        addBackground()
        addFluid()
        addImageView()
        
    }
    
    override public func updateAllUI() {
        
        
        configureFancyFlag()
        positionFancyFlag()
        
        configureFancyFlagMask()
        positionFancyFlagMask()
        
        configureSelectionLabel()
        positionSelectionLabel()
        
        
        
        
        configureBackground()
        positionBackground()
        
        configureFluid()
        positionFluid()
        
        configureImageView()
        positionImageView()
        
    }
    
    
    
    // MARK: Adding
    private func addFancyFlag () {
        fancyFlagMask.addSubview(fancyFlag)
    }
    
    private func addFancyFlagMask () {
        addSubview(fancyFlagMask)
    }
    
    private func addSelectionLabel () {
        addSubview(selectionLabel)
    }
    
    
    
    
    private func addBackground () {
        addSubview(background)
    }
    
    private func addFluid () {
        background.addSubview(fluid)
    }
    
    private func addImageView () {
        addSubview(imageView)
    }
    
    
    
    
    
    
    
    
    
    // MARK: Fancy Flag
    private func configureFancyFlag () {
        
        fancyFlag.image = shuttleStop.flagImage
        
    }
    
    private func positionFancyFlag () {
        
        if let size = fancyFlag.image?.size {
            if size.height != 0 {
                var newFrame = CGRectZero
                
                newFrame.size.height = width * heightOfFancyFlag
                newFrame.size.width = newFrame.size.height * (size.width/size.height)
                
                newFrame.origin.x = 0
                newFrame.origin.y = (fancyFlagMask.height - newFrame.size.height)/2
                
                fancyFlag.frame = newFrame
            }
        }
        
    }
    
    // MARK: Fancy Flag Mask
    private func configureFancyFlagMask () {
        
        fancyFlagMask.clipsToBounds = true
        
    }
    
    private func positionFancyFlagMask () {
        
        var newFrame = CGRectZero
        
        if selectionState == ShuttleStopViewSelectionState.None {
            newFrame.size.width = 0
        } else {
            newFrame.size.width = fancyFlag.width
        }
        
        newFrame.size.height = height
        
        newFrame.origin.x = width - (width * insetForFancyFlag)
        newFrame.origin.y = (height - newFrame.size.height)/2
        
        fancyFlagMask.frame = newFrame
        
        positionFancyFlag() // This is used for proper initial animation
        
    }
    
    
    
    
    
    // MARK: Selection Label
    private func configureSelectionLabel () {
        
        switch selectionState {
        case .None:
            break
        case .Origin:
            selectionLabel.text = "From:"
        case .Destination:
            selectionLabel.text = "To:"
        }
        
        selectionLabel.textAlignment = NSTextAlignment.Center
        selectionLabel.textColor = blackColor
        selectionLabel.font = UIFont(name: "Avenir", size: 15)
        
        selectionLabel.shadowOpacity = 0.3
        
    }
    
    private func positionSelectionLabel () {
        
        if let text = selectionLabel.text {
            var newFrame = CGRectZero
            let size = selectionLabel.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            if selectionState == ShuttleStopViewSelectionState.None {
                newFrame.origin.x = 5
            } else {
                newFrame.origin.x = -newFrame.size.width - (width * bufferBetweenSelectionLabelAndLeft)
            }
            
            newFrame.origin.y = (height - newFrame.size.height)/2
            
            selectionLabel.frame = newFrame
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: Background
    private func configureBackground () {
        
        let whiteLevel = CGFloat(200.0/255.0)
        background.backgroundColor = UIColor(white: whiteLevel, alpha: 1)
        
        background.cornerRadius = width/2
        background.clipsToBounds = true
        
    }
    
    private func positionBackground () {
        background.frame = relativeFrame
    }
    
    
    // MARK: Fluid
    private func configureFluid () {
        
        fluid.backgroundColor = UIColor(red: (159.0/255.0), green: (16.0/255.0), blue: (7.0/255.0), alpha: 1)
        
        switch fluidOpacity {
        case .Opaque:
            fluid.opacity = 1
        case .Transparent:
            fluid.opacity = 0
        }
        
    }
    
    private func positionFluid () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width
        newFrame.origin.x = (width - newFrame.size.width)/2
        
        switch fluidState {
        case .Top:
            newFrame.size.height = 0
            newFrame.origin.y = 0
        case .Bottom:
            newFrame.size.height = 0
            newFrame.origin.y = height
        case .Full:
            newFrame.size.height = height
            newFrame.origin.y = 0
        case .Unrestricted:
            newFrame.size.height = fluidCoordinates.0
            
            if fluidCoordinates.1 {
                newFrame.origin.y = height - newFrame.size.height
            } else {
                newFrame.origin.y = 0
            }
        }
        
        fluid.frame = newFrame
        
    }
    
    
    
    
    // MARK: Image View
    private func configureImageView () {
        
        self.imageView.image = self.shuttleStop.icon
        
    }
    
    private func positionImageView () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = self.width * 0.8
        newFrame.size.height = newFrame.size.width
        
        newFrame.origin.x = (self.width - newFrame.size.width)/2
        newFrame.origin.y = (self.height - newFrame.size.height)/2
        
        self.imageView.frame = newFrame
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Animation
    public func fill (fromTop fromTop: Bool, duration: NSTimeInterval) {
        
        // Set fluid to initial position
        if fromTop {
            fluidState = .Top
        } else {
            fluidState = .Bottom
        }
        
        fluidOpacity = .Opaque
        updateAllUI()
        
        
        // Animate to full, then notify delegate
        fluidState = .Full
        animatedUpdate(duration) { (Bool) -> () in
            self.delegate?.shuttleStopViewDidFinishFilling(self)
        }
    }
    
    public func empty (toTop toTop: Bool, duration: NSTimeInterval) {
        
        if toTop {
            fluidState = .Top
        } else {
            fluidState = .Bottom
        }
        
        fluidOpacity = .Opaque
        
        animatedUpdate(duration) { (Bool) -> () in
            self.delegate?.shuttleStopViewDidFinishEmptying(self)
        }
        
    }
    
    
}


public protocol ShuttleStopViewDelegate {
    func shuttleStopViewDidFinishFilling (shuttleStopView: ShuttleStopView)
    func shuttleStopViewDidFinishEmptying (shuttleStopView: ShuttleStopView)
}
