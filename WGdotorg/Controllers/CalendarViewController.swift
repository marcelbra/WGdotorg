//
//  CalendarViewController.swift
//  WGdotorg
//
//  Created by Marcel Braasch on 11.04.20.
//  Copyright © 2020 Marcel Braasch. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarViewController: UIViewController {
    
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    let formatter = DateFormatter()
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
       guard let cell = view as? DateCell  else { return }
       cell.dateLabel.text = cellState.text
       handleCellTextColor(cell: cell, cellState: cellState)
    }
        
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
       if cellState.dateBelongsTo == .thisMonth {
          cell.dateLabel.textColor = UIColor.white
       } else {
          cell.dateLabel.textColor = UIColor.lightGray
       }
    }
    
    func setYearMonthLabels() {
        calendarView.visibleDates() { visibleDates in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "yyyy"
            self.YearLabel.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "MMMM"
            self.MonthLabel.text = self.formatter.string(from: date)
        }
    }
    
    
    @IBAction func didTapToday(_ sender: UIBarButtonItem) {
        calendarView.scrollToDate(Date())
    }
    
    
    @IBAction func didTapAddTask(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        setYearMonthLabels()
        calendarView.scrollToDate(Date(),animateScroll: false)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let before = DateComponents(year: -10)
        let after = DateComponents(year: 10)
        let startDate = Calendar.current.date(byAdding: before, to: Date())!
        let endDate = Calendar.current.date(byAdding: after, to: Date())!
        return ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: .monday)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
       return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
       configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setYearMonthLabels()
    }
}
