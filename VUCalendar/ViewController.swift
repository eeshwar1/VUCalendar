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

        self.calendarView = VUCalendarView()
        self.calendarView.highlightBorderColor = NSColor.purple
        self.calendarView.highlightBackgroundColor = NSColor.blue
    }

  
}

