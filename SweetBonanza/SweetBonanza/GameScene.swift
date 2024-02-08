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

    var vibroIsON: Bool = true
    var musicIsON: Bool = true

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
        view.position = CGPoint(x: 0, y: -self.size.width/2)
        view.size = CGSize(width: self.size.width - 20 , height: self.size.width/7)
        return view
    }()

    lazy var pauseButton: SKSpriteNode = {
        let view = SKSpriteNode(imageNamed: "pause")
        view.name = "pause"
        view.position = CGPoint(x: -self.size.width/2.5, y: self.size.height/2.5)
        view.size = CGSize(width: self.size.width/10 , height: self.size.width/10)
        return view
    }()

    lazy var dimSprite: SKSpriteNode = {
        let view = SKSpriteNode()
        view.color = UIColor.black.withAlphaComponent(0.5)
        view.size = .init(width: self.size.width, height: self.size.height)
        view.position = CGPoint(x: 0, y: 0)
        view.zPosition = 100000
        view.name = "dimSprite"
        return view
    }()

    lazy var bubblesBackground: SKSpriteNode = {
        let bubblesBackground = SKSpriteNode(imageNamed: "bubbles")
        bubblesBackground.position = CGPoint(x: 0, y: 0)
        bubblesBackground.zPosition = 0
        bubblesBackground.name = "bubles"
        bubblesBackground.size = .init(width: self.size.width * 2, height: self.size.height)
        return bubblesBackground
    }()

    // MARK: - Scene didMove

    override func didMove(to view: SKView) {
        addChild(container)
        addChild(scoreLabel)
        addChild(pauseButton)
        setBackground()
        createCardStack()
        containerFillWithHolders()
    }

    // MARK: - Sprite setters

    private func setBackground() {
        background.zPosition = -2
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

    private func containerFillWithHolders() {

        for i in 0...6 {
            let holder = SKSpriteNode(texture: SKTexture(imageNamed: "cardHolder"))
            holder.size = .init(width: self.size.width/10, height: self.size.width/10)
            holder.name = "holder\(i)"
            holder.zPosition = 1
            holder.position = CGPoint(x: startPosition, y: -self.size.width/2)
            startPosition = startPosition + (container.size.width - holder.size.width * 7)/8 + holder.size.width
            background.addChild(holder)
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


        guard let sprite = nodes(at: location).first as? SKSpriteNode else { return }

        switch sprite.name {
        case pauseButton.name:
            openSettings()

        case background.name:
            break

        case dimSprite.name, bubblesBackground.name:
            dismissSettings()

        case "vibroToggle":
            toggleSwitcher(sprite: sprite, toggle: &vibroIsON)

        case "musicToggle":
            toggleSwitcher(sprite: sprite, toggle: &musicIsON)

        default :
            guard location.y > -50 else { break }
            tappingOnCardAction(for: sprite)
        }
    }
}

extension GameScene {

    // MARK: - Actions

    private func tappingOnCardAction(for sprite: SKSpriteNode) {
        guard cardCount < 7 else { return }
        cardCount += 1
        sprite.removeFromParent()
        addCardToRemovedPosition(removed: sprite)
        container.addChild(sprite)
        if let oldPosition = removerPositions.first {
            sprite.position = oldPosition
            sprite.zPosition = 1
            removerPositions.removeFirst()
        } else {
            sprite.position = CGPoint(x: startPosition , y: 0)
            sprite.zPosition = 1
            startPosition = startPosition + (container.size.width - sprite.size.width * 7)/8 + sprite.size.width
        }
        findAndAddDuplicateNames(from: container.children)
        // FIXME: - add action
        if cardCount == 7 {
            looseAction()
        }
    }

    private func dismissSettings() {
        dimSprite.removeAllChildren()
        bubblesBackground.removeFromParent()
        dimSprite.removeFromParent()
    }

    private func addCardToRemovedPosition(removed: SKSpriteNode) {
        guard let name = cardsName.randomElement() else { return }
        let cardTexture = SKSpriteNode(texture: SKTexture(imageNamed: name))
        cardTexture.position = removed.position
        cardTexture.size = removed.size
        cardTexture.name = name
        addChild(cardTexture)
    }

    private func openSettings() {
        addChild(dimSprite)
        dimSprite.addChild(bubblesBackground)

        let frame = SKSpriteNode(imageNamed: "settings")
        frame.position = CGPoint(x: 0, y: 0)
        frame.zPosition = 1
        frame.size = .init(width: 200, height: 150)
        dimSprite.addChild(frame)

        let settingsTitle = SKSpriteNode(imageNamed: "settingsTitle")
        settingsTitle.position = CGPoint(x: 0, y: frame.size.height/2 + 40)
        settingsTitle.zPosition = 1
        settingsTitle.size = .init(width: 200, height: 50)
        dimSprite.addChild(settingsTitle)

        let music = SKSpriteNode(imageNamed: "music")
        music.position = CGPoint(x: 0, y: frame.size.height/2 - 25)
        music.zPosition = 2
        music.size = .init(width: 60, height: 20)
        frame.addChild(music)

        let musicToggle = SKSpriteNode(imageNamed: "switchON")
        musicToggle.position = CGPoint(x: 0, y: frame.size.height/4 - 15)
        musicToggle.zPosition = 2
        musicToggle.size = .init(width: 60, height: 20)
        musicToggle.name = "musicToggle"
        frame.addChild(musicToggle)

        let vibro = SKSpriteNode(imageNamed: "vibro")
        vibro.position = CGPoint(x: 0, y: -10)
        vibro.zPosition = 2
        vibro.size = .init(width: 60, height: 20)
        frame.addChild(vibro)

        let vibroToggle = SKSpriteNode(texture: SKTexture(imageNamed: "switchON"))
        vibroToggle.position = CGPoint(x: 0, y: -frame.size.height/4)
        vibroToggle.zPosition = 2
        vibroToggle.size = .init(width: 60, height: 20)
        vibroToggle.name = "vibroToggle"
        frame.addChild(vibroToggle)
    }

    private func findAndAddDuplicateNames(from array: [SKNode]) {
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

    private func clearStartParametrs() {
        container.removeAllChildren()
        score = 0
        cardCount = 0

        nameCount = [:]
        removerPositions = []
        startPosition = -container.size.width/2 + 30
        scoreLabel.text = "Score \(0)"
    }

    private func looseAction() {

        clearStartParametrs()
        addChild(dimSprite)
        dimSprite.addChild(bubblesBackground)

        let frame = SKSpriteNode(imageNamed: "settings")
        frame.position = CGPoint(x: 0, y: 0)
        frame.zPosition = 1
        frame.size = .init(width: 200, height: 150)
        dimSprite.addChild(frame)


        let title = SKLabelNode()
        title.position = CGPoint(x: 0, y: 0)
        title.fontColor = .black
        title.fontSize = 30
        title.zPosition = 2
        title.fontName = "Helvetica-Bold"
        title.text = "YOU LOSE"

        frame.addChild(title)

    }

    private func toggleMusic() {

    }

    private func toggleSwitcher(sprite: SKSpriteNode, toggle: inout Bool) {
        toggle.toggle()
        if toggle {
            sprite.texture = SKTexture(imageNamed: "switchON")
        } else {
            sprite.texture = SKTexture(imageNamed: "switchOFF")
        }
    }
}

