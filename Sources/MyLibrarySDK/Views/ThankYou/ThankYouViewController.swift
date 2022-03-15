//
//  ThankYouViewController.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import SnapKit
import UIKit

enum Rating: Int {
    case one = 1
    case two
    case three
    case four
    case five

    var messageForRating: String {
        switch self {
        case .one, .two:
            return LocalizeKey.sorryMessage.string
        case .three:
            return LocalizeKey.thanksForLettingUsKnow.string
        case .four, .five:
            return LocalizeKey.happyToServe.string
        }
    }
}

class ThankYouViewController: BasicUIViewController {
    // MARK: - Instance Properties

    private var viewModel: ThankYouViewModel!
    private var selectedRating: Int? {
        didSet {
            guard let selectedRating = selectedRating else {
                return
            }
            ratingLabel.text = Rating(rawValue: selectedRating)?.messageForRating
        }
    }

    private let localMainStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 18
        return view
    }()

    private let thankYouTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.thankYouForYouFeedback.string
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let thankYouImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(packageResource: Image.thankYou, ofType: .png)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let pleaseRateUsLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.pleaseRateUs.string
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let starsView: StarsView = {
        let starView = StarsView()
        starView.rating = 0
        return starView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.empty.string
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()

    private let submitButton: BlueGradientButton = {
        let button = BlueGradientButton(type: .system)
        button.setTitle(LocalizeKey.submit.string, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setCornerRadius(8)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()

    private let feedbackUsedMessageLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizeKey.feedbackUsedMessage.string
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    // MARK: - Override Method

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = ThankYouRouter(viewController: self)
        viewModel = ThankYouViewModel(router: router)
        FeedbackTypeSectionViewController.selectedFeedbackType = nil
        starsView.thankYouVC = self
        setupViews()
    }

    override func crossButtonAction() {
        guard let navigationController = navigationController else {
            viewModel.dismisViewController()
            return
        }
        FeedbackWindow.shared.isFeedbackViewVisible.toggle()
        navigationController.popToRootViewController(animated: false)
    }

    // MARK: - Private Methods

    private func setupViews() {
        localMainStackView.addArrangedSubview(thankYouTitleLabel)
        localMainStackView.addArrangedSubview(thankYouImageView)
        localMainStackView.addArrangedSubview(pleaseRateUsLabel)
        localMainStackView.addArrangedSubview(starsView)
        localMainStackView.addArrangedSubview(ratingLabel)
        localMainStackView.addArrangedSubview(submitButton)
        localMainStackView.addSubview(activityIndicator)
        localMainStackView.addSubview(feedbackUsedMessageLabel)
        containerStackView.addArrangedSubview(localMainStackView)
        setupLocalConstraints()
    }

    private func setupLocalConstraints() {
        thankYouTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(containerStackView).offset(32)
            make.trailing.equalTo(containerStackView).offset(-32)
        }
        thankYouImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        starsView.snp.makeConstraints { make in
            make.leading.equalTo(localMainStackView).offset(11)
            make.trailing.equalTo(localMainStackView).offset(-11)
            make.height.equalTo(32)
        }
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(localMainStackView.snp.top).offset(-8)
            make.centerX.equalTo(localMainStackView)
            make.width.height.equalTo(64)
        }
        submitButton.snp.makeConstraints { make in
            make.centerX.equalTo(containerStackView)
            make.width.equalTo(100)
            make.height.equalTo(32)
        }
        feedbackUsedMessageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerStackView)
            make.bottom.equalTo(view).offset(-8)
        }
    }

    // MARK: - Action Methods

    @objc
    func handleSubmit() {
        activityIndicator.startAnimating()
        let ratingText = ratingLabel.text ?? LocalizeKey.empty.string
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent("SavedFiles") else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent("FeedbackRating" + ".txt")
        try? ratingText.write(to: file, atomically: false, encoding: String.Encoding.utf8)

        let feedback = Feedback(ratingFileUrl: file, feedback: CreateFeedbackViewController.feedbackDataModel?.data, ratingValue: selectedRating)
        viewModel.submitFeedbackWith(feedback: feedback) { [weak self] result in
            switch result {
            case .success:
                self?.activityIndicator.stopAnimating()
                self?.crossButtonAction()
            case .failure:
                self?.activityIndicator.stopAnimating()
                self?.showAlertView(message: LocalizeKey.unableToSubmitError.string, title: LocalizeKey.error.string)
            }
        }
    }

    // MARK: - Public Methods

    func updateRatingUIWith(_ rating: Int) {
        selectedRating = rating
    }
}
