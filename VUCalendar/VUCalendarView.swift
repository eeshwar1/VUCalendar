//
//  VUCalendarView.swift
//  VUCalendar
//
//  Created by Venkateswaran Venkatakrishnan on 8/19/23.
//

import Cocoa

class VUCalendarView: NSView {
    
    fileprivate var calendar = Calendar.current
    fileprivate let dateUnitMask: NSCalendar.Unit =  [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekday]
    
    fileprivate var dateFormatter: DateFormatter?
    
    override open var isFlipped: Bool { return true }
    
    fileprivate(set) open var monthButton: NSButton!
    fileprivate(set) open var monthBackButton: NSButton!
    fileprivate(set) open var monthForwardButton: NSButton!
    
    fileprivate var currentHeight: Int
    fileprivate var lineHeight: CGFloat
    
    fileprivate var firstDayComponents: DateComponents!
    
    
    @objc open var todayTextColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var backgroundColor: NSColor? {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    @objc open var titleFont: NSFont {
        didSet {
            configureViewAppearance()
        }
    }
    
    fileprivate func configureViewAppearance() {
        
        self.monthButton.font = self.titleFont
        
        for weekdayLabel in self.weekdayLabels {
            
            updateWeekDayLabel(weekdayLabel: weekdayLabel)
            let currentFrame = weekdayLabel.frame
            weekdayLabel.frame = NSMakeRect(currentFrame.minX, currentFrame.minY, currentFrame.width, self.lineHeight * 1.5)
        }
    }
    
    @objc open var font: NSFont {
        didSet {
            self.lineHeight = VUCalendarView.lineHeightForFont(font)
            configureViewAppearance()
        }
    }
    
    @objc open var textColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var selectedTextColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var selectedBackgroundColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var selectedBorderColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var highlightedBackgroundColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var highlightedBorderColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var todayBackgroundColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var todayBorderColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var nextMonthTextColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var previousMonthTextColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    @objc open var markColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var todayMarkColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    @objc open var selectedMarkColor: NSColor? {
        didSet {
            updateDaysView()
        }
    }
    
    open class func lineHeightForFont(_ font: NSFont) -> CGFloat {
        let attribs = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let size = "Aa".size(withAttributes: attribs as? [NSAttributedString.Key: Any])
        return round(size.height)
    }
    
    var date = Date()
    var dayViews: [VUCalendarDayView] = []
    
    fileprivate var weekdays: [String] = []
    fileprivate var weekdayLabels: [NSTextField] = []
    
    let firstDayOfWeek = 1 // '1' - Sunday, '2' - Monday
    
    override public init(frame frameRect: NSRect) {
        
        self.currentHeight = 0
        self.font = NSFont.systemFont(ofSize: 24.0)
        self.lineHeight = VUCalendarView.lineHeightForFont(self.font)
        self.titleFont = NSFont.boldSystemFont(ofSize: 36.0)
        self.monthButton = NSButton(frame: NSZeroRect)
        
        super.init(frame: frameRect)
        
        setupVariables()
        
        setupSubViews()
        
    }
    
    
    required init?(coder: NSCoder) {
        
        self.currentHeight = 0
        self.font = NSFont.systemFont(ofSize: 24.0)
        self.lineHeight = VUCalendarView.lineHeightForFont(self.font)
        self.titleFont = NSFont.boldSystemFont(ofSize: 36.0)
        self.monthButton = NSButton(frame: NSZeroRect)
        
        super.init(coder: coder)
        
        setupVariables()
        
        setupSubViews()
        
        
    }
    
    
    func setupSubViews() {
        
        self.currentHeight = 0
        self.font = NSFont.systemFont(ofSize: 12.0)
        self.lineHeight = VUCalendarView.lineHeightForFont(self.font)
        
        configureDateFormatter()
        
        configureWeekdays()
        
        setupTitleRow()
        
        updateDaysView()
        
        
    }
    
    func setupVariables() {
        
        self.firstDayComponents = firstDayOfMonthForDate(self.date)
        
    }
    
    func setupTitleRow() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let monthlyTitleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: self.titleFont,
            .paragraphStyle: paragraphStyle
        ]
        
