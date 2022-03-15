//
//  FeedbackErrorViewController.swift
//
//
//  Created by BrainX 3096 on 28/02/2022.
//

import UIKit

class FeedbackErrorViewController: BasicUIViewController {
    var errorTitle: String?
    var descriptionMessage: String?

    // MARK: - Instance variables

    private var viewModel: FeedbackErrorViewModel!

    private let localContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(packageResource: Image.error, ofType: .png)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = FeedbackErrorRouter(viewController: self)
        viewModel = FeedbackErrorViewModel(router: router)
        errorTitleLabel.text = errorTitle
        descriptionLabel.text = descriptionMessage
        containerStackView.addArrangedSubview(localContainerView)
        localContainerView.addSubview(errorTitleLabel)
        localContainerView.addSubview(errorImageView)
        localContainerView.addSubview(descriptionLabel)
        setupConstraints()
    }

    override func crossButtonAction() {
        viewModel.dismisViewController()
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        errorTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(errorImageView.snp.top).offset(-16)
            make.leading.trailing.equalTo(localContainerView)
            make.height.equalTo(32)
        }
        errorImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(localContainerView)
            make.height.width.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(localContainerView)
            make.height.equalTo(16)
        }
    }
}
