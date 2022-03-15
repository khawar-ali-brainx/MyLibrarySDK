//
//  File.swift
//
//
//  Created by BrainX 3096 on 01/03/2022.
//

import Foundation
import UIKit

struct Feedback {
    let audioFileUrl: URL?
    let videoFileUrl: URL?
    let imageFile: UIImage?
    let textFileUrl: URL?
    let attachmentFileUrl: URL?
    let ratingFileUrl: URL?
    let feedback: FeedbackReceivedModel?
    let ratingValue: Int?
    
    init(audioFileUrl: URL? = nil, videoFileUrl: URL? = nil, imageFile: UIImage? = nil, textFileUrl: URL? = nil, attachmentFileUrl: URL? = nil, ratingFileUrl: URL? = nil, feedback: FeedbackReceivedModel? = nil, ratingValue: Int? = nil){
        self.audioFileUrl = audioFileUrl
        self.videoFileUrl = videoFileUrl
        self.imageFile = imageFile
        self.textFileUrl = textFileUrl
        self.attachmentFileUrl = attachmentFileUrl
        self.ratingFileUrl = ratingFileUrl
        self.feedback = feedback
        self.ratingValue = ratingValue
    }
}
