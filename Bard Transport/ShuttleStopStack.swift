//
//  ShuttleStopStack.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/23/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public enum ShuttleStopStackMode {
    case MainStops
    case CollapsedSingle
    case CollapsedDouble
    case AllStops
}

public class ShuttleStopStack: JABView, ShuttleStopViewDelegate, JABTouchableViewDelegate {
    
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    public var delegate: ShuttleStopStackDelegate?
    
    // MARK: State
    public var mode = ShuttleStopStackMode.MainStops
    private var selectedOrigin: ShuttleStopView? {
        didSet {
            
            oldValue?.selectionState = ShuttleStopViewSelectionState.None
            oldValue?.animatedUpdate()
            
            if selectedOrigin == nil {
                originIsStale = false
            } else {
                selectedOrigin?.selectionState = ShuttleStopViewSelectionState.Origin
                selectedOrigin?.animatedUpdate()
            }
            
        }
    }
    private var selectedDestination: ShuttleStopView? {
        didSet {
            oldValue?.selectionState = ShuttleStopViewSelectionState.None
            oldValue?.animatedUpdate()
            
            if selectedDestination != nil {
                selectedDestination?.selectionState = ShuttleStopViewSelectionState.Destination
                selectedDestination?.animatedUpdate()
            }
        }
    }
    private var originIsStale = false
    private var fillingStops = false
    private var emptyingStops = false {
        didSet {
            touchDetector.userInteractionEnabled = !emptyingStops
        }
    }
    private var transitioning = false {
        didSet {
            touchDetector.userInteractionEnabled = !transitioning
        }
    }
    private var touchLocation: CGPoint?
    
    
    /*
     public var shuttleStops = [ShuttleStop]() {
     didSet {
     
     var changed = false
     if oldValue.count != shuttleStops.count {
     changed = true
     } else {
     for i in 0 ..< shuttleStops.count {
     if oldValue[i] !== shuttleStops[i] {
     changed = true
     }
     }
     }
     
     if changed {
     createRoadViews()
     createShuttleStopViews()
     }
     }
     }
     
     */
    
    // MARK: UI
    private var roadViewsLayer = UIView()
    private var shuttleStopViewsLayer = UIView()
    
    private var shuttleStopViews = [ShuttleStopView]()
    private var visibleShuttleStopViews = [ShuttleStopView]()
    
    private var roadViews = [UIImageView]()
    private var visibleRoadViews = [UIImageView]()
    
    private let touchDetector = JABTouchableView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private let selectionDuration = NSTimeInterval(0.3)
    
    
    // **********************************************************************************************************************
    
    
    // MARK:
    // MARK: Methods
    // MARK:
    
    // MARK:
    // MARK: Init
    // MARK:
    
    public override init () {
        super.init()
        
        //        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "transition", userInfo: nil, repeats: true)
        
        createShuttleStopViews()
        createRoadViews()
        
        
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
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addRoadViewsLayer()
        addShuttleStopViewsLayer()
        
        addShuttleStopViews(mainStops: mode == .MainStops)
        addRoadViews(mainStops: mode == .MainStops)
        
        addTouchDetector()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        configureRoadViewsLayer()
        positionRoadViewsLayer()
        
        configureShuttleStopViewsLayer()
        positionShuttleStopViewsLayer()
        
        
        
        configureShuttleStopViews()
        positionShuttleStopViews()
        
        configureRoadViews()
        positionRoadViews()
        
        configureTouchDetector()
        positionTouchDetector()
        
    }
    
    
    
    
    // MARK: Adding
    private func addRoadViewsLayer () {
        addSubview(roadViewsLayer)
    }
    
