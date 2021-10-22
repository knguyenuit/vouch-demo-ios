//
//  Created by NguyenSeven on 09/05/2021.
//

import Foundation

extension NSObject {

    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
