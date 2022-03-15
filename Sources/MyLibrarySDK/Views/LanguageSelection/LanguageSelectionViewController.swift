//
//  LanguageSelectionViewController.swift
//
//
//  Created by BrainX 3096 on 18/02/2022.
//

import UIKit

enum SupportedLanguages {
    case english
    case arabic
    case urdu

    var languageCode: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        case .urdu:
            return "ur"
        }
    }

    var languageName: String {
        switch self {
        case .english:
            return LocalizeKey.english.string
        case .arabic:
            return LocalizeKey.arabic.string
        case .urdu:
            return LocalizeKey.urdu.string
        }
    }

    var backendLanguageName: String {
        switch self {
        case .english:
            return "English"
        case .arabic:
            return "Arabic"
        case .urdu:
            return "Urdu"
        }
    }
}

enum LanguageSelectionRouteType: RouteType {
    case feedbackTypeView(data: Any? = nil)
}

class LanguageSelectionViewController: BasicUIViewController {
    // MARK: - Static Variables

    static var feedbackLanguage: SupportedLanguages = .english

    // MARK: - Instance Variables

    private var viewModel: LanguageSelectionViewModel!
    private let selectionButtonHeight: CGFloat = 44
    private var selectedLanguage: SupportedLanguages? {
        didSet {
            if let language = selectedLanguage {
                LanguageSelectionViewController.feedbackLanguage = language
                handleLanguageSelection(selectedLanguage: language)
            }
        }
    }

    private let languageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        return view
    }()

    private let selectLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.selectLanguage.string
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let englishButton: UIButton = {
        let button = UIButton(type: .system)
        if let image = UIImage(packageResource: Image.tickDisabled, ofType: .png) {
            button.addRightIcon(image)
        }
        button.setTitle(LocalizeKey.english.string, for: .normal)
        button.addTarget(self, action: #selector(handleEnglish), for: .touchUpInside)
        return button
    }()

    private let arabicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.arabic.string, for: .normal)
        button.addTarget(self, action: #selector(handleArabic), for: .touchUpInside)
        return button
    }()

    private let urduButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizeKey.urdu.string, for: .normal)
        button.addTarget(self, action: #selector(handleUrdu), for: .touchUpInside)
        return button
    }()

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = LanguageSelectionRouter(viewController: self)
        viewModel = LanguageSelectionViewModel(router: router)
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        [englishButton, arabicButton, urduButton].forEach { button in
            setNormalLanguageSelectionButton(button)
        }
        languageStackView.addArrangedSubview(selectLanguageLabel)
        languageStackView.addArrangedSubview(englishButton)
        languageStackView.addArrangedSubview(arabicButton)
        languageStackView.addArrangedSubview(urduButton)
        languageStackView.setCustomSpacing(selectionButtonHeight, after: selectLanguageLabel)
        containerStackView.addArrangedSubview(languageStackView)
        setupLocalConstraints()
    }

    private func setupLocalConstraints() {
        [englishButton, arabicButton, urduButton].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(selectionButtonHeight)
            }
        }
    }

    private func setNormalLanguageSelectionButton(_ button: UIButton) {
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setCornerRadius(22)
        if let image = UIImage(packageResource: Image.tickDisabled, ofType: .png), button.imageView?.image != image {
            button.addRightIcon(image)
        }
    }

    private func setSelectedLanguageSelectionButton(_ button: UIButton) {
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        if let image = UIImage(packageResource: Image.tick, ofType: .png), button.imageView?.image != image {
            button.addRightIcon(image)
        }
    }

    private func handleLanguageSelection(selectedLanguage: SupportedLanguages) {
        [englishButton, arabicButton, urduButton].forEach { button in
            setNormalLanguageSelectionButton(button)
        }
        switch selectedLanguage {
        case .english:
            setSelectedLanguageSelectionButton(englishButton)
        case .arabic:
            setSelectedLanguageSelectionButton(arabicButton)
        case .urdu:
            setSelectedLanguageSelectionButton(urduButton)
        }
        viewModel.showFeedbackTypeView(language: selectedLanguage)
    }

    // MARK: - Action Methods

    @objc
    func handleEnglish() {
        selectedLanguage = .english
    }

    @objc
    func handleArabic() {
        selectedLanguage = .arabic
    }

    @objc
    func handleUrdu() {
        selectedLanguage = .urdu
    }
}