    private func addShuttleStopViewsLayer () {
        addSubview(shuttleStopViewsLayer)
    }
    
    
    
    
    private func addRoadViews (mainStops mainStops: Bool) {
        
        var requiredNumber = shuttleStopManager.mainShuttleStops.count - 1
        if !mainStops {
            requiredNumber = shuttleStopManager.allShuttleStops.count - 1
        }
        
        visibleRoadViews.removeAll(keepCapacity: true)
        
        var i = 0
        for roadView in roadViews {
            if i < requiredNumber {
                roadViewsLayer.addSubview(roadView)
                visibleRoadViews.append(roadView)
            } else {
                roadView.removeFromSuperview()
            }
            i += 1
        }
        
    }
    
    
    private func addShuttleStopViews (mainStops mainStops: Bool) {
        
        var shuttleStops = shuttleStopManager.mainShuttleStops
        if !mainStops {
            shuttleStops = shuttleStopManager.allShuttleStops
        }
        
        visibleShuttleStopViews.removeAll(keepCapacity: true)
        
        for shuttleStopView in shuttleStopViews {
            var found = false
            for shuttleStop in shuttleStops {
                if shuttleStop.absoluteIndex == shuttleStopView.shuttleStop.absoluteIndex {
                    found = true
                    shuttleStopViewsLayer.addSubview(shuttleStopView)
                    visibleShuttleStopViews.append(shuttleStopView)
                }
            }
            if !found {
                shuttleStopView.removeFromSuperview()
            }
        }
        
    }
    
    private func addTouchDetector () {
        addSubview(touchDetector)
    }
    
    
    
    
    
    
    
    // MARK: Road Views Layer
    private func configureRoadViewsLayer () {
        roadViewsLayer.autoresizesSubviews = false
    }
    
    private func positionRoadViewsLayer () {
        roadViewsLayer.frame = relativeFrame
    }
    
    
    
    
    // MARK: Shuttle Stop Views Layer
    private func configureShuttleStopViewsLayer () {
        
    }
    
    private func positionShuttleStopViewsLayer () {
        shuttleStopViewsLayer.frame = relativeFrame
    }
    
    
    
    
    
    
    // MARK: Shuttle Stop Views
    private func deleteShuttleStopViews () {
        
        for shuttleStopView in shuttleStopViews {
            shuttleStopView.removeFromSuperview()
        }
        
        shuttleStopViews.removeAll(keepCapacity: true)
        
    }
    
    private func createShuttleStopViews () {
        
        deleteShuttleStopViews()
        
        // Iterate through the stops and create corresponding shuttle stop views
        for shuttleStop in shuttleStopManager.allShuttleStops {
            
            let shuttleStopView = ShuttleStopView(shuttleStop: shuttleStop)
            shuttleStopView.delegate = self
            shuttleStopViews.append(shuttleStopView)
            
        }
        
        
        addShuttleStopViews(mainStops: mode == .MainStops)
        
    }
    
    private func configureShuttleStopViews () {
        for shuttleStopView in shuttleStopViews {
            shuttleStopView.delegate = self
        }
    }
    
    private func positionShuttleStopViews () {
        
        if mode == ShuttleStopStackMode.MainStops {
            
            let spaceBetweenStops = width/4
            let heightOfStops = (height - (CGFloat((shuttleStopManager.mainShuttleStops.count - 1)) * spaceBetweenStops))/CGFloat(shuttleStopManager.mainShuttleStops.count)
            
            
            for i in 0..<(shuttleStopManager.mainShuttleStops.count) {
                let shuttleStopView = visibleShuttleStopViews[i]
                
                var newFrame = CGRectZero
                
                newFrame.size.height = heightOfStops
                newFrame.size.width = newFrame.size.height
                
                newFrame.origin.x = (width - newFrame.size.width)/2
                newFrame.origin.y = CGFloat(i) * (heightOfStops + spaceBetweenStops)
                
                shuttleStopView.frame = newFrame
                
            }
            
            
        } else if mode == .CollapsedSingle {
            
            let spaceBetweenStops = width/4
            let heightOfStops = (height - (CGFloat((shuttleStopManager.mainShuttleStops.count - 1)) * spaceBetweenStops))/CGFloat(shuttleStopManager.mainShuttleStops.count)
            
            for stop in visibleShuttleStopViews {
                var newFrame = CGRectZero
                
                newFrame.size.height = heightOfStops
                newFrame.size.width = newFrame.size.height
                
                newFrame.origin.x = (width - newFrame.size.width)/2
                newFrame.origin.y = 0
                
                stop.frame = newFrame
            }
            
        } else if mode == .CollapsedDouble {
            
            let widthOfStops = width * (1.0/2.0)
            
            for i in 0..<(visibleShuttleStopViews.count) {
                let shuttleStopView = visibleShuttleStopViews[i]
                
                var newFrame = CGRectZero
                
                newFrame.size.width = widthOfStops
                newFrame.size.height = newFrame.size.width
                
                if i % 2 == 0 {
                    newFrame.origin.x = 0
                } else {
                    newFrame.origin.x = width - newFrame.size.width
                }
                
                if i % 2 == 0 {
                    newFrame.origin.y = 0
                } else {
                    newFrame.origin.y = visibleShuttleStopViews[i - 1].y + visibleShuttleStopViews[i - 1].height * (2.0/3.0)
                }
                
                shuttleStopView.frame = newFrame
                
            }
            
            
            
        } else if mode == ShuttleStopStackMode.AllStops {
            
            let widthOfStops = width * (1.0/2.0)
            
            for i in 0..<(visibleShuttleStopViews.count) {
                let shuttleStopView = visibleShuttleStopViews[i]
                
                var newFrame = CGRectZero
                
                newFrame.size.width = widthOfStops
                newFrame.size.height = newFrame.size.width
                
                if i % 2 == 0 {
                    newFrame.origin.x = 0
                } else {
                    newFrame.origin.x = width - newFrame.size.width
                }
                
                if i == 0 {
                    newFrame.origin.y = 0
                } else {
                    newFrame.origin.y = visibleShuttleStopViews[i - 1].y + visibleShuttleStopViews[i - 1].height * (2.0/3.0)
                }
                
                shuttleStopView.frame = newFrame
                
            }
            
            
        }
        
    }
    
    
    
