//
//  VoiceView.swift
//
//
//  Created by BrainX 3096 on 23/02/2022.
//

import AVFoundation
import SwiftUI
import UIKit

enum RecordingStatus {
    case readyToRecord
    case recording
    case finished
    case readyToPlay
    case playing
    case paused
}

class VoiceView: UIView {
    // MARK: - Instance variables

    var createVC: CreateFeedbackViewController!
    private let oneMinute = 60
    private var recordingProgressInInt = 0
    private var audioProgressTimer: Timer?
    private var isRecordingAllowed: Bool = false
    private var recordingSession: AVAudioSession?
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var currentRecordingStatus: RecordingStatus = .readyToRecord {
        didSet {
            handleStatusUpdateWith(currentRecordingStatus)
        }
    }

    private var selectedAudioURL: URL? {
        didSet {
            submitButton.isEnabled = selectedAudioURL != nil ? true : false
            submitButton.alpha = selectedAudioURL != nil ? 1 : 0.5
            rerecordButton.isEnabled = selectedAudioURL != nil ? true : false
            rerecordButton.alpha = selectedAudioURL != nil ? 1 : 0.5
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
        label.text = LocalizeKey.recordYourAudio.string
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let voiceRecordingButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(packageResource: Image.recordAudio, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleRecordAction), for: .touchUpInside)
        return button
    }()

    private let progressView: CircularProgressView = {
        let progressView = CircularProgressView()
        progressView.isHidden = true
        return progressView
    }()

