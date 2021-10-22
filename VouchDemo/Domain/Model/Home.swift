//
//  Created by NguyenSeven on 12/10/2021.
//

import Foundation

struct HomeResponse: Codable {
    let data: [HomeData]?
}

struct HomeData: Codable {
    let raceId: Int?
    let date: String?
}