    // MARK: Road Views
    private func deleteRoadViews () {
        
        for roadView in roadViews {
            roadView.removeFromSuperview()
        }
        
        roadViews.removeAll(keepCapacity: true)
        
    }
    
    private func createRoadViews () {
        
        deleteRoadViews()
        
        for _ in 1..<shuttleStopManager.allShuttleStops.count { // Start at 1 because there is always one fewer road view than shuttle stop views
            
            let roadView = UIImageView()
            roadViews.append(roadView)
            
        }
        
        addRoadViews(mainStops: mode == .MainStops)
        
    }
    
    
    private func configureRoadViews () {
        
        for roadView in roadViews {
            roadView.image = UIImage(named: "Road.png")
        }
        
    }
    
    private func positionRoadViews () {
        
        for i in 0 ..< visibleRoadViews.count {
            
            if i < visibleShuttleStopViews.count - 1 {
                let roadView = visibleRoadViews[i]
                let topShuttleStopView = visibleShuttleStopViews[i]
                let bottomShuttleStopView = visibleShuttleStopViews[i + 1]
                
                
                if let size = roadView.image?.size {
                    if size.height != 0 {
                        let widthToHeightRatio = (size.width/size.height) * 0.6 // Changing the ratio of the image to taste
                        let verticalOffsetFromCenterOfStop = CGFloat(18)
                        
                        var newFrame = CGRectZero
                        let difference = CGPoint(x: bottomShuttleStopView.center.x - topShuttleStopView.center.x, y: bottomShuttleStopView.center.y - topShuttleStopView.center.y)
                        
                        
                        var angle = CGFloat(0.0)
                        if difference.x != 0 {
                            angle = atan(difference.y/difference.x) - CGFloat(pi)/2
                        }
                        
                        
                        newFrame.size.height = CGFloat(sqrt(Double((difference.x * difference.x) + (difference.y * difference.y))))
                        newFrame.size.width = newFrame.size.height * widthToHeightRatio
                        
                        roadView.bounds = newFrame
                        
                        roadView.center = CGPoint(x: topShuttleStopView.center.x + difference.x/2, y: topShuttleStopView.center.y + difference.y/2)
                        
                        roadView.transform = CGAffineTransformMakeRotation(CGFloat(angle))
                        
                    }
                }
            }
        }
            
        
        
        
        if mode == .MainStops {
            
            /*
             if roadViews.count == (visibleShuttleStopViews.count - 1) { // This will avoid fatal array out of bounds error
             
             for i in 0..<(roadViews.count) {
             let roadView = roadViews[i]
             
             var newFrame = CGRectZero
             let size = roadView.image?.size
             
             if let verifiedSize = size {
             
             if verifiedSize.height != 0 {
             
             let widthToHeightRatio = (verifiedSize.width/verifiedSize.height) * 0.6 // Changing the ratio of the image to taste
             let verticalOffsetFromCenterOfStop = CGFloat(18)
             
             
             newFrame.size.height = (visibleShuttleStopViews[i + 1].center.y - verticalOffsetFromCenterOfStop) - (visibleShuttleStopViews[i].center.y + verticalOffsetFromCenterOfStop)
             newFrame.size.width = newFrame.size.height * widthToHeightRatio
             
             newFrame.origin.x = (width - newFrame.size.width)/2
             newFrame.origin.y = visibleShuttleStopViews[i].center.y + verticalOffsetFromCenterOfStop
             
             roadView.frame = newFrame
             
             }
             
             }
             
             }
             
             }
             */
            
        } else if mode == ShuttleStopStackMode.AllStops {
            
            
            
            
        }
        
    }
    
    
    // MARK: Touch Detector
    private func configureTouchDetector () {
        
        bringSubviewToFront(touchDetector)
        touchDetector.delegate = self
        
    }
    
