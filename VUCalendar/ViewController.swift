//
//  ViewController.swift
//  VUCalendar
//
//  Created by Venkateswaran Venkatakrishnan on 8/19/23.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var calendarView: VUCalendarView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        setupCalendarView()
    }

    func setupCalendarView() {
        
//        print("setupCalendarView")
        calendarView.autoresizingMask = NSView.AutoresizingMask.minYMargin
        
        // Background color, font size
        calendarView.backgroundColor = NSColor.white
        calendarView.font = NSFont.systemFont(ofSize: 24.0)
        calendarView.titleFont = NSFont.boldSystemFont(ofSize: 36.0)
        
        // Text color
        calendarView.textColor = NSColor.black
        calendarView.todayTextColor = NSColor.red
        calendarView.selectedTextColor = NSColor.white
//
//        // Markers
        calendarView.markColor = NSColor.darkGray
        calendarView.todayMarkColor = NSColor.red
        calendarView.selectedMarkColor = NSColor.white
//
//        // Today
        calendarView.todayBackgroundColor = NSColor.red
        calendarView.todayBorderColor = NSColor.red
        
        // Selection
        calendarView.selectedBackgroundColor = NSColor.lightGray
        calendarView.selectedBorderColor = NSColor.lightGray
        
//        // Next & previous month days
        calendarView.nextMonthTextColor = NSColor.gray
        calendarView.previousMonthTextColor = NSColor.gray;

        // 'Mouse-over' highlight
        calendarView.highlightedBackgroundColor = NSColor(white: 0.95, alpha: 1.0)
        calendarView.highlightedBorderColor = NSColor(white: 0.95, alpha: 1.0)
    
        calendarView.setNeedsDisplay(calendarView.bounds)
       
    }
    
  
}