    private let recordingTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = Color.timerGray
        label.isHidden = true
        return label
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
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(reRecordAudio), for: .touchUpInside)
        return button
    }()

    private let submitButton: BlueGradientButton = {
        let button = BlueGradientButton(type: .system)
        button.setTitle(LocalizeKey.submit.string, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
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

    override func removeFromSuperview() {
        super.removeFromSuperview()
        stopPlayback()
        audioProgressTimer?.invalidate()
        audioRecorder?.stop()
    }

    // MARK: - Private methods

    private func setupView() {
        addSubview(titleLabel)
        addSubview(voiceRecordingButton)
        voiceRecordingButton.addSubview(progressView)
        addSubview(recordingTimerLabel)
        addSubview(addAttachmentButton)
        addSubview(rerecordButton)
        addSubview(submitButton)
        setupConstraints()
        setupRecordingAudio()
        progressView.radius = 60
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(32)
        }

        voiceRecordingButton.snp.makeConstraints { make in
            make.height.width.equalTo(112)
            make.centerX.equalTo(self)
            make.bottom.equalTo(recordingTimerLabel.snp.top).offset(-16)
        }

        progressView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(voiceRecordingButton)
        }

        recordingTimerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.height.equalTo(20)
            make.bottom.equalTo(addAttachmentButton.snp.top).offset(-8)
        }

        addAttachmentButton.snp.makeConstraints { make in
            make.height.equalTo(24)
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

    private func setupRecordingAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    self.isRecordingAllowed = allowed
                    if allowed {
                        self.voiceRecordingButton.isHidden = false
                    } else {
                        let errorMessage = ErrorMessageAndTitle(LocalizeKey.audioFeedback.string, LocalizeKey.noMicroPhoneDetected.string)
                        createVC.viewModel.showErrorViewWith(errorMessage: errorMessage)
                    }
                }
            }
        } catch {}
    }

    private func handleStatusUpdateWith(_ status: RecordingStatus) {
        switch status {
        case .readyToRecord:
            if let image = UIImage(packageResource: Image.recordAudio, ofType: .png) {
                voiceRecordingButton.setImage(image, for: .normal)
            }
        case .recording:
            if let image = UIImage(packageResource: Image.stopRecording, ofType: .png) {
                voiceRecordingButton.setImage(image, for: .normal)
            }
            startRecordingAudio()
        case .finished:
            finishRecording(success: true)
        case .readyToPlay:
            if let image = UIImage(packageResource: Image.playCircle, ofType: .png) {
                voiceRecordingButton.setImage(image, for: .normal)
            }
        case .playing:
            if let image = UIImage(packageResource: Image.pauseCircle, ofType: .png) {
                voiceRecordingButton.setImage(image, for: .normal)
            }
            startPlayback()
        case .paused:
            if let image = UIImage(packageResource: Image.resume, ofType: .png) {
                voiceRecordingButton.setImage(image, for: .normal)
            }
            pausePlayback()
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func startRecordingAudio() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: TimeInterval(oneMinute))
            progressView.isHidden = false
            recordingTimerLabel.isHidden = false
            progressView.progressAnimation(duration: TimeInterval(oneMinute))
            audioProgressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(recordingProgress), userInfo: nil, repeats: true)
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        guard let audioRecorder = audioRecorder else {
            return
        }
        audioRecorder.stop()
        progressView.isHidden = true
        recordingTimerLabel.isHidden = true
        recordingTimerLabel.text = "00:00"
        progressView.progressAnimation(duration: 0)
        audioProgressTimer?.invalidate()
        if success {
            guard recordingProgressInInt > 5 else {
                createVC.showAlertView(message: LocalizeKey.audioShouldBeMinimum5Seconds.string, title: LocalizeKey.alert.string)
                currentRecordingStatus = .readyToRecord
                recordingProgressInInt = 0
                selectedAudioURL = nil
                return
            }
            selectedAudioURL = audioRecorder.url
            currentRecordingStatus = .readyToPlay
        } else {
            currentRecordingStatus = .readyToRecord
        }
        recordingProgressInInt = 0
        audioPlayer = try? AVAudioPlayer(contentsOf: audioRecorder.url)
        audioPlayer?.delegate = self
        self.audioRecorder = nil
    }

    private func startPlayback() {
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        audioPlayer?.play()
        if let duration = audioPlayer?.duration {
            audioProgressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(playbackInProgress), userInfo: nil, repeats: true)
            recordingTimerLabel.isHidden = false
            progressView.isHidden = false
            progressView.isPaused ? progressView.resumeAnimation() : progressView.progressAnimation(duration: duration)
        }
    }

    private func pausePlayback() {
        audioPlayer?.pause()
        audioProgressTimer?.invalidate()
        progressView.pauseLayer()
    }

    // MARK: - Public methods

    func stopPlayback() {
        recordingTimerLabel.isHidden = true
        progressView.isHidden = true
        audioPlayer?.stop()
        audioProgressTimer?.invalidate()
        recordingProgressInInt = 0
        progressView.stopLayer()
    }

    // MARK: - Action methods

    @objc
    func playbackInProgress() {
        recordingProgressInInt += 1
        let text = String(format: "%02d", recordingProgressInInt)
        recordingTimerLabel.text = "00:\(text)"
    }

    @objc
    func recordingProgress() {
        guard recordingProgressInInt < 59 else {
            currentRecordingStatus = .finished
            return
        }
        recordingProgressInInt += 1
        let text = String(format: "%02d", recordingProgressInInt)
        recordingTimerLabel.text = "00:\(text)"
    }

    @objc
    func handleSubmit() {
        stopPlayback()
        currentRecordingStatus = .paused
        guard let selectedAudioURL = selectedAudioURL else {
            return
        }
        let feedback = Feedback(audioFileUrl: selectedAudioURL)
        createVC.submitFeedback(feedback, withAttachmentAllowed: isAttachmentAllowed)
    }

    @objc
    func reRecordAudio() {
        switch currentRecordingStatus {
        case .readyToRecord, .finished, .readyToPlay:
            currentRecordingStatus = .recording
        case .recording:
            currentRecordingStatus = .finished
            currentRecordingStatus = .recording
        case .playing, .paused:
            stopPlayback()
            currentRecordingStatus = .recording
        }
    }

    @objc
    func handleRecordAction() {
        guard isRecordingAllowed else { return }
        switch currentRecordingStatus {
        case .readyToRecord:
            currentRecordingStatus = .recording
        case .recording:
            currentRecordingStatus = .finished
        case .readyToPlay, .paused:
            currentRecordingStatus = .playing
        case .playing:
            currentRecordingStatus = .paused
        default:
            break
        }
    }

    @objc
    func handleAddAttachment() {
        isAttachmentAllowed.toggle()
    }
}

extension VoiceView: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension VoiceView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        stopPlayback()
        currentRecordingStatus = .readyToPlay
    }
}
