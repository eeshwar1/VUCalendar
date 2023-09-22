//
//  ViewController.swift
//  VUCalendar
//
//  Created by Venkateswaran Venkatakrishnan on 8/19/23.
//

import Cocoa

class ViewController: NSViewController {
    
    var calendarView: VUCalendarView!
    @IBOutlet var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    override func awakeFromNib() {
        
        statusItem.menu = statusMenu
        
        let icon = NSImage(systemSymbolName: "calendar", accessibilityDescription: "calendar")
        
        statusItem.button?.image = icon
        
        let calendarMenuItem = statusMenu.item(withTitle: "CalendarView")
        
        self.calendarView = VUCalendarView(frame: NSMakeRect(0, 0, 300, 300))
        setupCalendarView()
        
        calendarMenuItem!.view = self.calendarView
        
    }


    func setupCalendarView() {
        
        calendarView.autoresizingMask = NSView.AutoresizingMask.minYMargin
        
        // Background color, font size
        calendarView.backgroundColor = NSColor.clear
        calendarView.font = NSFont.systemFont(ofSize: 14.0)
        calendarView.titleFont = NSFont.boldSystemFont(ofSize: 16.0)
        
        // Text color
        calendarView.textColor = NSColor.textColor
        calendarView.todayTextColor = NSColor.red
        calendarView.selectedTextColor = NSColor.white

        // Markers
        calendarView.markColor = NSColor.darkGray
        calendarView.todayMarkColor = NSColor.red
        calendarView.selectedMarkColor = NSColor.white

        // Today
        calendarView.todayBackgroundColor = NSColor.red
        calendarView.todayBorderColor = NSColor.red
        
        // Selection
        calendarView.selectedBackgroundColor = NSColor.lightGray
        calendarView.selectedBorderColor = NSColor.lightGray
        
        // Next & previous month days
        calendarView.nextMonthTextColor = NSColor.gray
        calendarView.previousMonthTextColor = NSColor.gray;

        // 'Mouse-over' highlight
        calendarView.highlightedBackgroundColor = NSColor.highlightColor
        calendarView.highlightedBorderColor = NSColor.highlightColor
    
        calendarView.setNeedsDisplay(calendarView.bounds)
       
    }
    
  
}

