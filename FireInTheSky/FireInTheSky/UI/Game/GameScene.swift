//
//  GameScene.swift
//  FireInTheSky
//
//  Created by Andrew Johnson on 2/25/18.
//  Copyright © 2018 Andrew Johnson. All rights reserved.
//

import SpriteKit

/**
    The Fire In The Sky game scene that is responbile soley for running the game.
    The game menu triggered in game is driven by the containing view via a delegate.
 */
final class GameScene: SKScene {
    
    enum Layer: CGFloat {
        case sceneBackground, platformBackground, platformMiddleground,
        platformForeground, foreground, menu
    }
    
    // MARK: - Properties
    
    private lazy var startButton: Button = {
        let texture = SKTexture(imageNamed: "baseline_replay_black")
        let size = CGSize(width: 56, height: 56)
        let button = Button(texture: texture, color: .black, size: size)
        button.zPosition = Layer.menu.rawValue
        button.onButtonTapped = { [weak self] in
            self?.playFeedback()
            self?.startGame()
            button.removeFromParent()
        }
        return button
    }()
    private let highScoreLabel = ClockLabelNode()
    private var clock: ClockLabelNode!
    private var ground: SKSpriteNode!
    private var player: Player!
    private var spitFirePool = RecyclingBin<SpitFire>()
    private let moveGesture = UITapGestureRecognizer(target: nil, action: nil)
    private var isGameStarted = false
    
    lazy var actionFactory = GameSceneActionFactory()
    lazy var physicsHandler = GameScenePhysicsHandler(delegate: self)
    
    
    // MARK: - Lifecycle
    
    override init(size: CGSize) {
        super.init(size: size)
        initGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addMoveGesture()
        if isGameStarted {
            isPaused = false
        } else {
            showMenu()
        }
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        isPaused = true
    }
}


// MARK: - Game Logic

extension GameScene {
    
    /**
        Triggers the sequence of fire drops and general game logic.
     */
    func makeItRainHell() {
        let hellFire = actionFactory.makeItRainHell(onSpitFire: addSpitFire)
        run(hellFire)
    }
    
    /**
        Adds a single fire drop, randomly, to the top of the scene.
     */
    func addSpitFire() {
        let width = UInt32(frame.size.width)
        let maxX = width
        let randomX = arc4random_uniform(maxX)
        addSpitFire(at: CGFloat(randomX))
    }
    
    /**
        Adds a single fire drop to the top of scene at the given X position.
     
        - Parameters:
            - x: The x position in the scene to place the fire drop at.
     */
    func addSpitFire(at x: CGFloat) {
        let size = CGSize(width: 6, height: 12)
        let position = CGPoint(x: x, y: frame.size.height)
        let spitFire = spitFirePool.reuseObject { spitFire in
            if let spitFire = spitFire {
                spitFire.position = position
                spitFire.physicsBody?.velocity = CGVector.zero
                return spitFire
            } else {
                return SpitFire(size: size, position: position)
            }
        }
        addChild(spitFire)
    }
    
    /**
        Removes a fire drop sprite node from the scene by removing
        descendent nodes as well.
     */
    func removeSpitFire(_ spitFire: SpitFire) {
        spitFire.removeAllChildren()
        spitFire.removeFromParent()
    }
    
    func recycleSpitFire(_ spitFire: SpitFire) {
        spitFire.removeFromParent()
        spitFirePool.recycleObject(spitFire)
    }
    
    func clearSpitFires() {
        spitFirePool.dispose { spitFires in
            for child in self.children {
                guard let spitFire = child as? SpitFire else {
                    continue
                }
                self.removeSpitFire(spitFire)
            }
        }
    }
    
    /**
        Starts the timer by triggering model and UI updates every second.
        This should be called when the game is started.
     */
    func startTimer() {
        let interval = 1.0
        let timer = actionFactory.makeTimer(interval: interval) {
            self.clock.elapsedTime += interval
        }
        run(timer)
    }
    
