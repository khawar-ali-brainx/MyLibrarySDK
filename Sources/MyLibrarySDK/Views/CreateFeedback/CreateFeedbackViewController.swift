//
//  CreateFeedbackViewController.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import SnapKit
import UIKit

typealias ErrorMessageAndTitle = (errorTitle: String, errorDescription: String)

enum CreateFeedbackRouteType: RouteType {
    case showFileAttachmentView(data: Any? = nil)
    case showThankYouView(data: Any? = nil)
    case showErrorView(data: Any? = nil)
}

class CreateFeedbackViewController: BasicUIViewController {
    // MARK: - Static variable

    static var feedbackDataModel: FeedbackData?

    // MARK: - Instance variables

    var passedFeedbackType: FeedbackType?
    var viewModel: CreateFeedbackViewModel!

    private var selectedFeedbackType: FeedbackType = .voice {
        didSet {
            FeedbackTypeSectionViewController.selectedFeedbackType = selectedFeedbackType
            updateUIWith(selectedType: selectedFeedbackType)
        }
    }

    private var selectionButtonHeight: CGFloat = 62
    private let labelHeight: CGFloat = 16
    private let arrowHeight: CGFloat = 8
    private let containerHeight: CGFloat = 300
    private let labelFontSize: CGFloat = 8

    private var voiceView: VoiceView?
    private var videoView: VideoView?
    private var selfieView: SelfieView?
    private var textView: TextView?

