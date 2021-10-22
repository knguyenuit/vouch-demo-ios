//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
enum MyTheme {
    case light
    case dark
}


struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = AppColor.primary
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = AppColor.primary
    static var monthViewBtnRightColor = AppColor.primary
    static var monthViewBtnLeftColor = AppColor.primary
    static var activeCellLblColor = UIColor.white
    static var activeCellLblColorHighlighted = UIColor.black
    static var weekdaysLblColor = UIColor(hexString: "#B9B9B9")
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    var delegate: CalenderDelegate?
    fileprivate var numOfDaysInMonth: Int = 0
    fileprivate var currentMonthIndex: Int = 0
    fileprivate var currentYear: Int = 0
    fileprivate var todaysDate = 0
    fileprivate var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var height: CGFloat = 0.0
    fileprivate var currentDate: Date = Date()
    fileprivate var listDate: [Date] = []
    fileprivate var selectedDate: String = ""
    private var datesRange: [[String]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
        
        initializeView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if myCollectionView.collectionViewLayout.collectionViewContentSize.height == 0 {
            return
        }
        myCollectionView.heightAnchor.constraint(equalToConstant: myCollectionView.collectionViewLayout.collectionViewContentSize.height).isActive = true
        height = myCollectionView.collectionViewLayout.collectionViewContentSize.height + monthView.frame.height + weekdaysView.frame.height
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        currentDate = Date()
        firstWeekDayOfMonth = getFirstWeekDay()
        selectedDate = currentDate.getString(format: "yyyy-MM-dd")
        numOfDaysInMonth = currentDate.getDayOfMonth()!
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(DateCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.reloadData()
    }
    
    func updateSelectedDate(_ date: Date) {
        selectedDate = date.getString(format: "yyyy-MM-dd")
        myCollectionView.reloadData()
    }
    
    func setDateRange(date: [[String]]) {
        self.datesRange = date
    }
    
    private func convertDateType(day: Int, month: Int, year: Int) -> DateType {
        let resultDay = day < 10 ? "0\(day)" : "\(day)"
        let resultMonth = month < 10 ? "0\(month)" : "\(month)"
        let currentDate = "\(year)-\(resultMonth)-\(resultDay)"
        return Date().getString(form: "yyyy-MM-dd") == currentDate ? .current : selectedDate == currentDate ? .selected : .none
    }
    
    private func getDateString(day: Int, month: Int, year: Int) -> String {
        let resultDay = day < 10 ? "0\(day)" : "\(day)"
        let resultMonth = month < 10 ? "0\(month)" : "\(month)"
        let currentDate = "\(year)-\(resultMonth)-\(resultDay)"
        return currentDate
    }
    
    private func getDateShow(day: Int, month: Int, year: Int) -> String {
        let resultDay = day < 10 ? "0\(day)" : "\(day)"
        let resultMonth = month < 10 ? "0\(month)" : "\(month)"
        let currentDate = "\(resultDay)/\(resultMonth)/\(year)"
        return currentDate
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCVCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.dateLbl.text="\(calcDate)"
            cell.configure(type: convertDateType(day: calcDate, month: currentMonthIndex, year: currentYear))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let calcDate = indexPath.row - firstWeekDayOfMonth + 2
        if getDateString(day: calcDate, month: currentMonthIndex, year: currentYear) != selectedDate {
            selectedDate = getDateString(day: calcDate, month: currentMonthIndex, year: currentYear)
            myCollectionView.reloadData()
            delegate?.didTapDate(date: getDateShow(day: calcDate, month: currentMonthIndex, year: currentYear),
                                 dateShow: Date.convertUTCToLocal(dateString: selectedDate).getString(form: "EEEE, d MMM yyyy"))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func getFirstWeekDay(date: Date = Date()) -> Int {
        currentDate = date
        let dateStart = date.startOfMonth
        let strDate = dateStart.getString(form: "EEE")
        guard let day = DayOfWeek.allCases.first(where: { $0.dayString == strDate.uppercased() }) else { return 7 }
        return day.rawValue
    }
    
    func didChangeMonth(monthIndex: Int, year: Int, isNext: Bool) {
        currentMonthIndex = monthIndex
        currentYear = year
        firstWeekDayOfMonth = getFirstWeekDay(date: isNext ? currentDate.getNextMonth()! : currentDate.getPreviousMonth()!)
        numOfDaysInMonth = currentDate.getDayOfMonth()!
        myCollectionView.reloadData()
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 5).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let monthView: MonthView = {
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Style.themeLight()
        initializeView()
    }
}

protocol CalenderDelegate {
    func didTapDate(date: String, dateShow: String)
}

enum DateType {
    case none, current, selected
}

class DateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.masksToBounds = true
        setupViews()
    }
    
    func setupViews() {
        addSubview(dateLbl)
        addSubview(bottomView)
        
        dateLbl.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dateLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        dateLbl.layer.cornerRadius = 15
        dateLbl.clipsToBounds = true
        
        bottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        bottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
    
    let dateLbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomView: UIView = {
        let leftView = UIView()
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.backgroundColor = .blue
        return leftView
    }()
    
    func configure(type: DateType) {
        dateLbl.backgroundColor = type == .selected ? AppColor.secondPrimary : .white
//        dateLbl.layer.borderWidth = type == .first ? 0.5 : 0
//        dateLbl.layer.borderColor = type == .first ? AppColor.primary?.cgColor : UIColor.clear.cgColor
        dateLbl.textColor = type == .none ? .black : .blue
        bottomView.isHidden = type == .none || type == .selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}