        let monthButtonTitle = NSAttributedString(string: monthAndYearForDay(firstDayOfMonthForDate(self.date)), attributes: monthlyTitleAttributes)
        
        let margin: CGFloat = 60
        
        self.monthButton = NSButton(frame: NSMakeRect(margin, 0, self.bounds.size.width - 2 * margin, 50))
        
        self.monthButton.cell?.truncatesLastVisibleLine = true
        self.monthButton.cell?.lineBreakMode = .byTruncatingTail
        self.monthButton.bezelStyle = .regularSquare
        self.monthButton.attributedTitle = monthButtonTitle
        self.monthButton.target = self
        self.monthButton.action = #selector(self.showToday(_:))
        self.addSubview(monthButton)
        
        self.monthBackButton = NSButton(frame: NSZeroRect)
        self.monthForwardButton = NSButton(frame: NSZeroRect)
        
        self.monthBackButton.frame = NSMakeRect(0, 0, 50, 50)
        self.monthForwardButton.frame = NSMakeRect(self.bounds.size.width - 50, 0, 50, 50)
        
        self.monthBackButton.title = "<"
        self.monthBackButton.alignment = NSTextAlignment.center
        let backBtnCell = self.monthBackButton.cell as! NSButtonCell
        backBtnCell.bezelStyle = NSButton.BezelStyle.regularSquare
        backBtnCell.font = NSFont.systemFont(ofSize: 20)
        self.monthBackButton.target = self
        self.monthBackButton.action = #selector(self.monthBackAction(_:))
        self.addSubview(self.monthBackButton)
        
        self.monthForwardButton.title = ">"
        self.monthForwardButton.alignment = NSTextAlignment.center
        let forwardBtnCell = self.monthForwardButton.cell as! NSButtonCell
        forwardBtnCell.bezelStyle = NSButton.BezelStyle.regularSquare
        forwardBtnCell.font = NSFont.systemFont(ofSize: 20)
        self.monthForwardButton.target = self
        self.monthForwardButton.action = #selector(self.monthForwardAction(_:))
        self.addSubview(self.monthForwardButton)
        
        // weekdays
        
