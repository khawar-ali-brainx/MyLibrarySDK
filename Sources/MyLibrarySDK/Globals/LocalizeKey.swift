//
//  LocalizeKey.swift
//
//
//  Created by BrainX 3096 on 18/02/2022.
//

import Foundation

enum LocalizeKey: String {
    var string: String {
        return rawValue.localized()
    }

    case empty
    case selectLanguage
    case english
    case arabic
    case urdu
    case provideYourFeedback
    case audio
    case video
    case selfie
    case message
    case captureYourSelfie
    case retake
    case submit
    case recordYourVideo
    case rerecord
    case recordYourAudio
    case enterYourFeedback
    case characters
    case switchTo
    case fileAttachment
    case skip
    case thankYouForYouFeedback
    case pleaseRateUs
    case rating
    case ok
    case error
    case unableToSubmitError
    case audioFeedback
    case noMicroPhoneDetected
    case videoFeedback
    case noCameraDetected
    case atLeast6CharactersMessage
    case alert
    case JSONParsingError
    case audioShouldBeMinimum5Seconds
    case videoShouldBeMinimum5Seconds
    case addAttachment
    case sorryMessage
    case happyToServe
    case attachmentMessage
    case removeAttachment
    case thanksForLettingUsKnow
    case feedbackUsedMessage
    case next
    case uploadDocument
    case uploadPhoto
    case cancel
}
