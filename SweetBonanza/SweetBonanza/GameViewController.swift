//
//  GameViewController.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: - SKScene

    private lazy var skView: SKView = {
        let view = SKView()
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        let scene = SKScene(fileNamed: "GameScene")
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            scene.size = self.view.frame.size
            view.presentScene(scene)
        }
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.addSubview(skView)
        makeConstraints()
    }

    // MARK: - Constraints

    private func makeConstraints() {
        skView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

}