        let weekdayLabelAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: NSFont.boldSystemFont(ofSize: self.font.pointSize),
            .paragraphStyle: paragraphStyle
        ]
        
        
        for weekdayLabel in self.weekdayLabels {
            weekdayLabel.removeFromSuperview()
        }
        self.weekdayLabels.removeAll(keepingCapacity: true)
        
        let labelWidth = floor(self.bounds.size.width / 7)
        var currentX = CGFloat(0.0)
        let currentY =  CGFloat(NSMaxY(self.monthButton.frame) + 5.0)
        
        for i in 0 ..< 7 {
            
            let weekday = weekdayNameForColumn(i)
            let weekdayLabel = NSTextField(frame: NSZeroRect)
            weekdayLabel.frame = NSMakeRect(currentX, currentY, labelWidth, currentY + self.lineHeight)
            
            weekdayLabel.font = self.font
            weekdayLabel.textColor = self.textColor
            weekdayLabel.isEditable = false
            weekdayLabel.backgroundColor = NSColor.clear
            weekdayLabel.isBordered = false
            weekdayLabel.alignment = NSTextAlignment.center
            
            let weekDayAttributedString = NSAttributedString(string: weekday, attributes: weekdayLabelAttributes)
            
            weekdayLabel.attributedStringValue = weekDayAttributedString
            
            self.weekdayLabels.append(weekdayLabel)
            self.addSubview(weekdayLabel)
            
            currentX += labelWidth
        }
        
        
    }
    
    @objc open func monthForwardAction(_ sender: NSButton?) {
        
        self.firstDayComponents = oneMonthLaterDayForDay(self.firstDayComponents)
        updateCurrentMonthButton()
        updateDaysView()
        
    }
    
    @objc open func monthBackAction(_ sender: NSButton?) {
        
        self.firstDayComponents = oneMonthEarlierDayForDay(self.firstDayComponents)
        updateCurrentMonthButton()
        updateDaysView()
    }
    
    @objc open func showToday(_ sender: NSButton?) {
        
        displayViewForDate(Date())
    }
    
    @objc open func displayViewForDate(_ date: Date) {
        
        self.firstDayComponents = firstDayOfMonthForDate(date)
        self.date = date
        updateCurrentMonthButton()
        updateDaysView()
        
    }
    
    fileprivate func updateCurrentMonthButton() {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let monthlyLabelAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: self.titleFont,
            .paragraphStyle: paragraphStyle
        ]
        
        let monthLabelText = NSAttributedString(string: monthAndYearForDay(self.firstDayComponents), attributes: monthlyLabelAttributes)
        
        self.monthButton.attributedTitle = monthLabelText
        
        self.needsDisplay = true
        
    }
    
    fileprivate func updateWeekDayLabel(weekdayLabel: NSTextField) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let weekdayLabelAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: NSFont.boldSystemFont(ofSize: self.font.pointSize),
            .paragraphStyle: paragraphStyle
        ]
        
        let weekdayLabelText = NSAttributedString(string: weekdayLabel.attributedStringValue.string, attributes: weekdayLabelAttributes)
        
        weekdayLabel.attributedStringValue = weekdayLabelText
        
        self.needsDisplay = true
        
    }

    
    func updateDaysView() {
        
        for dayView in self.dayViews {
            
            dayView.removeFromSuperview()
            
        }
        self.dayViews.removeAll(keepingCapacity: true)
        
        let viewWidth: CGFloat = floor(self.bounds.size.width/7)
        let viewHeight: CGFloat = viewWidth
        
        var col : CGFloat = 0
        
        var _date = self.firstDayComponents!
        var originX = self.bounds.minX
        var originY = NSMaxY(self.monthButton.frame) + 2 * lineHeight
        var nextLine = false
        
        for _ in 1...daysCountInMonthForDay(self.firstDayComponents) {
            
            if nextLine == true {
                
                nextLine = false
                originY += viewHeight
            }
            col = CGFloat(columnForWeekday(_date.weekday!))
//            print("column for \(_date) is \(col)")
            originX = viewWidth * col
          
            let dayView = VUCalendarDayView(frame: NSMakeRect(originX, originY, viewWidth, viewHeight), value: String(_date.day!))
        
            dayView.highlightedBackgroundColor = self.highlightedBackgroundColor
            dayView.highlightedBorderColor = self.highlightedBorderColor
            
            if VUCalendarView.isEqualDay(_date, anotherDate: Date()) {
                
                dayView.textColor = self.todayTextColor
            }
            self.dayViews.append(dayView)
            
            self.addSubview(dayView)
            
            _date = dayByAddingDays(1, fromDate: _date)
            
            if (col == 6) {
                
                originX = 0
                nextLine = true
            
            } else {

                originX += viewWidth
            }
            
        }
        
        
    }
    override func draw(_ dirtyRect: NSRect) {
        
        
        if let color = self.backgroundColor {
            color.setFill()
            dirtyRect.fill()
        }
        
        super.draw(dirtyRect)
        
    }
    
    
    fileprivate func daysCountInMonthForDay(_ dateComponents: DateComponents) -> Int {
        let date = self.calendar.date(from: dateComponents)!
        let days = (self.calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return days.length
    }
    
    fileprivate func firstDayOfMonthForDate(_ date: Date) -> DateComponents {
        
        var dateComponents = (self.calendar as NSCalendar).components(self.dateUnitMask, from: date)
        let weekday = dateComponents.weekday!
        let day = dateComponents.day!
        let weekOffset = day % 7
        
        dateComponents.day = 1
        dateComponents.weekday = weekday - weekOffset + 1
        if dateComponents.weekday! < 0 {
            dateComponents.weekday! += 7
        }
        
        return dateComponents
    }
    
    fileprivate func monthAndYearForDay(_ dateComponents: DateComponents) -> String {
        let year = dateComponents.year
        let month = dateComponents.month
        let months = self.dateFormatter!.standaloneMonthSymbols
        
        if let _year = year, let _month = month, let _months = months {
            let monthSymbol = _months[_month-1]
            return "\(monthSymbol) \(_year)"
        } else {
            return "--"
        }
    }
    
    fileprivate func configureDateFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        self.dateFormatter = dateFormatter
    }
    
    fileprivate func configureWeekdays() {
        
        if  let dateFormatter = self.dateFormatter {
            dateFormatter.dateFormat = "EEEEE"
            let oneDayInterval = TimeInterval(60*60*24)
            let now = Date()
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let components = (calendar as NSCalendar?)?.components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: now)
            var dayComponents = DateComponents()
            dayComponents.hour = 12
            dayComponents.weekday = 1
            dayComponents.weekdayOrdinal = 1
            dayComponents.month = (components?.month)!
            dayComponents.year = (components?.year)!
            
            var day = calendar.date(from: dayComponents)
            
            for _ in 0 ..< 7 {
                let daySymbol = dateFormatter.string(from: day!)
                self.weekdays.append(daySymbol)
                day = day?.addingTimeInterval(oneDayInterval)
            }
            
        }
        
