//
//  LoadingViewController.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import UIKit
import SnapKit

class LoadingViewController: UIViewController {

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImage)
        view.addSubview(logoImage)
        view.addSubview(loadingTitle)
        view.sendSubviewToBack(backgroundImage)
        setContentConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let vc = GameViewController()
            vc.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(vc, animated: true)
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
}
