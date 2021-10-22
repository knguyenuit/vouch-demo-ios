//
//  Created by NguyenSeven on 04/06/2021.
//

import Foundation

extension Encodable {
    func encoded() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        guard let json = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return [:]
        }
        return dict
    }
}
