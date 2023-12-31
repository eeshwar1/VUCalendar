//
//  VUCalendarDayView.swift
//  VUCalendar
//
//  Created by Venkateswaran Venkatakrishnan on 8/19/23.
//

import Cocoa

class VUCalendarDayView: NSView {
    
    var value: String = "0"
    
    public let dateComponents: DateComponents
    
    var highlightedBackgroundColor: NSColor?
    
    var highlightedBorderColor: NSColor?
    
    fileprivate var dateLabel: NSTextField!
    fileprivate var lineHeight: CGFloat
    
    var highlighted: Bool? {
        
        didSet {
            
            self.setNeedsDisplay(self.bounds)
        }
    }

    open var font: NSFont {
          didSet {
              self.dateLabel.font = font
              self.lineHeight = VUCalendarView.lineHeightForFont(self.font)
          }
      }
    
    open var textColor: NSColor? {
           didSet {
               self.dateLabel.textColor = textColor
           }
    }
    
    fileprivate var trackingArea: NSTrackingArea?
    
    
    init(dateComponents: DateComponents) {
        
        self.font = NSFont.systemFont(ofSize: 14.0)
        self.lineHeight = VUCalendarView.lineHeightForFont(self.font)
        
        self.dateComponents = dateComponents
            
        super.init(frame: NSZeroRect)
        
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
       
        let attributes: [NSAttributedString.Key: Any] = [
            .font: self.font
        ]

        let text = NSAttributedString(string: "\(self.dateComponents.day!)", attributes: attributes)
        
        let dateLabel = NSTextField(labelWithAttributedString: text)
        dateLabel.alignment = .center
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.dateLabel = dateLabel
        
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
        
  
       if self.highlighted == true {

            if let color = self.highlightedBorderColor {
                
                color.setStroke()
                path.stroke()
            }

            
            if let color = self.highlightedBackgroundColor {
                
                color.setFill()
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

        self.highlighted = true
       
        
    }
    
    override open func mouseExited(with theEvent: NSEvent) {
        
        self.highlighted = false
        
    }
    
}

