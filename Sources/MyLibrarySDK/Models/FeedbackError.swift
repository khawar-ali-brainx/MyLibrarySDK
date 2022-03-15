//
//  FeedbackError.swift
//
//
//  Created by BrainX 3096 on 01/03/2022.
//

import Foundation
import ObjectMapper

class FeedbackError: Mappable, Error {
    var message: String?
    var code = 500

    init(message: String, _ code: Int = 500) {
        self.message = message
        self.code = code
    }

    required init?(map: Map) {
        let requiredKey = "error"
        let keys = Array(map.JSON.keys)
        if !keys.contains(requiredKey), !keys.contains("errors") {
            return nil
        }
    }

    func mapping(map: Map) {
        let keys = Array(map.JSON.keys)
        if keys.contains("error") {
            if let error = map.JSON["error"] as? [String: Any], error.keys.count > 0 {
                if let issues = error["message"] as? String {
                    message = issues
                } else {
                    if let issue = error[error.keys.first!] as? NSArray {
                        message = issue[0] as? String
                    }
                }
            } else if let error = map.JSON["error"] as? String {
                message = error
            }

        } else {
            if let errors = map.JSON["errors"] as? [String], errors.count > 0 {
                if let issues = errors.first {
                    message = issues
                }
            }
        }
    }
}
