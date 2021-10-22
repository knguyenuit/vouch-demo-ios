//
//  Created by NguyenSeven on 06/05/2021.
//

import Foundation

func randomPosition (lowerBound lower: Float, upperBound upper: Float) -> Float {
    return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
}

func randomNumber (lowerBound lower: Int, upperBound upper: Int) -> Int {
    return Int(arc4random()) / Int(UInt32.max) * (lower - upper) + upper
}