    func playFeedback() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator().impactOccurred()
        }
    }
}


// MARK: - Gestures

extension GameScene {
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        let velocityX = player.physicsBody?.velocity.dx ?? 0
        let direction = velocityX > 0 ? Player.Direction.left : .right
        if player.move(direction) {
            playFeedback()
        }
    }
}


// MARK: - Lifecycle Controls

private extension GameScene {
    
    /**
        Creates the intial content of the game scene. This should only be
        called once when the scene loads.
     */
    func initGame() {
        setupPhysicsWorld()
        addMoveGesture()
        addBackground()
        addTimer()
        addGround()
        addLava()
        addPlayer()
    }
    
    func startGame() {
        isGameStarted = true
        // Reset and reposition sprites
        highScoreLabel.removeFromParent()
        player.position = playerStartPosition
        player.isHidden = false
        player.removeAllChildren()
        clearSpitFires()
        
        // Reset game state
        moveGesture.isEnabled = true
        clock.elapsedTime = 0
        
        // Start all initial actions
        isPaused = false
        startTimer()
        _ = player.move(.left)
        makeItRainHell()
    }
    
    func endGame() {
        isGameStarted = false
        moveGesture.isEnabled = false
        removeAllActions()
        self.isPaused = true
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.showMenu()
    }
    
    
    // MARK: - Menu
    
    /**
        Prompts the game over menu and stops the scene.
     */
    func showMenu() {
        // Set the record
        if RecordManager.shared.shouldSetRecord(score: clock.elapsedTime) {
            // TODO: Prompt name entry
            let record = Record(name: nil, score: clock.elapsedTime)
            RecordManager.shared.highScore = record
        }
        
        addStartButtonIfNeeded()
        addHighScoreLabelIfNeeded()
    }
}


// MARK: - Sprite Setup

private extension GameScene {
    
    var playerStartPosition: CGPoint {
        return CGPoint(x: ground.frame.midX,
                       y: ground.frame.maxY)
    }
    
