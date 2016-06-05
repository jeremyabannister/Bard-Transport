//
//  SidebarItem.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/22/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class SidebarItem: JABView {
    
    // MARK:
    // MARK: Properties
    // MARK:
    
    // MARK: Delegate
    
    // MARK: State
    public var heightToWidthRatio = CGFloat(1.0)
    
    // MARK: UI
    private let blurLayer = UIVisualEffectView()
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    
    
    
    
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
        
        
        if iPad {
            
        }
        
    }
    
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    
    // MARK: All
    override public func addAllUI() {
        
        addBlurLayer()
        
    }
    
    override public func updateAllUI() {
        
        updateParameters()
        
        
        configureBlurLayer()
        positionBlurLayer()
        
    }
    
    
    // MARK: Adding
    private func addBlurLayer () {
        addSubview(blurLayer)
    }
    
    
    
    // MARK: Blur Layer
    private func configureBlurLayer () {
        
        blurLayer.effect = UIBlurEffect(style: .ExtraLight)
        
    }
    
    private func positionBlurLayer () {
        blurLayer.frame = bounds
    }
    
    
    // MARK:
    // MARK: Actions
    // MARK:
    
    
    // MARK:
    // MARK: Delegate Methods
    // MARK:
    
}
