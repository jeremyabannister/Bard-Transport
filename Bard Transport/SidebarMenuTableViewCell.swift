//
//  SidebarMenuTableViewCell.swift
//  Bard Transport
//
//  Created by Jeremy Bannister on 8/23/15.
//  Copyright (c) 2015 Jeremy Alexander Bannister. All rights reserved.
//

import UIKit
import JABSwiftCore

public class SidebarMenuTableViewCell: UITableViewCell, GlobalVariablesInitializationNotificationSubscriber {
    
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
    public var menuItem = SidebarMenuItem() {
        didSet {
            updateAllUI()
        }
    }
    
    // MARK: UI
    private let label = UILabel()
    
    
    // MARK: Parameters
    // Most parameters are expressed as a fraction of the width of the view. This is done so that if the view is animated to a different frame the subviews will adjust accordingly, which would not happen if all spacing was defined statically
    private var leftBufferForLabel = CGFloat(0)
    
    
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
        
        leftBufferForLabel = 0.05
        
        if iPad {
            
        }
    }
    
    
    
    
    // MARK:
    // MARK: UI
    // MARK:
    
    // MARK: All
    public func addAllUI () {
        
        addLabel()
        
    }
    
    public func updateAllUI () {
        
        updateParameters()
        
        
        configureLabel()
        positionLabel()
        
    }
    
    
    
    
    // MARK: Adding
    private func addLabel () {
        addSubview(label)
    }
    
    
    // MARK: Label
    private func configureLabel () {
        
        label.text = menuItem.title
        label.textAlignment = NSTextAlignment.Center
        label.textColor = blackColor
        label.font = UIFont(name: "Avenir", size: 16)
        
    }
    
    private func positionLabel () {
        if let text = label.text {
            var newFrame = CGRectZero
            let size = label.font.sizeOfString(text, constrainedToWidth: 0)
            
            newFrame.size.width = size.width
            newFrame.size.height = size.height
            
            newFrame.origin.x = width * leftBufferForLabel
            newFrame.origin.y = (height - newFrame.size.height)/2
            
            label.frame = newFrame
        }
    }
    
}
