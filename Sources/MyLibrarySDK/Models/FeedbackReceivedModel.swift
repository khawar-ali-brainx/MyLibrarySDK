//
//  FeedbackReceivedModel.swift
//
//
//  Created by BrainX 3096 on 01/03/2022.
//

import ObjectMapper

class FeedbackReceivedModel: Mappable {
    var feedbackType: String?
    var appLayout: String?
    var feedbackLanguage: String?
    var user: String?
    var layout: String?
    var id: Int?
    var url: String?
    var domain: String?

    required init?(map _: Map) {}

    func mapping(map: Map) {
        feedbackType <- map["feedback_type"]
        domain <- map["domain"]
        feedbackLanguage <- map["feedback_language"]
        user <- map["user"]
        id <- map["id"]
        url <- map["url"]
        layout <- map["layout"]
        appLayout <- map["app_layout"]
    }
}
