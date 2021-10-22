//  Created by NguyenSeven on 12/10/2021.
//

import Foundation

struct AppConfig {
    #if DEBUG
        static let firebasePath = Bundle.main.path(forResource: "GoogleService-Dev-Info", ofType: "plist")
        static let mainDomain = "https://app-stg.vouch.sg/"
    #elseif RELEASE
        static let firebasePath = Bundle.main.path(forResource: "GoogleService-Prod-Info", ofType: "plist")
        static let mainDomain = "https://app-stg.vouch.sg/"
    #endif
}
