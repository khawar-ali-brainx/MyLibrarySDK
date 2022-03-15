//
//  FloatingButtonController.swift
//
//
//  Created by BrainX 3096 on 17/02/2022.
//

import UIKit

enum FloatingButtonRouteType: RouteType {
    case languageSelectionView(data: Any? = nil)
}

class FloatingButtonViewController: BaseViewController {
    // MARK: - Instance Variables

    private var viewModel: FloatingButtonViewModel!
    private let window = FeedbackWindow.shared
    private var sockets: [CGPoint] {
        let buttonSize = feedbackButton.bounds.size
        let rect = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: -2 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let sockets: [CGPoint] = [
            CGPoint(x: UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? rect.maxX : rect.minX, y: rect.minY),
            CGPoint(x: UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? rect.maxX : rect.minX, y: rect.maxY),
            CGPoint(x: UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? rect.maxX : rect.minX, y: rect.midY),
        ]
        return sockets
    }

    let feedbackButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(packageResource: UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? Image.feedback : Image.feedbackRTL, ofType: .png) {
            button.setImage(image, for: .normal)
        }
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.maxX - button.bounds.size.width, y: UIScreen.main.bounds.maxY / 2), size: button.bounds.size)
        button.autoresizingMask = []
        return button
    }()

    // MARK: - Init Methods

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        window.windowLevel = UIWindow.Level(CGFloat.greatestFiniteMagnitude)
        window.isHidden = false
        let navRootController = UINavigationController(rootViewController: self)
        navRootController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navRootController
        window.floatingButtonController = self
        window.makeKeyAndVisible()
    }

    @available(iOS 13.0, *)
    func setWindowScene(windowScene: UIWindowScene){
        window.windowScene = windowScene
    }
    
    // MARK: - Override Methods

    override func loadView() {
        let router = FloatingButtonRouter(viewController: self)
        viewModel = FloatingButtonViewModel(router: router)
        let view = UIView()
        feedbackButton.addTarget(self, action: #selector(floatingButtonWasTapped), for: .touchUpInside)
        view.addSubview(feedbackButton)
        self.view = view
        let panner = UIPanGestureRecognizer(target: self, action: #selector(panDidFire))
        feedbackButton.addGestureRecognizer(panner)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        snapButtonToSocket()
    }

    // MARK: - Private Methods

    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let centre = feedbackButton.center
        for socket in sockets {
            let distance = hypot(centre.x - socket.x, centre.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        feedbackButton.center = bestSocket
    }

    // MARK: - Action Methods

    @objc
    func floatingButtonWasTapped() {
        FeedbackWindow.shared.isFeedbackViewVisible.toggle()
        viewModel.showLanguageSelectionView()
    }

    @objc
    func panDidFire(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        var centre = feedbackButton.center
        centre.y += offset.y
        feedbackButton.center = centre
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
    }
}
