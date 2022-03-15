//
//  VideoView.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import AVKit
import MobileCoreServices
import UIKit

class VideoView: UIView {
    // MARK: - Instance variables

    var createVC: CreateFeedbackViewController!
    private let videoFileName = "/video.mp4"
    private var selectedVideoURL: URL? {
        didSet {
            submitButton.isEnabled = selectedVideoURL != nil ? true : false
            submitButton.alpha = selectedVideoURL != nil ? 1 : 0.5
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
        label.text = LocalizeKey.recordYourVideo.string
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let videoContainer: UIView = {
        let view = UIView()
        return view
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

    private let rerecordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.rerecord.string, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setBorderColor(UIColor.systemBlue, andWidth: 1)
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(reRecordVideo), for: .touchUpInside)
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

    // MARK: - Override methods

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
        addSubview(videoContainer)
        addSubview(addAttachmentButton)
        addSubview(rerecordButton)
        addSubview(submitButton)
        setupConstraints()
        reRecordVideo()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(32)
        }

        videoContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.bottom.equalTo(addAttachmentButton.snp.top).offset(-8)
        }

        addAttachmentButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.leading.equalTo(self)
            make.bottom.equalTo(rerecordButton.snp.top).offset(-8)
        }

        rerecordButton.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-11)
            make.leading.equalTo(self).offset(11)
            make.height.equalTo(38)
            make.width.equalTo(80)
        }

        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(rerecordButton)
            make.trailing.equalTo(self).offset(-11)
            make.height.equalTo(38)
            make.leading.equalTo(rerecordButton.snp.trailing).offset(8)
        }
    }

    private func updateUIWith(_ selectedVideo: URL) {
        let image = generateThumbnail(url: selectedVideo)
        let previewImageView = UIImageView()
        previewImageView.image = image
        videoContainer.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(videoContainer)
        }
        let overlayView = UIView(frame: videoContainer.bounds)
        overlayView.backgroundColor = .black.withAlphaComponent(0.5)
        videoContainer.addSubview(overlayView)
        let playImageButton = UIButton(type: .custom)
        if let playImage = UIImage(packageResource: Image.play, ofType: .png) {
            playImageButton.setImage(playImage, for: .normal)
        }
        videoContainer.addSubview(playImageButton)
        playImageButton.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(videoContainer)
            make.width.height.equalTo(44)
        }
        playImageButton.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
    }

    private func generateThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time: CMTime = CMTimeMake(value: 1, timescale: 30)
        let img: CGImage
        do {
            try img = assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {}
        return nil
    }

    // MARK: - Action methods

    @objc
    func handleSubmit() {
        let feedback = Feedback(videoFileUrl: selectedVideoURL)
        createVC.submitFeedback(feedback, withAttachmentAllowed: isAttachmentAllowed)

    }

    @objc
    private func reRecordVideo() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let errorMessage = ErrorMessageAndTitle(LocalizeKey.videoFeedback.string, LocalizeKey.noCameraDetected.string)
            createVC.viewModel.showErrorViewWith(errorMessage: errorMessage)
            return
        }
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.cameraDevice = .front
        controller.videoMaximumDuration = TimeInterval(60.0)
        controller.mediaTypes = [kUTTypeMovie as String]
        controller.delegate = self
        createVC.present(controller, animated: true, completion: nil)
    }

    @objc
    func handlePlayVideo() {
        guard let url = selectedVideoURL else { return }
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        createVC.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    @objc
    private func handleAddAttachment() {
        isAttachmentAllowed.toggle()
    }
}

// MARK: - UIImagePickerControllerDelegate methods

extension VideoView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedVideo: URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            let asset = AVAsset(url: selectedVideo)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            guard durationTime > 5 else {
                picker.dismiss(animated: true)
                createVC.showAlertView(message: LocalizeKey.videoShouldBeMinimum5Seconds.string, title: LocalizeKey.alert.string)
                selectedVideoURL = nil
                return
            }
            selectedVideoURL = selectedVideo
            updateUIWith(selectedVideo)
        }
        picker.dismiss(animated: true)
    }
}
