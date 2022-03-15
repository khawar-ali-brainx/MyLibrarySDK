//
//  FileAttachmentViewModel.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import Foundation
import PDFKit
import UIKit

class FileAttachmentViewModel {
    // MARK: - Instance Properties

    private let router: Router
    private let repository: FeedbackRepository

    // MARK: - Init Methods

    required init(router: FileAttachmentRouter) {
        self.router = router
        repository = FeedbackRepository()
    }

    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        guard let data = try? Data(contentsOf: url), let page = PDFDocument(data: data)?.page(at: 0)
        else {
            return nil
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }

    func dismisViewController() {
        router.dismissVC(navigationType: .stack, animated: false, completion: nil)
    }

    func showThankYouView() {
        router.presentVC(FileAttachmentRouteType.showThankYouView(), navigationType: .stack, animated: false, completion: nil)
    }

    func submitFeedbackWith(feedback: Feedback, completion: @escaping (FeedbackSubmitResult) -> Void) {
        repository.submitFeedback(feedback) { result in
            completion(result)
        }
    }
}