    private func positionTouchDetector () {
        
        touchDetector.frame = relativeFrame
        
    }
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    // MARK: Transition
    public func transition (completion: (Bool) -> ()) {
        
        let duration = 0.7
        transitioning = true
        
        if mode == .MainStops {
            
            mode = .CollapsedSingle
            animatedUpdate(duration*(3.0/8.0), options: UIViewAnimationOptions.CurveEaseOut, completion: { (Bool) in
                self.addShuttleStopViews(mainStops: false)
                self.addRoadViews(mainStops: false)
                self.positionShuttleStopViews()
                self.positionRoadViews()
                
                self.mode = .CollapsedDouble
                self.animatedUpdate(duration/4, options: UIViewAnimationOptions.CurveEaseInOut, completion: { (Bool) -> () in
                    self.mode = .AllStops
                    self.animatedUpdate(duration*(3.0/8.0), options: UIViewAnimationOptions.CurveEaseOut, completion: completion)
                    self.transitioning = false
                })
            })
            
        } else {
            
            if let origin = selectedOrigin {
                var found = false
                for stop in shuttleStopManager.mainShuttleStops {
                    if stop.absoluteIndex == origin.shuttleStop.absoluteIndex {
                        found = true
                    }
                }
                if !found {
                    animateDeselection()
                    selectedOrigin = nil
                    originIsStale = false
                }
            }
            
            
            mode = .CollapsedDouble
            animatedUpdate(duration*(3.0/8.0), options: UIViewAnimationOptions.CurveEaseOut, completion: { (Bool) in
                self.mode = .CollapsedSingle
                self.animatedUpdate(duration/4, options: UIViewAnimationOptions.CurveEaseInOut, completion: { (Bool) -> () in
                    
                    self.addShuttleStopViews(mainStops: true)
                    self.addRoadViews(mainStops: true)
                    
                    self.mode = .MainStops
                    self.animatedUpdate(duration*(3.0/8.0), options: UIViewAnimationOptions.CurveEaseOut, completion: completion)
                    self.transitioning = false
                })
            })
        }
    }
    
    // MARK: Selection
    private func determineTouchedStop(location: CGPoint, strict: Bool) -> ShuttleStopView? {
        
        if strict {
            for stopView in visibleShuttleStopViews {
                if stopView.frame.contains(location) {
                    return stopView
                }
            }
            
            return nil
            
        } else {
            
            var candidates = [ShuttleStopView]() // First find all shuttle stops which the user might be intending to select
            
            for stopView in visibleShuttleStopViews {
                
                if location.y > stopView.frame.origin.y {
                    if location.y < stopView.frame.bottom {
                        
                        candidates.append(stopView) // Search for all shuttle stops that exist at the same y value as the touch location
                        
                    }
                }
                
            }
            
            var closestStop: ShuttleStopView?
            
            for stopView in candidates { // Make final decision about which stop is selected
                
                if let verifiedClosestStop = closestStop {
                    if distanceBetweenPoints(location, point2: stopView.center) < distanceBetweenPoints(location, point2: verifiedClosestStop.center) {
                        closestStop = stopView
                    }
                } else {
                    closestStop = stopView
                }
                
            }
            
            return closestStop
            
        }
        
    }
    
