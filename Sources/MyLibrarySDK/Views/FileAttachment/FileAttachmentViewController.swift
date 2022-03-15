//
//  FileAttachmentViewController.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import UIKit

typealias MultipleBase64Data = (base64doc: DocumentBase64, url: URL?)

enum FileAttachmentRouteType: RouteType {
    case showThankYouView(data: Any? = nil)
}

enum AttachmentType: CaseIterable {
    case imageJpeg
    case imagePng
    case applicationPdf

    var backendName: String {
        switch self {
        case .imageJpeg:
            return "image/jpeg"
        case .imagePng:
            return "image/png"
        case .applicationPdf:
            return "application/pdf"
        }
    }

    var fullName: String {
        switch self {
        case .applicationPdf:
            return "com.adobe.pdf"
        default:
            return ""
        }
    }

    var extensionName: String {
        switch self {
        case .applicationPdf:
            return "pdf"
        case .imageJpeg:
            return "jpg"
        case .imagePng:
            return "png"
        }
    }
}

struct DocumentBase64 {
    var fileName: String = LocalizeKey.empty.string
    var contentType: String = LocalizeKey.empty.string
    var base64Data: String = LocalizeKey.empty.string

    var data: String {
        return String(format: "%@:%@;%@,%@", "data", contentType, "base64", base64Data)
    }
}

class FileAttachmentViewController: BasicUIViewController {
    // MARK: - Instance variables

    var feedback: Feedback?
    private var selectedDocumentUrl: URL? {
        didSet {
            removeAttachmentButton.isHidden = selectedDocumentUrl == nil ? true : false
            attachmentMessageLabel.isHidden = selectedDocumentUrl == nil ? false : true
            submitButton.isEnabled = selectedDocumentUrl == nil ? false : true
            submitButton.alpha = selectedDocumentUrl == nil ? 0.5 : 1
            if selectedDocumentUrl == nil {
                fileAttachmentButton.setImage(UIImage(packageResource: Image.attachment, ofType: .png), for: .normal)
            }
        }
    }

    private var viewModel: FileAttachmentViewModel!
    private let containerHeight: CGFloat = 300

    private let outerContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    private let dataContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setCornerRadius(8)
        view.addDropShadow(color: UIColor.lightGray, opacity: 1, offSet: .zero, radius: 5)
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.fileAttachment.string
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()