//        print("\(self.weekdays)")
    }
    
    fileprivate func weekdayNameForColumn(_ column: Int) -> String {
        var index = column + self.firstDayOfWeek - 1
        if index >= 7 { index -= 7 }
        return self.weekdays[index]
    }
    
    fileprivate func columnForWeekday(_ weekday: Int) -> Int {
        var column = weekday - self.firstDayOfWeek
        if column < 0 { column += 7 }
        return column
    }
    
    fileprivate func dayByAddingDays(_ days: Int, fromDate anotherDate: DateComponents) -> DateComponents {
        
        var dateComponents = DateComponents()
        
        dateComponents.day = anotherDate.day! + days
        dateComponents.month = anotherDate.month
        dateComponents.year = anotherDate.year
        
        let day = self.calendar.date(from: dateComponents)!
        return (self.calendar as NSCalendar).components(self.dateUnitMask, from: day)
    }
    
    fileprivate func oneMonthLaterDayForDay(_ dateComponents: DateComponents) -> DateComponents {
        var newDateComponents = DateComponents()
        newDateComponents.day = dateComponents.day
        newDateComponents.month = dateComponents.month! + 1
        newDateComponents.year = dateComponents.year
        let oneMonthLaterDay = self.calendar.date(from: newDateComponents)!
        return (self.calendar as NSCalendar).components(self.dateUnitMask, from: oneMonthLaterDay)
    }
    
    fileprivate func oneMonthEarlierDayForDay(_ dateComponents: DateComponents) -> DateComponents {
        var newDateComponents = DateComponents()
        newDateComponents.day = dateComponents.day
        newDateComponents.month = dateComponents.month! - 1
        newDateComponents.year = dateComponents.year
        let oneMonthLaterDay = self.calendar.date(from: newDateComponents)!
        return (self.calendar as NSCalendar).components(self.dateUnitMask, from: oneMonthLaterDay)
    }
    
    class func isEqualDay(_ dateComponents: DateComponents, anotherDate: Date) -> Bool {
        let calendar = Calendar.current
        let anotherDateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from:anotherDate)
        
        if dateComponents.day == anotherDateComponents.day && dateComponents.month == anotherDateComponents.month
            && dateComponents.year == anotherDateComponents.year {
            return true
        } else {
            return false
        }
    }
    
}

