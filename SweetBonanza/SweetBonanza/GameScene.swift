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
    var cardCount: Int = 0

    var nameCount: [String: Int] = [:]
    var removerPositions: [CGPoint] = []

    lazy var startPosition: CGFloat = -container.size.width/2 + 30

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

    // MARK: - Scene didMove

    override func didMove(to view: SKView) {
        addChild(container)
        addChild(scoreLabel)
        setBackground()
        createCardStack()
    }

    // MARK: - Sprite setters

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

    // MARK: - Touch Actions

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if container.children.isEmpty {
            removerPositions = []
            startPosition = -container.size.width/2 + 30
        }

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard location.y > -50 else { return }

        if let card = nodes(at: location).first as? SKSpriteNode, card.name != background.name {
            guard cardCount < 7 else { return }
            cardCount += 1
            card.removeFromParent()
            addCardToRemovedPosition(removed: card)
            container.addChild(card)
            if let oldPosition = removerPositions.first {
                card.position = oldPosition
                card.zPosition = 1
                removerPositions.removeFirst()
            } else {
                card.position = CGPoint(x: startPosition , y: 0)
                card.zPosition = 1
                startPosition = startPosition + (container.size.width - card.size.width * 7)/8 + card.size.width
            }
        }
        findAndAddDuplicateNames(from: container.children)


    // FIXME: - add action
        if cardCount == 7 {
            debugPrint("END")
        }
        debugPrint(container.children.count)
    }

}

extension GameScene {

    // MARK: - Actions

    private func addCardToRemovedPosition(removed: SKSpriteNode) {
        guard let name = cardsName.randomElement() else { return }
        let cardTexture = SKSpriteNode(texture: SKTexture(imageNamed: name))
        cardTexture.position = removed.position
        cardTexture.size = removed.size
        cardTexture.name = name
        addChild(cardTexture)
    }

    private func findAndAddDuplicateNames(from array: [SKNode]){
        var nameCount: [String: Int] = [:]
        var duplicateNodes: [SKNode] = []

        for node in array {
            if let name = node.name {
                nameCount[name, default: 0] += 1
            }
        }

        for node in array {
            if let name = node.name, nameCount[name]! >= 3 {
                duplicateNodes.append(node)
            }
        }
        if duplicateNodes.count == 3 {
            duplicateNodes.forEach { node in
                removerPositions.append(node.position)
                let scaleUpAction = SKAction.scale(to: 2.0, duration: 0.5)
                node.run(scaleUpAction) {
                    node.removeFromParent()
                }

            }
            score += 10
            cardCount = cardCount - 3
            scoreLabel.text = "Score \(score)"
        }
    }
}
