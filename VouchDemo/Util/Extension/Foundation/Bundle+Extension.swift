//
//  Created by NguyenSeven on 7/19/20.
//

import Foundation

extension Bundle {

    class var identifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}
