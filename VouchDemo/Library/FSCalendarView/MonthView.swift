//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int, isNext: Bool)
}

class MonthView: UIView {
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var currentDate: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        currentDate = Calendar.current.component(.day, from: Date())
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        setupViews()
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        var isNext: Bool = false
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 12 {
                currentMonthIndex = 1
                currentYear += 1
            }
            isNext = true
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 1 {
                currentMonthIndex = 12
                currentYear -= 1
            }
            isNext = false
        }
        lblName.text = Date.convertUTCToLocal(dateString: "\(currentYear)-\(currentMonthIndex)-\(currentDate)").getString(form: "MMMM")
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear, isNext: isNext)
    }
    
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        lblName.text = Date.convertUTCToLocal(dateString: "\(currentYear)-\(currentMonthIndex)-\(currentDate)").getString(form: "MMMM")
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive=true
        btnRight.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnRight.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        btnLeft.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnLeft.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
    }
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"ic_arrow_right"), for: UIControl.State.normal)
        btn.imageView?.tintColor = UIColor.black
        btn.imageView?.contentMode = .scaleToFill
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"ic_arrow_left"), for: .normal)
        btn.imageView?.tintColor = UIColor.black
        btn.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

