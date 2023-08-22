//
//  GameScene.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 31.07.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //MARK: - var/let
    var starfield: SKEmitterNode!
    var spaceShip: SKSpriteNode!
    var scoreTable = SKLabelNode(text: "Счет: 0")
    var score: Int = 0 {
        didSet{
            scoreTable.text = "Счет: \(score)"
        }
    }
    var scoreTimer:Timer!
    var speedAttackTimer:Timer!
    
    var enemies = ["enemy1", "enemy2", "enemy3", "enemy4", "enemy5", "enemy6"]
    
    var heartsArray:[SKSpriteNode] = []
    var lifeScore:Int = 0
       
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setUserInterface()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionControll(contact: contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            spaceShip.run(SKAction.move(to: touch.location(in: self), duration: 0.1))
        }
    }
    
    //MARK: - Set functions
    func setUserInterface(){
        playBackgroundSong()
        setStarfield()
        setSpaceShip()
        lifeScore = 5
        setHearts(count: lifeScore)
        setScoreTable()
        setTimer()
        setSpeedAttack(speedAttack: 3)
    }
    
    func setHearts(count lifeScore: Int){
        var indentX:CGFloat = 100
        for _ in 1...lifeScore{
            let  heart = SKSpriteNode(imageNamed: "heart_set")
            heart.position = CGPoint(x: -self.frame.size.width/2 + indentX, y: self.frame.size.height/2 - 100)
            heart.size = CGSize(width: 30, height: 30)
            heart.zPosition = 1
            indentX += heart.size.width + 20
            heartsArray.append(heart)
        }
        heartsArray.forEach({self.addChild($0)})
    }
    
    func setScoreTable(){
        score = 0
        scoreTable = SKLabelNode(text: "Счет: 0")
        scoreTable.fontName = "AmericanTypewriter-Bold"
        scoreTable.fontSize = 36
        scoreTable.fontColor = .cyan
        scoreTable.position = CGPoint(x: self.frame.midX, y: self.frame.size.height/2 - 200)
        scoreTable.zPosition = 1
        self.addChild(scoreTable)
    }
    
    func setSpaceShip(){
        spaceShip = SKSpriteNode(imageNamed: "space_ship")
        spaceShip.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        spaceShip.setScale(0.7)
        self.addChild(spaceShip)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody?.categoryBitMask = ObjcCategories.spaceShipCategory
        spaceShip.physicsBody?.contactTestBitMask = ObjcCategories.enemyCategory
        spaceShip.physicsBody?.collisionBitMask = 0
    }
    
    func setStarfield(){
        let background = SKSpriteNode(imageNamed: "space_bg")
        background.zPosition = -2
        self.addChild(background)
        
        starfield = SKEmitterNode(fileNamed: "starfield_bg")
        starfield.position = CGPoint(x: size.width/2, y: size.height/2)
        starfield.zPosition = -1
        starfield.advanceSimulationTime(2)
        self.addChild(starfield)
    }
    
    func setGameOverView(){
        
        let gameOverView = UIView()
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        
        let gameOverLabel = UILabel()
        gameOverLabel.text = "Game over"
        gameOverLabel.font = UIConstraintsConstants.gameOverFontUIFont
        gameOverLabel.textColor = .red
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameOverView.addSubview(gameOverLabel)
        
        NSLayoutConstraint.activate([
            gameOverView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            gameOverView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        
        let buttonBackToMainMenu = UIButton()
        buttonBackToMainMenu.setTitle("Main menu", for: .normal)
        
    }
    
    
    //MARK: - Timers
    
    func setTimer(){
        scoreTimer = Timer.scheduledTimer(timeInterval: GameplayConstants.animTimeIntervalEnemy, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
    }
    
    func setSpeedAttack(speedAttack:TimeInterval){
        speedAttackTimer = Timer.scheduledTimer(timeInterval: speedAttack, target: self, selector: #selector(openFire), userInfo: nil, repeats: true)
    }
    
    
    
    //MARK: - objc functions
    @objc func addEnemy(){
        enemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemies) as! [String]
        let enemy = SKSpriteNode(imageNamed: enemies[0])
        
        let pos = randomisePos()
        
        enemy.position = CGPoint(x: pos, y: self.size.height/2)
        enemy.setScale(Double.random(in: 0.8...1.5))
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        
        enemy.physicsBody?.categoryBitMask = ObjcCategories.enemyCategory
        enemy.physicsBody?.contactTestBitMask = ObjcCategories.bulletCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: pos, y: -self.size.height/2), duration: GameplayConstants.animDurationEnemy))
        actions.append(SKAction.removeFromParent())
        enemy.run(SKAction.sequence(actions))
        
    }
    
    @objc func openFire(){
        self.run(SKAction.playSoundFileNamed("openFire_sound", waitForCompletion: false))
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.position = spaceShip.position
        bullet.position.y += 40
        bullet.setScale(3)
        bullet.zRotation = 1.57
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = ObjcCategories.bulletCategory
        bullet.physicsBody?.contactTestBitMask = ObjcCategories.enemyCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: spaceShip.position.x, y: self.size.height/2), duration: GameplayConstants.animDurationBullet))
        actions.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actions))
    }
    
    //MARK: - Functions
    
    func playBackgroundSong(){
        guard let playSong = SKAction.playSoundFileNamed("background_soundtrack", waitForCompletion: true) as SKAction? else {return}
        self.run(SKAction.repeatForever(playSong))
    }
    
    func randomisePos() -> CGFloat{
        let randomPos = GKRandomDistribution(lowestValue: Int(-self.size.width/2 + 150), highestValue: Int(self.frame.width/2 - 150))
        return CGFloat(randomPos.nextInt())
    }
    
    
    
    //MARK: - Collision functions
    
    func collisionControll(contact: SKPhysicsContact){
        let twoObjcSet: Set<UInt32> = [contact.bodyA.categoryBitMask , contact.bodyB.categoryBitMask]
        
        switch twoObjcSet{
        case [ObjcCategories.enemyCategory, ObjcCategories.bulletCategory]:
            do{
                collisionEnemyAndBullet(bodyANode: contact.bodyA.node as! SKSpriteNode, bodyBNode: contact.bodyB.node as! SKSpriteNode)
            }
        case [ObjcCategories.spaceShipCategory, ObjcCategories.enemyCategory]:
            do{
                collisionEnemyAndSpaceship(bodyANode: contact.bodyA.node as! SKSpriteNode, bodyBNode: contact.bodyB.node as! SKSpriteNode)
            }
        default:
            return
        }
    }
    
    func collisionEnemyAndBullet(bodyANode: SKSpriteNode, bodyBNode: SKSpriteNode){
        
        var enemyBody: SKSpriteNode
        var bulletBody: SKSpriteNode
        
        if bodyANode.physicsBody?.categoryBitMask == ObjcCategories.enemyCategory {
            enemyBody = bodyANode
            bulletBody = bodyBNode
        } else {
            enemyBody = bodyBNode
            bulletBody = bodyANode
        }
        
        let explosion = SKEmitterNode(fileNamed: "explosionParticle")
        explosion?.position = enemyBody.position
        explosion?.setScale(0.8)
        self.addChild(explosion!)
        self.run(SKAction.playSoundFileNamed("explosion_sound", waitForCompletion: false))
        
        enemyBody.removeFromParent()
        bulletBody.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
        score += 5
    }
    
    
    func collisionEnemyAndSpaceship(bodyANode: SKSpriteNode, bodyBNode: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "explosionParticle")
        let secondExplosion = SKEmitterNode(fileNamed: "explosionParticle")
        var spaceshipBody: SKSpriteNode
        var enemyBody: SKSpriteNode
        
        if bodyANode.physicsBody?.categoryBitMask == ObjcCategories.spaceShipCategory {
            spaceshipBody = bodyANode
            enemyBody = bodyBNode
        } else {
            spaceshipBody = bodyBNode
            enemyBody = bodyANode
        }
        
        explosion?.position = spaceshipBody.position
        explosion?.setScale(0.8)
        self.addChild(explosion!)
        secondExplosion?.position = enemyBody.position
        secondExplosion?.setScale(0.8)
        self.addChild(secondExplosion!)
        
        self.run(SKAction.playSoundFileNamed("explosion_sound", waitForCompletion: false))
        
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
            secondExplosion?.removeFromParent()
        }
        
        if lifeScore <= 0 {
            spaceshipBody.removeFromParent()
            enemyBody.removeFromParent()
            endGame()
        } else {
            enemyBody.removeFromParent()
            lifeScore -= 1
            heartsArray.last?.removeFromParent()
            heartsArray.removeLast()
        }
    }
    
    func endGame(){
        speedAttackTimer.invalidate()
        let gameOverView = GameOverView.instatceFromNib()
        
    }
}