    private func setStopAsOrigin (shuttleStopView: ShuttleStopView) {
        
        // Prep the shuttle stop view for fading-in animation
        shuttleStopView.fluidState = .Full
        shuttleStopView.fluidOpacity = .Transparent
        shuttleStopView.updateAllUI()
        
        
        // Animate fade-in
        shuttleStopView.fluidOpacity = .Opaque
        shuttleStopView.selectionState = .Origin
        shuttleStopView.animatedUpdate()
        
        // Set selected origin
        selectedOrigin = shuttleStopView
        
    }
    
    
    private func setStopAsDestination (shuttleStopView: ShuttleStopView) {
        
        // Check that the origin is not nil and is known
        if let originIndex = indexOfShuttleStopView(selectedOrigin) {
            // Check that the supplied destination is known
            if let destinationIndex = indexOfShuttleStopView(shuttleStopView) {
                // Check that the origin and the supplied destination are not the same stop
                if originIndex != destinationIndex {
                    
                    selectedDestination = shuttleStopView // Set the selected destination
                    fillingStops = true // Set the fillingStops boolean so that the stack behaves correctly during the animation
                    visibleShuttleStopViews[originIndex + ((destinationIndex - originIndex)/(abs(destinationIndex - originIndex)))].fill(fromTop: originIndex < destinationIndex, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                    
                }
            }
        }
        
    }
    
    
    
    public func animateDeselection () {
        
        // Check that the origin is not nil and is known
        if let originIndex = indexOfShuttleStopView(selectedOrigin) {
            // Check that the destination is not nil and is known
            if let destinationIndex = indexOfShuttleStopView(selectedDestination) {
                // Check that the origin and the destination are not the same stop
                if originIndex != destinationIndex {
                    
                    
                    
                    emptyingStops = true // Set the fillingStops boolean so that the stack behaves correctly during the animation
                    
                    // Set the selection state of both the origin and the destination to none, but visually it will only take effect when each one is emptied separately.
                    selectedDestination?.selectionState = .None
                    selectedOrigin?.selectionState = .None
                    
                    visibleShuttleStopViews[destinationIndex].empty(toTop: originIndex < destinationIndex, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                    
                }
            } else {
                selectedOrigin?.selectionState = .None
                selectedOrigin?.fluidOpacity = .Transparent
                selectedOrigin?.animatedUpdate(completion: { (Bool) -> () in
                    self.selectedOrigin?.fluidOpacity = .Opaque
                    self.selectedOrigin?.fluidState = .Top
                    self.selectedOrigin?.updateAllUI()
                    self.selectedOrigin = nil
                })
            }
        }
        
    }
    
    private func indexOfShuttleStopView (shuttleStopView: ShuttleStopView?) -> Int? {
        
        if shuttleStopView != nil {
            for i in 0 ..< visibleShuttleStopViews.count {
                if shuttleStopView! === visibleShuttleStopViews[i] {
                    return i
                }
            }
        }
        
        return nil
    }
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    
    // MARK: Shuttle Stop View
    public func shuttleStopViewDidFinishFilling(shuttleStopView: ShuttleStopView) {
        
        if fillingStops {
            if let originIndex = indexOfShuttleStopView(selectedOrigin) {
                if let destinationIndex = indexOfShuttleStopView(selectedDestination) {
                    if let index = indexOfShuttleStopView(shuttleStopView) {
                        if originIndex < destinationIndex {
                            if index < (destinationIndex - 1) {
                                visibleShuttleStopViews[index + 1].fill(fromTop: true, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                            } else {
                                if touchLocation != nil && selectedDestination != nil {
                                    
                                    // Prep the selected destination for animation
                                    selectedDestination?.fluidOpacity = .Opaque
                                    selectedDestination?.fluidState = .Top
                                    selectedDestination?.updateAllUI()
                                    
                                    // Initiate animation
                                    selectedDestination?.fluidCoordinates = (touchLocation!.y - selectedDestination!.y, false)
                                    selectedDestination?.fluidState = .Unrestricted
                                    selectedDestination?.animatedUpdate(completion: { (Bool) -> () in
                                        self.fillingStops = false
                                    })
                                }
                            }
                        } else if originIndex > destinationIndex {
                            if index > (destinationIndex + 1) {
                                visibleShuttleStopViews[index - 1].fill(fromTop: false, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                            } else {
                                if touchLocation != nil && selectedDestination != nil {
                                    
                                    // Prep the selected destination for animation
                                    selectedDestination?.fluidOpacity = .Opaque
                                    selectedDestination?.fluidState = .Bottom
                                    selectedDestination?.updateAllUI()
                                    
                                    // Initiate animation
                                    selectedDestination?.fluidCoordinates = (touchLocation!.y - selectedDestination!.y, true)
                                    selectedDestination?.fluidState = .Unrestricted
                                    selectedDestination?.animatedUpdate(completion: { (Bool) -> () in
                                        self.fillingStops = false
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    public func shuttleStopViewDidFinishEmptying(shuttleStopView: ShuttleStopView) {
        
        if emptyingStops {
            if let originIndex = indexOfShuttleStopView(selectedOrigin) {
                if let destinationIndex = indexOfShuttleStopView(selectedDestination) {
                    if let index = indexOfShuttleStopView(shuttleStopView) {
                        if originIndex < destinationIndex {
                            if index > originIndex {
                                
                                visibleShuttleStopViews[index - 1].empty(toTop: true, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                            } else {
                                emptyingStops = false
                                selectedDestination = nil
                                selectedOrigin = nil
                            }
                        } else if originIndex > destinationIndex {
                            if index < originIndex {
                                visibleShuttleStopViews[index + 1].empty(toTop: false, duration: (selectionDuration)/(Double(abs(destinationIndex - originIndex))))
                            } else {
                                emptyingStops = false
                                selectedDestination = nil
                                selectedOrigin = nil
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    // MARK: Touchable View
    public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
        touchLocation = gestureRecognizer.locationInView(self)
        delegate?.shuttleStopStackSelectionInProgress()
        
        if let touchedStop = determineTouchedStop(gestureRecognizer.locationInView(self), strict: true) {
            
            if selectedOrigin != nil {
                setStopAsDestination(touchedStop)
            } else {
                setStopAsOrigin(touchedStop)
            }
            
        } else {
            
        }
        
    }
    
    
    public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        touchLocation = gestureRecognizer.locationInView(self)
        let shortDuration = NSTimeInterval(0.05)
        
        if let touchedStop = determineTouchedStop(gestureRecognizer.locationInView(self), strict: false) {
            if let originIndex = indexOfShuttleStopView(selectedOrigin) {
                if let touchedIndex = indexOfShuttleStopView(touchedStop) {
                    if originIndex != touchedIndex {
                        
                        var destinationHasChanged = false
                        
                        if selectedDestination != nil && selectedDestination != touchedStop {
                            destinationHasChanged = true
                            if let oldDestinationIndex = indexOfShuttleStopView(selectedDestination) {
                                if abs(oldDestinationIndex - originIndex) < abs(touchedIndex - originIndex) {
                                    if originIndex < oldDestinationIndex {
                                        if oldDestinationIndex < touchedIndex { // Check this because app will crash if you try to make a range with a large beginning value than end value
                                            for i in oldDestinationIndex ..< touchedIndex {
                                                visibleShuttleStopViews[i].fluidState = .Full
                                                visibleShuttleStopViews[i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                                    
                                                })
                                            }
                                        }
                                    } else {
                                        for i in 0 ..< abs(oldDestinationIndex - touchedIndex) {
                                            visibleShuttleStopViews[oldDestinationIndex - i].fluidState = .Full
                                            visibleShuttleStopViews[oldDestinationIndex - i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                                
                                            })
                                        }
                                    }
                                } else {
                                    if originIndex < oldDestinationIndex {
                                        for i in 0 ..< abs(oldDestinationIndex - touchedIndex) {
                                            visibleShuttleStopViews[oldDestinationIndex - i].fluidState = .Top
                                            visibleShuttleStopViews[oldDestinationIndex - i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                                
                                            })
                                        }
                                    } else {
                                        if oldDestinationIndex < touchedIndex {
                                            for i in oldDestinationIndex ..< touchedIndex {
                                                visibleShuttleStopViews[i].fluidState = .Bottom
                                                visibleShuttleStopViews[i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                                    
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if selectedDestination == nil {
                                if originIndex < touchedIndex {
                                    for i in (originIndex + 1) ..< touchedIndex {
                                        visibleShuttleStopViews[i].fluidState = .Full
                                        visibleShuttleStopViews[i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                            
                                        })
                                    }
                                } else {
                                    for i in 1 ..< abs(originIndex - touchedIndex) {
                                        visibleShuttleStopViews[originIndex - i].fluidState = .Full
                                        visibleShuttleStopViews[originIndex - i].animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                            
                                        })
                                    }
                                }
                            }
                        }
                        
                        selectedDestination = touchedStop
                        
                        if !fillingStops {
                            if touchLocation != nil && selectedDestination != nil {
                                
                                if originIndex > touchedIndex {
                                    selectedDestination?.fluidCoordinates = (selectedDestination!.bottom - touchLocation!.y, true)
                                } else {
                                    selectedDestination?.fluidCoordinates = (touchLocation!.y - selectedDestination!.y, false)
                                }
                                
                                selectedDestination?.fluidState = .Unrestricted
                                selectedDestination?.fluidOpacity = .Opaque
                                
                                if destinationHasChanged {
                                    selectedDestination?.animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                        
                                    })
                                } else {
                                    selectedDestination?.updateAllUI()
                                }
                                
                            }
                        }
                        
                    } else {
                        if let destinationIndex = indexOfShuttleStopView(selectedDestination) {
                            if destinationIndex > originIndex {
                                selectedDestination?.fluidState = .Top
                            } else {
                                selectedDestination?.fluidState = .Bottom
                            }
                            selectedDestination?.selectionState = .None
                            selectedDestination?.animatedUpdate(defaultAnimationDuration, completion: { (Bool) -> () in
                                
                            })
                        }
                        selectedDestination = nil
                    }
                }
            } else {
                
            }
            
        } else {
            if let yValue = touchLocation?.y {
                if let originIndex = indexOfShuttleStopView(selectedOrigin) {
                    if let destinationIndex = indexOfShuttleStopView(selectedDestination) {
                        if let destination = selectedDestination {
                            if originIndex < destinationIndex {
                                if yValue < destination.top {
                                    selectedDestination?.fluidCoordinates = (0, false)
                                } else if yValue > destination.bottom {
                                    selectedDestination?.fluidCoordinates = (destination.height, false)
                                }
                            } else {
                                if yValue < destination.top {
                                    selectedDestination?.fluidCoordinates = (destination.height, true)
                                } else if yValue > destination.bottom {
                                    selectedDestination?.fluidCoordinates = (0, true)
                                }
                            }
                            selectedDestination?.animatedUpdate(shortDuration, completion: { (Bool) -> () in
                                
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        touchLocation = gestureRecognizer.locationInView(self)
        
        if let origin = selectedOrigin {
            if let destination = selectedDestination {
                
                touchLocation = CGPoint(x: destination.center.x, y: destination.bottom)
                
                if !fillingStops {
                    selectedDestination?.fluidState = .Full
                    selectedDestination?.animatedUpdate()
                }
                
                delegate?.shuttleStopStack(self, didSelectOrigin: origin.shuttleStop, destination: destination.shuttleStop)
            } else {
                if originIsStale {
                    animateDeselection()
                    selectedOrigin = nil
                    originIsStale = false
                } else {
                    originIsStale = true
                }
            }
        }
        
        delegate?.shuttleStopStackSelectionNoLongerInProgress()
        
    }
    
    public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        
        touchLocation = nil
        delegate?.shuttleStopStackSelectionNoLongerInProgress()
        
    }
    
    
    
}



public protocol ShuttleStopStackDelegate {
    
    func shuttleStopStackSelectionInProgress ()
    func shuttleStopStackSelectionNoLongerInProgress ()
    func shuttleStopStack (shuttleStopStack: ShuttleStopStack, didSelectOrigin origin: ShuttleStop, destination: ShuttleStop)
    
}

