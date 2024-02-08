//
//  LoadingViewController.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import UIKit
import SnapKit

class LoadingViewController: UIViewController {

    let gameController = GameViewController()

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

    lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "playButton")
        button.setBackgroundImage(image, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var privacyButton: UIButton = {
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
        animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.logoImage.isHidden = true
            self.loadingTitle.isHidden = true
            self.contentStackView.isHidden = false
            self.logoImage.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(150)
                make.size.equalTo(270)
            }
            self.view.layoutIfNeeded()
            self.logoImage.isHidden = false
        }
    }

    // MARK: - Constraints

    private func setContentConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(800)
            make.size.equalTo(100)
        }
        loadingTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(70)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        contentStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
        }
        playButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        privacyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
        }

    }

    // MARK: - Actions

    private func animate() {

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

    @objc func playButtonTapped() {
        self.navigationController?.pushViewController(gameController, animated: true)
       }

    @objc func privacyButtonTapped() {
           print("Button tapped!") // Просто пример действия, которое будет выполнено при нажатии на кнопку
       }


}
