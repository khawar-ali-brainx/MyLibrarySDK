//
//  TextView.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import UIKit

class TextView: UIView {
    // MARK: - Instance variables

    var selectedLanguage: SupportedLanguages = LanguageSelectionViewController.feedbackLanguage
    var createVC: CreateFeedbackViewController!

    private let folderName = "SavedFiles"
    private  let fileName = "Feedback.txt"
    private let maxCharacterLimit = 500

    var selectedMessage: String? {
        didSet {
            guard let message = selectedMessage else { return }
            let isEnabled = !message.trimmingCharacters(in: .whitespaces).isEmpty
            submitButton.isEnabled = isEnabled
            submitButton.alpha = isEnabled ? 1 : 0.5
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
        label.text = LocalizeKey.enterYourFeedback.string
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.setBorderColor(UIColor.gray, andWidth: 1)
        textView.setCornerRadius(8)
        return textView
    }()

    private let numberOfCharactersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .right
        return label
    }()

    private let switchKeyboardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalizeKey.switchTo.string, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        if let image = UIImage(packageResource: Image.keyboard, ofType: .png) {
            button.addRightIcon(image, withSize: CGSize(width: 20, height: 12))
        }
        button.addTarget(self, action: #selector(handleKeyboardSwitch), for: .touchUpInside)
        return button
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
        numberOfCharactersLabel.text = "0/\(maxCharacterLimit) \(LocalizeKey.characters.string)"
        messageTextView.delegate = self
        addSubview(titleLabel)
        addSubview(messageTextView)
        addSubview(numberOfCharactersLabel)
        addSubview(switchKeyboardButton)
        addSubview(addAttachmentButton)
        addSubview(submitButton)
        setupConstraints()
        updateSwitchToLanguageTitle()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(32)
        }
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.bottom.equalTo(numberOfCharactersLabel.snp.top).offset(-4)
        }
        switchKeyboardButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberOfCharactersLabel)
            make.width.equalTo(116)
            make.trailing.equalTo(self).offset(-16)
        }
        numberOfCharactersLabel.snp.makeConstraints { make in
            make.bottom.equalTo(addAttachmentButton.snp.top).offset(-8)
            make.leading.equalTo(self).offset(16)
        }
        addAttachmentButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.leading.equalTo(self)
            make.bottom.equalTo(submitButton.snp.top).offset(-8)
        }
        submitButton.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(11)
            make.trailing.equalTo(self).offset(-11)
            make.bottom.equalTo(self).offset(-11)
            make.height.equalTo(38)
        }
    }

    private func updateSwitchToLanguageTitle() {
        var switchSelectedLanguage: SupportedLanguages
        if LanguageSelectionViewController.feedbackLanguage == .english {
            switchSelectedLanguage = selectedLanguage == .english ? .arabic : .english
        } else {
            switchSelectedLanguage = selectedLanguage == .english ? LanguageSelectionViewController.feedbackLanguage : .english
        }
        let title = NSMutableAttributedString()
            .custom(LocalizeKey.switchTo.string, font: UIFont.systemFont(ofSize: 8), color: .darkGray)
            .custom(Constants.oneSpace, font: UIFont.systemFont(ofSize: 8), color: .darkGray)
            .custom(switchSelectedLanguage.languageName, font: UIFont.systemFont(ofSize: 10), color: .black)
        switchKeyboardButton.setAttributedTitle(title, for: .normal)
    }

    // MARK: - Action methods

    @objc
    func handleSubmit() {
        guard let message = selectedMessage, !message.trimmingCharacters(in: .whitespaces).isEmpty, message.trimmingCharacters(in: .whitespaces).count >= 6 else {
            createVC.showAlertView(message: LocalizeKey.atLeast6CharactersMessage.string, title: LocalizeKey.alert.string)
            return
        }
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folderName) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileName)
        try? message.write(to: file, atomically: false, encoding: String.Encoding.utf8)
        let feedback = Feedback(textFileUrl: file)
        createVC.submitFeedback(feedback, withAttachmentAllowed: isAttachmentAllowed)
    }

    @objc
    func handleKeyboardSwitch() {
        messageTextView.resignFirstResponder()
        if LanguageSelectionViewController.feedbackLanguage == .english {
            selectedLanguage = selectedLanguage == .english ? .arabic : .english
        } else {
            selectedLanguage = selectedLanguage == .english ? LanguageSelectionViewController.feedbackLanguage : .english
        }
        messageTextView.becomeFirstResponder()
        updateSwitchToLanguageTitle()
    }

    @objc
    func handleAddAttachment() {
        isAttachmentAllowed.toggle()
    }
}

// MARK: - UITextViewDelegate Methods

extension TextView: UITextViewDelegate {
    override var textInputMode: UITextInputMode? {
        let locale = Locale(identifier: selectedLanguage.languageCode)
        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode })
            ??
            super.textInputMode
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == messageTextView {
            selectedMessage = textView.text.isEmpty ? nil : textView.text
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = LocalizeKey.empty.string
            textView.textColor = UIColor.black
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        numberOfCharactersLabel.text = "\(numberOfChars)/\(maxCharacterLimit) \(LocalizeKey.characters.string)"
        return numberOfChars < maxCharacterLimit
    }
}
