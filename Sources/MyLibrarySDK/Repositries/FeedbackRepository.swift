//
//  File.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import Alamofire
import Foundation
import ObjectMapper

typealias FeedbackSubmitResult = Result<FeedbackData, FeedbackError>

class FeedbackRepository {
    func submitFeedback(_ feedback: Feedback, withCompletion completion: @escaping (FeedbackSubmitResult) -> Void) {
        APIClient.shared.performMultipartFormDataRequest(FeedbackRequest.submitFeedback(feedback: feedback)) { (result: APIClientResult) in
            switch result {
            case let .success(value):
                guard let (_, body) = value as? ([String: Any], [String: Any]) else {
                    completion(.failure(FeedbackError(message: LocalizeKey.error.string)))
                    return
                }
                guard let model = Mapper<FeedbackData>().map(JSONObject: body) else {
                    completion(.failure(FeedbackError(message: LocalizeKey.JSONParsingError.string)))
                    return
                }
                completion(.success(model))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Enum HTTPRequest

enum FeedbackRequest: HTTPRequest {
    case submitFeedback(feedback: Feedback)
}

// MARK: - Enum Extension

extension FeedbackRequest {
    var endPoint: URL? {
        switch self {
        case .submitFeedback: return Endpoint.createFeedback
        }
    }

    var method: HTTPMethod {
        switch self {
        case .submitFeedback: return .post
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .submitFeedback:
            let contentType = HTTPHeader(name: "Content-Type", value: "application/json")
            let headers: HTTPHeaders = [contentType]
            return headers
        }
    }

    var multipartFormData: MultipartFormData? {
        switch self {
        case let .submitFeedback(feedback):
            let multipartFormData = MultipartFormData()
            if let image = feedback.imageFile, let imageData = image.jpegData(compressionQuality: 0.5) {
                multipartFormData.append("image".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("image".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(imageData, withName: "feedback_file", fileName: "feedback.jpg", mimeType: "image/jpeg")
            }
            if let audioFileUrl = feedback.audioFileUrl {
                multipartFormData.append("audio".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("audio".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(audioFileUrl, withName: "feedback_file", fileName: "\(Date().timeIntervalSince1970).mp3", mimeType: "\(Date().timeIntervalSince1970)/mp3")
            }
            if let videoFileUrl = feedback.videoFileUrl {
                multipartFormData.append("video".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("video".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(videoFileUrl, withName: "feedback_file", fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "\(Date().timeIntervalSince1970)/mp4")
            }
            if let textFileUrl = feedback.textFileUrl {
                multipartFormData.append("text".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("text".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(textFileUrl, withName: "feedback_file", fileName: "\(Date().timeIntervalSince1970).text", mimeType: "\(Date().timeIntervalSince1970)/text")
            }
            if let attachmentUrl = feedback.attachmentFileUrl {
                multipartFormData.append("True".data(using: String.Encoding.utf8)!, withName: "attachment_status")
                multipartFormData.append("image".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("image".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(attachmentUrl, withName: "feedback_file", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "\(Date().timeIntervalSince1970)/jpeg")
            }
            if let ratingFileUrl = feedback.ratingFileUrl, let rating = feedback.ratingValue {
                multipartFormData.append("\(rating)".data(using: String.Encoding.utf8)!, withName: "rating")
                multipartFormData.append("text".data(using: String.Encoding.utf8)!, withName: "domain")
                multipartFormData.append("text".data(using: String.Encoding.utf8)!, withName: "feedback_type")
                multipartFormData.append(ratingFileUrl, withName: "feedback_file", fileName: "\(Date().timeIntervalSince1970).text", mimeType: "\(Date().timeIntervalSince1970)/text")
            }
            if let feedbackId = feedback.feedback?.id {
                multipartFormData.append("\(feedbackId)".data(using: String.Encoding.utf8)!, withName: "feedback_id")
            }
            multipartFormData.append(LanguageSelectionViewController.feedbackLanguage.backendLanguageName.data(using: String.Encoding.utf8)!, withName: "feedback_language")
            multipartFormData.append("guest".data(using: String.Encoding.utf8)!, withName: "user")

            return multipartFormData
        }
    }
}
