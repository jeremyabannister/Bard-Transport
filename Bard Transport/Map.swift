//
//  Map.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 4/20/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore
import MapKit

public class Map: JABView, MKMapViewDelegate, JABTouchableViewDelegate, JABButtonDelegate {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Override
    override public var frame: CGRect {
        didSet {
            
            if frame.size.width != oldValue.size.width || frame.size.height != oldValue.size.height {
                mapRegionInitialized = false
            }
        }
    }
    
    // MARK: Delegate
    public var delegate: MapDelegate?
    
    // MARK: State
    private var mapRegionInitialized = false
    private var onDefaultRegion = false
    
    // MARK: UI
    private let mapView = MKMapView()
    private let backPanTouchCover = JABTouchableView()
    private let backButton = JABButton()
    private let campusButton = JABButton()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    private let defaultCenter = CLLocationCoordinate2D(latitude: 42.0200102, longitude: -73.8983328)
    private let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
    private var defaultRegion = MKCoordinateRegion()
    
    
    private var leftBufferForBackButton = CGFloat(0)
    private var topBufferForBackButton = CGFloat(0)
    private var widthOfBackButton = CGFloat(0)
    private var heightOfBackButton = CGFloat(0)
    
    
    private var bottomBufferForCampusButton = CGFloat(0)
    private var widthOfCampusButton = CGFloat(0)
    private var heightOfCampusButton = CGFloat(0)
    
    
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
    }
    
    
    override public func globalVariablesWereInitialized() {
        
        updateParameters()
        
    }
    
    
    // MARK: Parameters
    override public func updateParameters() {
        
        defaultRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
        
        
        leftBufferForBackButton = 0.02
        topBufferForBackButton = 0.07
        widthOfBackButton = 0.25
        heightOfBackButton = 0.17
        
        
        bottomBufferForCampusButton = 0.07
        widthOfCampusButton = 0.5
        heightOfCampusButton = 0.17
        
        
        
        
        if iPad {
            
        }
        
    }
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addMapView()
        addAnnotations()
        addBackPanTouchCover()
        
        addBackButton()
        addCampusButton()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureMapView()
        positionMapView()
        
        configureBackPanTouchCover()
        positionBackPanTouchCover()
        
        
        
        
        configureBackButton()
        positionBackButton()
        
        configureCampusButton()
        positionCampusButton()
        
    }
    
    
    
    // MARK: Adding
    private func addMapView () {
        addSubview(mapView)
    }
    
    private func addAnnotations () {
        
        for shuttleStop in shuttleStopManager.allShuttleStops {
            mapView.addAnnotation(shuttleStop)
        }
        
    }
    
    private func addBackPanTouchCover () {
        addSubview(backPanTouchCover)
    }
    
    private func addBackButton () {
        addSubview(backButton)
    }
    
    private func addCampusButton () {
        addSubview(campusButton)
    }
    
    
    // MARK: Map View
    private func configureMapView () {
        
        mapView.delegate = self
        
        if !mapRegionInitialized {
            mapRegionInitialized = true
            zoomToCampus(false)
        }
        
        mapView.rotateEnabled = false
        mapView.pitchEnabled = false
        mapView.showsUserLocation = true
        
    }
    
    private func positionMapView () {
        
        mapView.frame = relativeFrame
        
    }
    
    
    // MARK: Back Pan Touch Cover
    private func configureBackPanTouchCover () {
        backPanTouchCover.delegate = self
    }
    
    private func positionBackPanTouchCover () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = backPanTouchThreshold
        newFrame.size.height = height
        
        
        newFrame.origin.x = 0
        newFrame.origin.y = 0
        
        backPanTouchCover.frame = newFrame
    }
    
    
    
    // MARK: Back Button
    private func configureBackButton () {
        
        backButton.type = JABButtonType.Text
        backButton.buttonDelegate = self
        
        backButton.text = "Back"
        backButton.textAlignment = NSTextAlignment.Center
        backButton.textColor = blackColor
        backButton.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        backButton.dimsWhenPressed = true
        backButton.shadowOpacity = 0.2
        
        backButton.updateAllUI()
        
    }
    
    private func positionBackButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfBackButton
        newFrame.size.height = width * heightOfBackButton
        
        newFrame.origin.x = width * leftBufferForBackButton
        newFrame.origin.y = width * topBufferForBackButton
        
        backButton.frame = newFrame
        
    }
    
    
    // MARK: Campus Button
    private func configureCampusButton () {
        
        campusButton.type = JABButtonType.Text
        campusButton.buttonDelegate = self
        
        campusButton.text = "Back To Campus"
        campusButton.textAlignment = NSTextAlignment.Center
        campusButton.textColor = blackColor
        campusButton.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        campusButton.dimsWhenPressed = true
        campusButton.shadowOpacity = 0.2
        
        
        if onDefaultRegion {
            campusButton.opacity = 0
        } else {
            campusButton.opacity = 1
        }
        
        
        campusButton.updateAllUI()
        
    }
    
    private func positionCampusButton () {
        
        var newFrame = CGRectZero
        
        newFrame.size.width = width * widthOfCampusButton
        newFrame.size.height = width * heightOfCampusButton
        
        newFrame.origin.x = (width - newFrame.size.width)/2
        newFrame.origin.y = height - newFrame.size.height - (width * bottomBufferForCampusButton)
        
        campusButton.frame = newFrame
        
    }
    
    
    
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK: Debug
    private func printRegion (region: MKCoordinateRegion) {
        
        print("(\(region.center.latitude), \(region.center.longitude), \(region.span.latitudeDelta), \(region.span.longitudeDelta)")
        
    }
    
    // MARK: Map Region
    private func goToCampus (animated: Bool) {
        mapView.setCenterCoordinate(defaultCenter, animated: animated)
    }
    
    private func zoomToCampus (animated: Bool) {
        mapView.setRegion(defaultRegion, animated: animated)
        onDefaultRegion = true
        animatedUpdate()
    }
    
    private func regionIsOutOfBounds () -> Bool {
        
        let acceptableRadius = 0.3
        
        let leftSideOfCurrentRegion = mapView.region.center.longitude - mapView.region.span.longitudeDelta/2
        let rightSideOfCurrentRegion = mapView.region.center.longitude + mapView.region.span.longitudeDelta/2
        
        let topSideOfCurrentRegion = mapView.region.center.latitude + mapView.region.span.latitudeDelta/2
        let bottomSideOfCurrentRegion = mapView.region.center.latitude - mapView.region.span.latitudeDelta/2
        
        if leftSideOfCurrentRegion < (defaultRegion.center.longitude - acceptableRadius) {
            return true
        }
        
        if rightSideOfCurrentRegion > (defaultRegion.center.longitude + acceptableRadius) {
            return true
        }
        
        if topSideOfCurrentRegion > (defaultRegion.center.latitude + acceptableRadius) {
            return true
        }
        
        if bottomSideOfCurrentRegion < (defaultRegion.center.latitude - acceptableRadius) {
            return true
        }
        
        
        
        return false
    }
    
    
    
    
    // MARK: Buttons
    private func backButtonPressed () {
        delegate?.mapBackButtonWasPressed(self)
    }
    
    private func campusButtonPressed () {
        zoomToCampus(true)
    }
    
    
    
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
    // MARK: Map View
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(ShuttleStop.self) {
            let stop = annotation as! ShuttleStop
            if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("ShuttleStopIconAnnotationView") {
                
                return annotationView
            }
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ShuttleStopIconAnnotationView")
            annotationView.canShowCallout = true
            annotationView.image = stop.icon
            
            return annotationView
        }
        
        return MKAnnotationView()
    }
    
    public func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        onDefaultRegion = false
        animatedUpdate()
        
    }
    
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if regionIsOutOfBounds() {
            goToCampus(true)
        }
        
    }
    
    
    
    
    // MARK: Touchable View
    public func touchableViewTouchDidBegin(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    public func touchableViewTouchDidChange(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.mapBackPanTouchCoverWasDragged(self, distance: xDistance, velocity: xVelocity)
        
    }
    
    public func touchableViewTouchDidEnd(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.mapBackPanTouchCoverWasReleased(self, velocity: xVelocity)
        
    }
    
    public func touchableViewTouchDidCancel(touchableView: JABTouchableView, gestureRecognizer: UIGestureRecognizer, xDistance: CGFloat, yDistance: CGFloat, xVelocity: CGFloat, yVelocity: CGFloat, methodCallNumber: Int) {
        
        delegate?.mapBackPanTouchCoverWasReleased(self, velocity: xVelocity)
        
    }
    
    
    // MARK: Button
    public func buttonWasTouched(button: JABButton) {
        
    }
    
    public func buttonWasUntouched(button: JABButton, triggered: Bool) {
        
        if triggered {
            switch button {
            case backButton:
                backButtonPressed()
            case campusButton:
                campusButtonPressed()
            default:
                print("Hit default when switching over button in Map.buttonWasUntouched:")
            }
        }
        
    }
    
    
}




public protocol MapDelegate {
    
    func mapBackPanTouchCoverWasDragged (map: Map, distance: CGFloat, velocity: CGFloat)
    func mapBackPanTouchCoverWasReleased (map: Map, velocity: CGFloat)
    
    func mapBackButtonWasPressed (map: Map)
    
}
