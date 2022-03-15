//
//  StarsView.swift
//
//
//  Created by BrainX 3096 on 26/02/2022.
//

import UIKit

class StarsView: UIView {
    // MARK: - Instance variables

    var thankYouVC: ThankYouViewController?
    var rating: Int = 0 {
        didSet {
            for i in 0 ..< 5 {
                guard let starImage = UIImage(packageResource: Image.star, ofType: .png), let emptyStarImage = UIImage(packageResource: Image.emptyStar, ofType: .png) else { return }
                starButtons[i].setImage(i < rating ? starImage : emptyStarImage, for: .normal)
            }
        }
    }

    private let starButtons: [UIButton]

    // MARK: - Init methods

    public init() {
        starButtons = (0 ..< 5).map { index in
            let button = UIButton(type: .custom)
            button.setImage(UIImage(packageResource: Image.star, ofType: .png), for: .normal)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(32)
            }
            button.tag = index + 1
            return button
        }
        super.init(frame: .zero)
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        for view in starButtons {
            view.addTarget(self, action: #selector(handleStarTaped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(view)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        starButtons = []
        super.init(coder: coder)
    }

    // MARK: - Action methods

    @objc
    func handleStarTaped(_ sender: UIButton) {
        rating = sender.tag
        thankYouVC?.updateRatingUIWith(rating)
    }
}
