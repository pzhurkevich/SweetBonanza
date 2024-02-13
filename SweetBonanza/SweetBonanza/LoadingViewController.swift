//
//  LoadingViewController.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import UIKit
import SnapKit
import SafariServices

final class LoadingViewController: UIViewController {

    private let gameController = GameViewController()

    private let buttonSize: CGSize = .init(width: 150.0, height: 50.0)
    private let logoImageStartSize: CGSize = .init(width: 100.0, height: 100.0)
    private let logoImageEndSize: CGSize = .init(width: 270.0, height: 270.0)
    private let loadingTitleSize: CGSize = .init(width: 100.0, height: 30.0)

    private let contentStackViewOffset: CGFloat = 80.0
    private let loadingTitleOffset: CGFloat = 70.0
    private let logoImageStartOffset: CGFloat = 800.0
    private let logoImageTopInset: CGFloat = 150.0

    private let privacyURL: String = "https://fakefiller.com/privacy"

    // MARK: - GUI variables

    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "loadingBG")
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logo")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var loadingTitle: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "loadingTitle")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "playButton")
        button.setBackgroundImage(image, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var privacyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "privacy")
        button.setBackgroundImage(image, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(privacyButtonTapped), for: .touchUpInside)
        return button
    }()


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(logoImage)
        view.addSubview(loadingTitle)
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(playButton)
        contentStackView.addArrangedSubview(privacyButton)
        view.sendSubviewToBack(backgroundImage)
        setContentConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatedLogoAppear()
        mainMenuAppear()
    }

    // MARK: - Constraints

    private func setContentConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(logoImageStartOffset)
            make.size.equalTo(logoImageStartSize)
        }
        loadingTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(loadingTitleOffset)
            make.size.equalTo(loadingTitleSize)
        }
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(contentStackViewOffset)
            make.centerX.equalToSuperview()
        }
        playButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
        }
        privacyButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
        }

    }

    private func afterLoadingConstraints() {
        self.logoImage.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(self.logoImageTopInset)
            make.size.equalTo(self.logoImageEndSize)
        }
        self.view.layoutIfNeeded()
    }

    // MARK: - Actions

    private func animatedLogoAppear() {

        UIView.animate(withDuration: 3) {
            self.logoImage.snp.updateConstraints { make in
                make.centerY.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.loadingTitle.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        })
    }

    private func mainMenuAppear() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.contentSettings([self.logoImage, self.loadingTitle], isHidden: true, alpha: 0)
            self.afterLoadingConstraints()

            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn, animations: {
                self.contentSettings([self.contentStackView, self.logoImage], isHidden: false, alpha: 1)
            })
        }
    }

    private func contentSettings(_ views: [UIView], isHidden: Bool, alpha: CGFloat) {
        views.forEach({ $0.isHidden = isHidden })
        contentStackView.alpha = alpha
        logoImage.alpha = alpha
    }
}

extension LoadingViewController {

    // MARK: - Button Actions

    @objc func playButtonTapped() {
        gameController.modalTransitionStyle = .flipHorizontal
        gameController.modalPresentationStyle = .fullScreen
        present(gameController, animated: true)
    }

    @objc func privacyButtonTapped() {
        if let url = URL(string: privacyURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true)
        }
    }
}