    /**
        Configures the phyiscs world for the scene.
     */
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        physicsWorld.contactDelegate = physicsHandler
    }
    
    /**
        Adds a gesture recognizer to the scene's view that allows the player
        to move left and right.
    */
    func addMoveGesture() {
        let isGestureAdded = self.view?.gestureRecognizers?.contains(moveGesture) ?? true
        guard isGestureAdded else {
            return
        }
        moveGesture.addTarget(self, action: #selector(didTap(_:)))
        moveGesture.isEnabled = false
        view?.addGestureRecognizer(moveGesture)
    }
    
    /**
        Adds and configures a static background to the game scene.
     */
    func addBackground() {
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "Volcano"), color: .blue, size: frame.size)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        bg.zPosition = -10///Layer.sceneBackground.rawValue
        addChild(bg)
    }
    
    /**
        Adds and configures a ground sprite that the player can move back and forth on.
     */
    func addGround() {
        let size = CGSize(width: frame.size.width/1.5, height: frame.size.height/2)
        let position = CGPoint(x: frame.size.width/2, y: size.height/2)
        ground = SpriteFactory.makeGround(withSize: size, at: position)
        ground.zPosition = Layer.platformForeground.rawValue
        addChild(ground)
        
        let grassSize = CGSize(width: ground.size.width, height: 40)
        let foregroundPosition = CGPoint(x: ground.position.x, y: ground.frame.maxY + grassSize.height / 4)
        
        let foregroundGrass = SKSpriteNode(texture: SKTexture(imageNamed: "ForegroundGrass"), size: grassSize)
        foregroundGrass.zPosition = Layer.platformForeground.rawValue
        foregroundGrass.position = foregroundPosition
        addChild(foregroundGrass)
        
        let backgroundPosition = CGPoint(x: foregroundPosition.x, y: foregroundPosition.y + grassSize.height / 16)
        let backgroundGrass = SKSpriteNode(texture: SKTexture(imageNamed: "BackgroundGrass"), size: grassSize)
        backgroundGrass.zPosition = Layer.platformBackground.rawValue
        backgroundGrass.position = backgroundPosition
        addChild(backgroundGrass)
    }
    
    /**
        Adds a floor sprite that acts as lava. The lava is responsible for ending the scene when
        the player touches it, and for eliminating fire drops.
     */
    func addLava() {
        addFloorLava()
        addSideLava(isLeft: true)
        addSideLava(isLeft: false)
    }
    
    func addFloorLava() {
        let lavaSize = CGSize(width: frame.size.width * 2, height: 1)
        let lavaPosition = CGPoint(x: frame.size.width / 2, y: -1)
        let lava = SpriteFactory.makeLava(withSize: lavaSize, at: lavaPosition)
        lava.zPosition = Layer.foreground.rawValue
        addChild(lava)
    }
    
    func addSideLava(isLeft: Bool) {
        let xPosition = isLeft ? -60 : frame.size.width + 60
        let lavaSize = CGSize(width: 1, height: frame.size.height)
        let lavaPosition = CGPoint(x: xPosition, y: frame.size.height / 2)
        let lava = SpriteFactory.makeLava(withSize: lavaSize, at: lavaPosition)
        lava.zPosition = Layer.foreground.rawValue
        addChild(lava)
    }
    
    /**
        Adds a player sprite to the center, above the ground sprite.
    */
    func addPlayer() {
        let size = CGSize(width: 24, height: 36)
        player = Player(size: size, position: playerStartPosition)
        player.zPosition = Layer.platformMiddleground.rawValue
        addChild(player)
    }
    
    /**
        Adds a timer to the center-top of the scene. The timer acts as a shared element
        when the game over menu appears.
     */
    func addTimer() {
        let position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        clock = ClockLabelNode()
        clock.position = position
        addChild(clock)
    }
    
    func addStartButtonIfNeeded() {
        guard startButton.parent == nil else {
            return
        }
        startButton.position = CGPoint(x: ground.position.x, y: ground.position.y)
        addChild(startButton)
    }
    
    func addHighScoreLabelIfNeeded() {
        guard let highScore = RecordManager.shared.highScore?.score, highScore > 0,
            highScoreLabel.parent == nil else {
            return
        }
        let clockText = clockDisplayText(seconds: highScore)
        let options: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.yellow,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40)
        ]
        highScoreLabel.zPosition = Layer.menu.rawValue
        highScoreLabel.attributedText = NSAttributedString(string: clockText, attributes: options)
        highScoreLabel.position = startButton.position
        highScoreLabel.position.y += (startButton.size.height + 16)
        addChild(highScoreLabel)
    }
    
    func clockDisplayText(seconds: Double) -> String {
        let numberOfMinutes = Int(trunc(seconds/60))
        let numberOfSeconds = Int(trunc(seconds - Double(numberOfMinutes * 60)))
        return String(format: "%2d:%02d", numberOfMinutes, numberOfSeconds)
    }
}


// MARK: - Contact Delegate

extension GameScene: GameScenePhysicsHandlerDelegate {
    
    func onSpitFireExtinguished(_ spitFire: SpitFire) {
        recycleSpitFire(spitFire)
    }
    
    func onPlayerHit() {
        guard !player.isBurning else {
            return
        }
        moveGesture.isEnabled = false
        player.killPlayer(completion: endGame)
    }
}


// MARK: - Inner Types

private extension GameScene {
    /**
        Indicates the position the timer in the game scene can move to.
     */
    enum TimerPosition: Int {
        
        /// The return position of the timer which is at the top of the scene
        case returnPosition = 1
        
        /// The target position of the timer which is just below the menu view.
        case menuPosition = -1
    }
}
