//
//  SelfieView.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import UIKit

class SelfieView: UIView {
    // MARK: - Instance variables

    var createVC: CreateFeedbackViewController!
    private var selectedFeedbackImageUrl: URL?
    private var selectedFeedbackImage: UIImage? {
        didSet {
            submitButton.isEnabled = selectedFeedbackImage != nil ? true : false
            submitButton.alpha = selectedFeedbackImage != nil ? 1 : 0.5
        }
    }

    private var isAttachmentAllowed: Bool = false {
        didSet {
            if let attachmentImage = UIImage(packageResource: Image.checkbox, ofType: .png), let attachmentEmptyImage = UIImage(packageResource: Image.checkboxEmpty, ofType: .png) {
                addAttachmentButton.addLeftIcon(isAttachmentAllowed ? attachmentImage : attachmentEmptyImage)
                submitButton.setTitle(isAttachmentAllowed ? LocalizeKey.next.string : LocalizeKey.submit.string, for: .normal)
            }
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.captureYourSelfie.string
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(packageResource: Image.placeholderImage, ofType: .png)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let addAttachmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.addAttachment.string, for: .normal)
        if let image = UIImage(packageResource: Image.checkboxEmpty, ofType: .png) {
            button.addLeftIcon(image)
        }
        button.addTarget(self, action: #selector(handleAddAttachment), for: .touchUpInside)
        button.tintColor = Color.timerGray
        return button
    }()

    private let retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.retake.string, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setBorderColor(UIColor.systemBlue, andWidth: 1)
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return button
    }()

    private let submitButton: BlueGradientButton = {
        let button = BlueGradientButton(type: .system)
        button.setTitle(LocalizeKey.submit.string, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    // MARK: - Init Methods

    required init(createVC: CreateFeedbackViewController) {
        self.createVC = createVC
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private methods

    private func setupView() {
        addSubview(titleLabel)
        addSubview(selectedImageView)
        addSubview(addAttachmentButton)
        addSubview(retakeButton)
        addSubview(submitButton)
        setupConstraints()
        captureImage()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(32)
        }

        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.bottom.equalTo(addAttachmentButton.snp.top).offset(-8)
        }

        addAttachmentButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.leading.equalTo(self)
            make.bottom.equalTo(retakeButton.snp.top).offset(-8)
        }

        retakeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-11)
            make.leading.equalTo(self).offset(11)
            make.height.equalTo(38)
            make.width.equalTo(80)
        }

        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(retakeButton)
            make.trailing.equalTo(self).offset(-11)
            make.height.equalTo(38)
            make.leading.equalTo(retakeButton.snp.trailing).offset(8)
        }
    }

    // MARK: - Action methods

    @objc
    func handleSubmit() {
        let feedback = Feedback(imageFile: selectedFeedbackImage)
        createVC.submitFeedback(feedback, withAttachmentAllowed: isAttachmentAllowed)
    }

    @objc
    func captureImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let errorMessage = ErrorMessageAndTitle(LocalizeKey.videoFeedback.string, LocalizeKey.noCameraDetected.string)
            createVC.viewModel.showErrorViewWith(errorMessage: errorMessage)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = self
        picker.allowsEditing = false
        createVC.present(picker, animated: true)
    }

    @objc
    func handleAddAttachment() {
        isAttachmentAllowed.toggle()
    }
}

// MARK: - UIImagePickerControllerDelegate Methods

extension SelfieView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedFeedbackImage = selectedImage
            selectedImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