    private let fileAttachmentButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(packageResource: Image.attachment, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleAttachmentAction), for: .touchUpInside)
        return button
    }()

    private let removeButtonAndMessageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
    }()

    private let removeAttachmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.removeAttachment.string, for: .normal)
        button.isHidden = true
        button.setTitleColor(.black, for: .normal)
        button.setBorderColor(UIColor.systemBlue, andWidth: 1)
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(removeAttachment), for: .touchUpInside)
        return button
    }()

    private let attachmentMessageLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = LocalizeKey.attachmentMessage.string
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        return label
    }()

    private let skipAndSubmitButtonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 8
        return view
    }()

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.skip.string, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setBorderColor(UIColor.systemBlue, andWidth: 1)
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(skipAttachment), for: .touchUpInside)
        return button
    }()

    private let submitButton: BlueGradientButton = {
        let button = BlueGradientButton(type: .system)
        button.setTitle(LocalizeKey.submit.string, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = FileAttachmentRouter(viewController: self)
        viewModel = FileAttachmentViewModel(router: router)
        outerContainerStackView.addArrangedSubview(dataContainerView)
        dataContainerView.addSubview(titleLabel)
        dataContainerView.addSubview(fileAttachmentButton)
        dataContainerView.addSubview(removeButtonAndMessageStackView)
        removeButtonAndMessageStackView.addArrangedSubview(removeAttachmentButton)
        removeButtonAndMessageStackView.addArrangedSubview(attachmentMessageLabel)
        dataContainerView.addSubview(skipAndSubmitButtonStackView)
        skipAndSubmitButtonStackView.addArrangedSubview(skipButton)
        skipAndSubmitButtonStackView.addArrangedSubview(submitButton)
        containerStackView.addSubview(activityIndicator)
        containerStackView.addArrangedSubview(outerContainerStackView)
        setupLocalConstraints()
    }

    override func crossButtonAction() {
        viewModel.dismisViewController()
    }

    // MARK: - Private Methods

    private func setupLocalConstraints() {
        dataContainerView.snp.makeConstraints { make in
            make.height.equalTo(containerHeight)
            make.leading.trailing.equalTo(containerStackView)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dataContainerView).offset(8)
            make.leading.equalTo(dataContainerView).offset(16)
            make.trailing.equalTo(dataContainerView).offset(-16)
        }
        fileAttachmentButton.snp.makeConstraints { make in
            make.centerX.equalTo(dataContainerView)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.height.equalTo(96)
        }

        removeButtonAndMessageStackView.snp.makeConstraints { make in
            make.top.equalTo(fileAttachmentButton.snp.bottom).offset(24)
            make.leading.equalTo(dataContainerView).offset(16)
            make.trailing.equalTo(dataContainerView).offset(-16)
            make.bottom.equalTo(skipAndSubmitButtonStackView.snp.top).offset(-16)
        }
        removeAttachmentButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(removeButtonAndMessageStackView)
            make.height.equalTo(38)
        }
        attachmentMessageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(removeButtonAndMessageStackView)
        }
        skipAndSubmitButtonStackView.snp.makeConstraints { make in
            make.leading.equalTo(dataContainerView).offset(16)
            make.trailing.equalTo(dataContainerView).offset(-16)
            make.bottom.equalTo(dataContainerView.snp.bottom).offset(-16)
        }

        skipButton.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
        submitButton.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(dataContainerView.snp.top).offset(-8)
            make.centerX.equalTo(dataContainerView)
            make.width.height.equalTo(64)
        }
    }

    // MARK: - Action Methods

    @objc
    func handleAttachmentAction() {
        let actionSheet = UIAlertController(title: nil, message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: LocalizeKey.uploadPhoto.string, style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self?.present(picker, animated: true)

        }))
        actionSheet.addAction(UIAlertAction(title: LocalizeKey.uploadDocument.string, style: .default, handler: { [weak self] _ in
            let picker = UIDocumentPickerViewController(documentTypes: Constants.docsTypes, in: .import)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: LocalizeKey.cancel.string, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }

    @objc
    func handleSubmit() {
        activityIndicator.startAnimating()
        let feedback = Feedback(attachmentFileUrl: selectedDocumentUrl, feedback: CreateFeedbackViewController.feedbackDataModel?.data)
        viewModel.submitFeedbackWith(feedback: feedback) { [weak self] result in
            switch result {
            case .success:
                self?.activityIndicator.stopAnimating()
                self?.viewModel.showThankYouView()
            case .failure:
                self?.activityIndicator.stopAnimating()
                self?.showAlertView(message: LocalizeKey.unableToSubmitError.string, title: LocalizeKey.error.string)
            }
        }
    }

    @objc
    func skipAttachment() {
        selectedDocumentUrl = nil
        viewModel.showThankYouView()
    }

    @objc
    func removeAttachment() {
        selectedDocumentUrl = nil
    }
}

// MARK: - Photo Picker delegate Methods

extension FileAttachmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let imageUrl = info[.imageURL] as? URL, let selectedImage = info[.originalImage] as? UIImage {
            selectedDocumentUrl = imageUrl
            fileAttachmentButton.setImage(selectedImage, for: .normal)
        }
    }
}

// MARK: - UIDocumentPickerDelegate Methods

extension FileAttachmentViewController: UIDocumentPickerDelegate {
    func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentUrl = urls.first else { return }
        do {
            let resources = try documentUrl.resourceValues(forKeys: [.fileSizeKey])
            let fileSize = resources.fileSize ?? 0
            let fileSizeInMB = (Double(fileSize) / (1024 * 1024))
            guard fileSizeInMB < 6 else {
                showAlertView(message: LocalizeKey.attachmentMessage.string, title: LocalizeKey.alert.string)
                return
            }
        } catch {
            showAlertView(message: LocalizeKey.unableToSubmitError.string, title: LocalizeKey.error.string)
            return
        }
        selectedDocumentUrl = documentUrl
        var thumbnailImage: UIImage?
        let isDocumentJpegImage = documentUrl.pathExtension.lowercased() == AttachmentType.imageJpeg.extensionName
        let isDocumentPngImage = documentUrl.pathExtension.lowercased() == AttachmentType.imagePng.extensionName
        let isDocumentPdf = documentUrl.pathExtension == AttachmentType.applicationPdf.extensionName
        if isDocumentJpegImage || isDocumentPngImage {
            do {
                let fileData = try Data(contentsOf: documentUrl)
                guard let image = UIImage(data: fileData) else { return }
                thumbnailImage = image
            } catch {
                return
            }
        } else if isDocumentPdf {
            guard let image = viewModel.pdfThumbnail(url: documentUrl, width: 120) else { return }
            thumbnailImage = image
        } else {
            return
        }
        guard let thumbnailImage = thumbnailImage else { return }
        fileAttachmentButton.setImage(thumbnailImage, for: .normal)
    }
}
