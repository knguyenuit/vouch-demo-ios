//
//  WeekdaysView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
enum DayOfWeek: Int, CaseIterable {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
    var dayString: String {
        switch self {
        case .Sunday: return "SUN"
        case .Monday: return "MON"
        case .Tuesday: return "TUE"
        case .Wednesday: return "WED"
        case .Thursday: return "THU"
        case .Friday: return "FRI"
        case .Saturday: return "SAT"
        }
    }
}


class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        for day in DayOfWeek.allCases {
            let lbl = UILabel()
            lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            lbl.text = day.dayString
            lbl.textAlignment = .center
            lbl.textColor = AppColor.borderView
            myStackView.addArrangedSubview(lbl)
        }
    }
    
    let myStackView: UIStackView = {
        let stackView=UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
