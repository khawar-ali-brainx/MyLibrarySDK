//
//  FeedbackData.swift
//
//
//  Created by BrainX 3096 on 01/03/2022.
//

import Foundation
import ObjectMapper

class FeedbackData: Mappable {
    var data: FeedbackReceivedModel?
    var errorCode: String?
    var error: String?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        data <- map["data"]
        errorCode <- map["error_code"]
        error <- map["error"]
    }
}
