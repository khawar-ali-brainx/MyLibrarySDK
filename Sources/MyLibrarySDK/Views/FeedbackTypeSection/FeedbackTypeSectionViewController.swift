//
//  FeedbackTypeSectionViewController.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import Foundation
import UIKit

enum FeedbackType: CaseIterable {
    case voice
    case video
    case selfie
    case text

    var name: String {
        switch self {
        case .voice:
            return LocalizeKey.audio.string
        case .video:
            return LocalizeKey.video.string
        case .selfie:
            return LocalizeKey.selfie.string
        case .text:
            return LocalizeKey.message.string
        }
    }
}

enum FeedbackTypeRouteType: RouteType {
    case createFeedbackView(data: Any? = nil)
}

class FeedbackTypeSectionViewController: BasicUIViewController {
    // MARK: - Static variable

    static var selectedFeedbackType: FeedbackType? = nil

    // MARK: - Instance variables

    private var viewModel: FeedbackTypeSectionViewModel!
    private let selectionButtonHeight: CGFloat = 72

    private let typeSelectionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 24
        return view
    }()

    private let provideFeedbackLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.provideYourFeedback.string
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()

    private let voiceAndVideoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 24
        return view
    }()

    private let voiceStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
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
        label.text = FeedbackType.voice.name
        label.textColor = .white
        return label
    }()

    private let videoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
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
        label.text = FeedbackType.video.name
        label.textColor = .white
        return label
    }()

    private let selfieAndTextStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 24
        return view
    }()

    private let selfieStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
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
        label.text = FeedbackType.selfie.name
        label.textColor = .white
        return label
    }()

    private let textStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
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
        label.text = FeedbackType.text.name
        label.textColor = .white
        return label
    }()

    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = FeedbackTypeSectionRouter(viewController: self)
        viewModel = FeedbackTypeSectionViewModel(router: router)
        typeSelectionStackView.addArrangedSubview(provideFeedbackLabel)
        typeSelectionStackView.setCustomSpacing(selectionButtonHeight / 2, after: provideFeedbackLabel)
        typeSelectionStackView.addArrangedSubview(voiceAndVideoStackView)
        voiceAndVideoStackView.addArrangedSubview(voiceStackView)
        voiceStackView.addArrangedSubview(voiceButton)
        voiceStackView.addArrangedSubview(voiceLabel)
        voiceAndVideoStackView.addArrangedSubview(videoStackView)
        videoStackView.addArrangedSubview(videoButton)
        videoStackView.addArrangedSubview(videoLabel)
        typeSelectionStackView.addArrangedSubview(selfieAndTextStackView)
        selfieAndTextStackView.addArrangedSubview(selfieStackView)
        selfieStackView.addArrangedSubview(selfieButton)
        selfieStackView.addArrangedSubview(selfieLabel)
        selfieAndTextStackView.addArrangedSubview(textStackView)
        textStackView.addArrangedSubview(textButton)
        textStackView.addArrangedSubview(textLabel)
        containerStackView.addArrangedSubview(typeSelectionStackView)
        setupLocalConstraints()
    }

    override func crossButtonAction() {
        viewModel.dismisViewController()
        FeedbackTypeSectionViewController.selectedFeedbackType = nil
        navigationController?.popViewController(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedType = FeedbackTypeSectionViewController.selectedFeedbackType else { return }
        FeedbackType.allCases.forEach {
            handleFeedBackSelected(feedbackType: $0, isSelected: $0 == selectedType)
        }
    }

    // MARK: - Private Methods

    private func setupLocalConstraints() {
        [voiceButton, videoButton, selfieButton, textButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.width.equalTo(selectionButtonHeight)
            }
        }
    }

    private func updateUIWith(selectedType: FeedbackType) {
        FeedbackType.allCases.forEach {
            handleFeedBackSelected(feedbackType: $0, isSelected: $0 == selectedType)
        }
        viewModel.showCreateFeedbackView(type: selectedType)
    }

    private func handleFeedBackSelected(feedbackType: FeedbackType, isSelected: Bool) {
        switch feedbackType {
        case .voice:
            if let image = UIImage(packageResource: Image.voice, ofType: .png), let selectedImage = UIImage(packageResource: Image.voiceSelected, ofType: .png) {
                voiceButton.setImage(isSelected ? selectedImage : image, for: .normal)
            }
        case .video:
            if let image = UIImage(packageResource: Image.video, ofType: .png), let selectedImage = UIImage(packageResource: Image.videoSelected, ofType: .png) {
                videoButton.setImage(isSelected ? selectedImage : image, for: .normal)
            }
        case .selfie:
            if let image = UIImage(packageResource: Image.selfie, ofType: .png), let selectedImage = UIImage(packageResource: Image.selfieSelected, ofType: .png) {
                selfieButton.setImage(isSelected ? selectedImage : image, for: .normal)
            }
        case .text:
            if let image = UIImage(packageResource: Image.text, ofType: .png), let selectedImage = UIImage(packageResource: Image.textSelected, ofType: .png) {
                textButton.setImage(isSelected ? selectedImage : image, for: .normal)
            }
        }
    }

    // MARK: - Action methods

    @objc
    func handleVoice() {
        updateUIWith(selectedType: .voice)
    }

    @objc
    func handleVideo() {
        updateUIWith(selectedType: .video)
    }

    @objc
    func handleSelfie() {
        updateUIWith(selectedType: .selfie)
    }

    @objc
    func handleText() {
        updateUIWith(selectedType: .text)
    }
}
