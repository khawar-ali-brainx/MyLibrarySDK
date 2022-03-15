import UIKit

public enum FeedbackSDK {
    public static func configure() {
        _ = FloatingButtonViewController()
    }
    
    @available(iOS 13.0, *)
    public static func configureWith(windowScene: UIWindowScene) {
        let viewController = FloatingButtonViewController()
        viewController.setWindowScene(windowScene: windowScene)
    }
}
