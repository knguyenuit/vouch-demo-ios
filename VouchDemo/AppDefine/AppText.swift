//
//  Created by NguyenSeven on 08/08/2021.
//

import UIKit

struct AppText {
    static func println(title: String, messLog: String) {
        print("ℹ️ \(title): \(messLog)")
    }
    static func showFontList() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    static let nameTaken = "Name is already taken."
    static let enterName = "Please enter your character name."
    struct Authentication {
        static let phoneTitle = "Nhập Số Điện Thoại"
        static let phonePlaceHolder = "00 0000 0000"
        static let passwordTitle = "Nhập Mật Khẩu"
        static let passwordPlaceHolder = "************"
        static let loginTitle = "Đăng Nhập"
    }
}
