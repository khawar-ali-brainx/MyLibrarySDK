//
//  File.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import Foundation

enum Endpoint {
    static var createFeedback: URL? {
        URL(string: "create_feedback/", relativeTo: Environment.baseUrl)
    }
}
