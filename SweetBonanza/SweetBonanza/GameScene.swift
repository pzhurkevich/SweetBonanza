//
//  GameScene.swift
//  SweetBonanza
//
//  Created by Pavel on 8.02.24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    // MARK: - Variables

    let cardsName = ["01", "02", "03", "04", "05", "06", "07", "08"]
    var score: Int = 0

    // MARK: - Sprite variables

    var background = SKSpriteNode(imageNamed: "mainBG")

    lazy var scoreLabel: SKLabelNode = {
        let view = SKLabelNode()
        view.position = CGPoint(x: 0.5, y: self.size.width/1.5)
        view.fontColor = .white
        view.fontSize = 30
        view.fontName = "Helvetica-Bold"
        view.text = "Score \(score)"
        return view
    }()

    lazy var container: SKSpriteNode = {
        let view = SKSpriteNode(imageNamed: "cardContainer")
        view.position = CGPoint(x: 0, y: -self.size.width/3)
        view.size = CGSize(width: self.size.width - 20 , height: self.size.width/7)
        return view
    }()

    override func didMove(to view: SKView) {
        addChild(container)
        addChild(scoreLabel)
        setBackground()
        createCardStack()
    }

    private func setBackground() {
            background.zPosition = -1
            background.size = CGSize(width: self.size.width, height: self.size.height)
            addChild(self.background)
    }

    private func createCardStack() {
        for i in stride(from: -self.size.width/3 + 40, to: self.size.width/3 - 40, by: self.size.width/7) {
            for j in stride(from: 0, to: self.size.width/2, by: self.size.width/7) {
                guard let name = cardsName.randomElement() else { return }
                let cardTexture = SKSpriteNode(texture: SKTexture(imageNamed: name))
                cardTexture.size = .init(width: self.size.width/10, height: self.size.width/10)
                cardTexture.name = name
                cardTexture.position = CGPoint(x: i, y: j)
                addChild(cardTexture)
            }
        }
    }
}
