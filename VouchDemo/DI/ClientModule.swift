//
//  Created by NguyenSeven on 08/08/2021.
//

import Foundation

protocol ClientModule { }

extension ClientModule {

    /// API Client
    var apiClient: APIClientType {
        return APIClient()
    }

    /*
    /// Firestore Module
    var firestoreClient: FirestoreClientType {
        return FirestoreClient.shared()
    }
    */
}