    private let outerContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    private let selectionContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let voiceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let voiceButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.voice, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleVoice), for: .touchUpInside)
        return button
    }()

    private let voiceLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.audio.string
        label.textColor = .white
        return label
    }()

    private let voiceDownArrowImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(packageResource: Image.downArrow, ofType: .png) {
            imageView.image = image
        }
        imageView.tintColor = .white
        return imageView
    }()

    private let videoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let videoButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.video, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleVideo), for: .touchUpInside)
        return button
    }()

    private let videoLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.video.string
        label.textColor = .white
        return label
    }()

    private let videoDownArrowImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(packageResource: Image.downArrow, ofType: .png) {
            imageView.image = image
        }
        imageView.tintColor = .white
        return imageView
    }()

    private let selfieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let selfieButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.selfie, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleSelfie), for: .touchUpInside)
        return button
    }()

    private let selfieLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.selfie.string
        label.textColor = .white
        return label
    }()

    private let selfieDownArrowImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(packageResource: Image.downArrow, ofType: .png) {
            imageView.image = image
        }
        imageView.tintColor = .white
        return imageView
    }()

    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    private let textButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.text, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.addTarget(self, action: #selector(handleText), for: .touchUpInside)
        return button
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.message.string
        label.textColor = .white
        return label
    }()

    private let textDownArrowImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(packageResource: Image.downArrow, ofType: .png) {
            imageView.image = image
        }
        imageView.tintColor = .white
        return imageView
    }()

    private let dataContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setCornerRadius(8)
        view.addDropShadow(color: UIColor.lightGray, opacity: 1, offSet: .zero, radius: 5)
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = CreateFeedbackRouter(viewController: self)
        viewModel = CreateFeedbackViewModel(router: router)
        if let passedFeedbackType = passedFeedbackType {
            selectedFeedbackType = passedFeedbackType
        }
        [voiceLabel, videoLabel, selfieLabel, textLabel].forEach { $0.font = UIFont.systemFont(ofSize: labelFontSize) }

        outerContainerStackView.addArrangedSubview(selectionContainerStackView)

        selectionContainerStackView.addArrangedSubview(voiceStackView)
        voiceStackView.addArrangedSubview(voiceButton)
        voiceStackView.addArrangedSubview(voiceLabel)
        voiceStackView.addArrangedSubview(voiceDownArrowImageView)

        selectionContainerStackView.addArrangedSubview(videoStackView)
        videoStackView.addArrangedSubview(videoButton)
        videoStackView.addArrangedSubview(videoLabel)
        videoStackView.addArrangedSubview(videoDownArrowImageView)

        selectionContainerStackView.addArrangedSubview(selfieStackView)
        selfieStackView.addArrangedSubview(selfieButton)
        selfieStackView.addArrangedSubview(selfieLabel)
        selfieStackView.addArrangedSubview(selfieDownArrowImageView)

        selectionContainerStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(textButton)
        textStackView.addArrangedSubview(textLabel)
        textStackView.addArrangedSubview(textDownArrowImageView)

        outerContainerStackView.addArrangedSubview(dataContainerView)
        containerStackView.addSubview(activityIndicator)
        containerStackView.addArrangedSubview(outerContainerStackView)
        setupLocalConstraints()
    }

    override func crossButtonAction() {
        viewModel.dismisViewController()
        voiceView?.stopPlayback()
        voiceView?.finishRecording(success: false)
    }

    // MARK: - Private Methods

    private func setupLocalConstraints() {
        [voiceButton, videoButton, selfieButton, textButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(selectionButtonHeight)
            }
        }
        [voiceLabel, videoLabel, selfieLabel, textLabel].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(labelHeight)
            }
        }
        [voiceDownArrowImageView, videoDownArrowImageView, selfieDownArrowImageView, textDownArrowImageView].forEach {
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(arrowHeight)
            }
        }
        dataContainerView.snp.makeConstraints { make in
            make.height.equalTo(containerHeight)
            make.leading.trailing.equalTo(containerStackView)
        }
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(dataContainerView.snp.top).offset(-8)
            make.centerX.equalTo(dataContainerView)
            make.width.height.equalTo(64)
        }
    }

    private func updateUIWith(selectedType _: FeedbackType) {
        for type in FeedbackType.allCases {
            if type == selectedFeedbackType {
                setSelected(feedbackType: type, isSelected: true)
            } else {
                setSelected(feedbackType: type, isSelected: false)
            }
        }
    }

    private func setSelected(feedbackType: FeedbackType, isSelected: Bool) {
        switch feedbackType {
        case .voice:
            voiceLabel.text = isSelected ? LocalizeKey.audio.string : Constants.oneSpace
            voiceDownArrowImageView.image = isSelected ? UIImage(packageResource: Image.downArrow, ofType: .png) : UIImage()
            voiceButton.setImage(isSelected ? UIImage(packageResource: Image.voiceSelected, ofType: .png) : UIImage(packageResource: Image.voice, ofType: .png), for: .normal)
            guard isSelected else { return }
            voiceView = VoiceView(createVC: self)
            if let voiceView = voiceView {
                dataContainerView.subviews.forEach { $0.removeFromSuperview() }
                dataContainerView.addSubview(voiceView)
            }
            voiceView?.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalTo(dataContainerView)
            }
        case .video:
            videoLabel.text = isSelected ? LocalizeKey.video.string : Constants.oneSpace
            videoDownArrowImageView.image = isSelected ? UIImage(packageResource: Image.downArrow, ofType: .png) : UIImage()
            videoButton.setImage(isSelected ? UIImage(packageResource: Image.videoSelected, ofType: .png) : UIImage(packageResource: Image.video, ofType: .png), for: .normal)
            guard isSelected else { return }
            videoView = VideoView(createVC: self)
            if let videoView = videoView {
                dataContainerView.subviews.forEach { $0.removeFromSuperview() }
                dataContainerView.addSubview(videoView)
            }
            videoView?.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalTo(dataContainerView)
            }
        case .selfie:
            selfieLabel.text = isSelected ? LocalizeKey.selfie.string : Constants.oneSpace
            selfieDownArrowImageView.image = isSelected ? UIImage(packageResource: Image.downArrow, ofType: .png) : UIImage()
            selfieButton.setImage(isSelected ? UIImage(packageResource: Image.selfieSelected, ofType: .png) : UIImage(packageResource: Image.selfie, ofType: .png), for: .normal)
            guard isSelected else { return }
            selfieView = SelfieView(createVC: self)
            if let selfieView = selfieView {
                dataContainerView.subviews.forEach { $0.removeFromSuperview() }
                dataContainerView.addSubview(selfieView)
            }
            selfieView?.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalTo(dataContainerView)
            }
        case .text:
            textLabel.text = isSelected ? LocalizeKey.message.string : Constants.oneSpace
            textDownArrowImageView.image = isSelected ? UIImage(packageResource: Image.downArrow, ofType: .png) : UIImage()
            textButton.setImage(isSelected ? UIImage(packageResource: Image.textSelected, ofType: .png) : UIImage(packageResource: Image.text, ofType: .png), for: .normal)
            guard isSelected else { return }
            textView = TextView(createVC: self)
            if let textView = textView {
                dataContainerView.subviews.forEach { $0.removeFromSuperview() }
                dataContainerView.addSubview(textView)
            }
            textView?.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalTo(dataContainerView)
            }
        }
    }

    // MARK: - Public Methods

    func submitFeedback(_ feedback: Feedback, withAttachmentAllowed attachmentAllowed: Bool) {
        activityIndicator.startAnimating()
        viewModel.submitFeedbackWith(feedback: feedback) { [weak self] result in
            switch result {
            case let .success(model):
                CreateFeedbackViewController.feedbackDataModel = model
                guard let strongSelf = self else { return }
                attachmentAllowed ? self?.viewModel.showFileAttachment() : strongSelf.viewModel.showThankYou()
                strongSelf.activityIndicator.stopAnimating()
            case .failure:
                self?.activityIndicator.stopAnimating()
                self?.showAlertView(message: LocalizeKey.unableToSubmitError.string, title: LocalizeKey.error.string)
            }
        }
    }

    // MARK: - Action methods

    @objc
    func handleVoice() {
        selectedFeedbackType = .voice
    }

    @objc
    func handleVideo() {
        selectedFeedbackType = .video
    }

    @objc
    func handleSelfie() {
        selectedFeedbackType = .selfie
    }

    @objc
    func handleText() {
        selectedFeedbackType = .text
    }
}
