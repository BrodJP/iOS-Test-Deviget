//
//  HTTPTask.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

enum HTTPTask {
    case requestWithParameters(urlParameters: Parameters?,
                               encoder: ParameterEncoderType)
}
