//
//  File.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import Foundation

enum Environment {
    case development
    case production

    static var current: Environment { return .development }

    static var baseUrl: URL? {
        switch current {
        case .development: return URL(string: "https://uat-api-plugin.ajman.ae/api/")
        case .production: return URL(string: "https://uat-api-plugin.ajman.ae/api/")
        }
    }
}
