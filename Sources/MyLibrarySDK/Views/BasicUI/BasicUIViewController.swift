//
//  BasicUIViewController.swift
//
//
//  Created by BrainX 3096 on 17/02/2022.
//

import SnapKit
import UIKit

class BasicUIViewController: BaseViewController {
    // MARK: - Instance Variables

    private var viewModel: BasicUIViewModel!

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        if let blueBg = UIImage(packageResource: UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? Image.blueBg : Image.blueBgRTL, ofType: .png) {
            imageView.image = blueBg
        }
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let smilyImageView: UIImageView = {
        let imageView = UIImageView()
        if let smilyBg = UIImage(packageResource: Image.smilyBg, ofType: .png) {
            imageView.image = smilyBg
        }
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let crossButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: Image.cross, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - Override Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let router = BasicUIRouter(viewController: self)
        viewModel = BasicUIViewModel(router: router)
        crossButton.addTarget(self, action: #selector(crossButtonAction), for: .touchUpInside)
        backgroundImageView.addSubview(smilyImageView)
        view.addSubview(backgroundImageView)
        view.addSubview(crossButton)
        view.addSubview(containerStackView)
        setupConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view)
        }

        smilyImageView.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundImageView).offset(30)
            make.bottom.equalTo(backgroundImageView).offset(20)
            make.width.height.equalTo(200)
        }

        crossButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalTo(backgroundImageView).offset(view.frame.maxX / 100 * 8.5)
            make.centerY.equalTo(backgroundImageView)
        }

        containerStackView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.height.lessThanOrEqualTo(400)
            make.leading.equalTo(crossButton.snp.trailing).offset(16)
            make.trailing.equalTo(view).offset(-32)
        }
    }

    // MARK: - Action Methods

    @objc
    func crossButtonAction() {
        FeedbackWindow.shared.isFeedbackViewVisible.toggle()
        viewModel.dismisViewController()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
