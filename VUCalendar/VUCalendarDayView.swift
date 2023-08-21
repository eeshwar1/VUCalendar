//
//  VUCalendarDayView.swift
//  VUCalendar
//
//  Created by Venkateswaran Venkatakrishnan on 8/19/23.
//

import Cocoa

class VUCalendarDayView: NSView {
    
    var value: String = "0"
    
    var highlightBackgroundColor: NSColor?
    
    var highlightBorderColor: NSColor?
    
    var highlighted: Bool? {
        
        didSet {
            
            self.setNeedsDisplay(self.bounds)
        }
    }

    
    fileprivate var trackingArea: NSTrackingArea?
    
    init(frame frameRect: NSRect, value: String) {
        
        super.init(frame: frameRect)
        
        self.value = value
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        
       
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 18)
        ]

        
        let text = NSAttributedString(string: value, attributes: attributes)
        
        let dateLabel = NSTextField(labelWithAttributedString: text)
        dateLabel.alignment = .center
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(dateLabel)
        
        let centerXConstraint = NSLayoutConstraint(item: dateLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: dateLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        
        self.addConstraint(centerXConstraint)
        self.addConstraint(centerYConstraint)
        
        
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        // Circle selection
       let width = self.bounds.height * 0.9
       let height = self.bounds.height * 0.9
       let pathFrame = CGRect(x: (self.bounds.width - width)/2.0, y: (self.bounds.height - height)/2.0, width: width, height: height);
       let path = NSBezierPath(ovalIn: pathFrame)
        
        // print("highlighted: \(String(describing: self.highlighted))")
        if self.highlighted == true {
             
            // print("highlighted")
            
            if let color = self.highlightBorderColor {
                
                color.setStroke()
                path.stroke()
            } else {
                
                NSColor.red.setStroke()
                path.stroke()
            }
            
            if let color = self.highlightBackgroundColor {
                
                color.setFill()
                path.fill()
            } else {
                
                NSColor.lightGray.setFill()
                path.fill()
            }
           
            
           
        }
        
    }
    
    override open func updateTrackingAreas() {
          if self.trackingArea != nil {
              self.removeTrackingArea(self.trackingArea!)
          }
          let opts: NSTrackingArea.Options = [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways]
          self.trackingArea = NSTrackingArea(rect: self.bounds, options: opts, owner: self, userInfo: nil)
          self.addTrackingArea(self.trackingArea!)
          
    }
    
    override open func mouseEntered(with theEvent: NSEvent) {
       
        // print("mouse entered")
        self.highlighted = true
       
        
    }
    
    override open func mouseExited(with theEvent: NSEvent) {
        
        // print("mouse exited")
        self.highlighted = false
        
    }
    
}

