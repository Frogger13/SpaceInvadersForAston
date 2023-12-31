//
//  GameScene.swift
//  SpaceInvadersForAston
//
//  Created by Данил Габдуллин on 31.07.2023.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    //MARK: - var/let
    let defaults = UserDefaults.standard
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
    
    var songAudioPlayer = AVAudioPlayer()
    var openFireAudioPlayer = AVAudioPlayer()
    var explosionAudioPlayer = AVAudioPlayer()
        
    weak var gameViewControlerDelegate: GameViewControllerDelegate?
       
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
        setHearts()
        setScoreTable()
        setEnemyTimerAppearence()
        setSpeedAttack()
    }
    
    func setHearts(){
        var indentX:CGFloat = 100
        lifeScore = defaults.integer(forKey: UserDefaultsKeys.lifeScore)
        if lifeScore > 0 {
            for _ in 1...lifeScore{
                let  heart = SKSpriteNode(imageNamed: "heart_set")
                heart.position = CGPoint(x: -self.frame.size.width/2 + indentX, y: self.frame.size.height/2 - 100)
                heart.size = CGSize(width: 30, height: 30)
                heart.zPosition = 1
                indentX += heart.size.width + 20
                heartsArray.append(heart)
            }
            heartsArray.forEach({self.addChild($0)})
        } else {
            return
        }
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
        if let spaceShipName = defaults.string(forKey: UserDefaultsKeys.spaceShipName){
            spaceShip = SKSpriteNode(imageNamed: spaceShipName)
        } else {
            spaceShip = SKSpriteNode(imageNamed: "space_ship")
        }
        spaceShip.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        spaceShip.size = CGSize(width: 100, height: 150)
        self.addChild(spaceShip)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody?.isDynamic = true
        spaceShip.physicsBody?.categoryBitMask = ObjcKeys.spaceShipCategory
        spaceShip.physicsBody?.contactTestBitMask = ObjcKeys.enemyCategory
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
    
    
    //MARK: - Timers
    
    func setEnemyTimerAppearence(){
        if let animTimeIntervalEnemy = defaults.object(forKey: UserDefaultsKeys.timeAppearenceInterval) as? Double {
            scoreTimer = Timer.scheduledTimer(timeInterval: animTimeIntervalEnemy, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        } else {
            scoreTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        }
    }
    
    func setSpeedAttack(){
        if let speedAttack = defaults.object(forKey: UserDefaultsKeys.speedAttack) as? Double {
            speedAttackTimer = Timer.scheduledTimer(timeInterval: speedAttack, target: self, selector: #selector(openFire), userInfo: nil, repeats: true)
        } else {
            speedAttackTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(openFire), userInfo: nil, repeats: true)
        }
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
        
        enemy.physicsBody?.categoryBitMask = ObjcKeys.enemyCategory
        enemy.physicsBody?.contactTestBitMask = ObjcKeys.bulletCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        var actions = [SKAction]()
        
        if let gameSpeed = defaults.object(forKey: UserDefaultsKeys.gameSpeed) as? Double {
            actions.append(SKAction.move(to: CGPoint(x: pos, y: -self.size.height/2), duration: gameSpeed))
        } else {
            actions.append(SKAction.move(to: CGPoint(x: pos, y: -self.size.height/2), duration: 10))
        }
        actions.append(SKAction.removeFromParent())
        enemy.run(SKAction.sequence(actions))
        
    }
    
    @objc func openFire(){
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "openFire_sound.mp3", ofType: nil)!)
        do {
            openFireAudioPlayer = try AVAudioPlayer(contentsOf: url)
            openFireAudioPlayer.prepareToPlay()
            if let volumeSong = defaults.object(forKey: UserDefaultsKeys.volumeSong) as? Float {
                openFireAudioPlayer.setVolume(volumeSong, fadeDuration: 0)
            } else {
                openFireAudioPlayer.setVolume(0.5, fadeDuration: 0)
            }
            openFireAudioPlayer.play()
        } catch {
            print("File download error")
        }
        
        
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.position = spaceShip.position
        bullet.position.y += 40
        bullet.setScale(3)
        bullet.zRotation = 1.57
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = ObjcKeys.bulletCategory
        bullet.physicsBody?.contactTestBitMask = ObjcKeys.enemyCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        
        var actions = [SKAction]()
        actions.append(SKAction.move(to: CGPoint(x: spaceShip.position.x, y: self.size.height/2), duration: 0.5))
        actions.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actions))
    }
    
    //MARK: - Functions
    
    func playBackgroundSong(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "background_soundtrack.mp3", ofType: nil)!)
        do {
            songAudioPlayer = try AVAudioPlayer(contentsOf: url)
            if let volumeSong = defaults.object(forKey: UserDefaultsKeys.volumeSong) as? Float {
                songAudioPlayer.setVolume(volumeSong, fadeDuration: 0)
                songAudioPlayer.play()
            } else {
                songAudioPlayer = try AVAudioPlayer(contentsOf: url)
                songAudioPlayer.setVolume(0.5, fadeDuration: 0)
                songAudioPlayer.play()
            }
        } catch {
            print("File download error")
        }
        
    }
    
    func randomisePos() -> CGFloat{
        let randomPos = GKRandomDistribution(lowestValue: Int(-self.size.width/2 + 150), highestValue: Int(self.frame.width/2 - 150))
        return CGFloat(randomPos.nextInt())
    }
    
    
    
    //MARK: - Collision functions
    
    func collisionControll(contact: SKPhysicsContact){
        let twoObjcSet: Set<UInt32> = [contact.bodyA.categoryBitMask , contact.bodyB.categoryBitMask]
        
        switch twoObjcSet{
        case [ObjcKeys.enemyCategory, ObjcKeys.bulletCategory]:
            do{
                collisionEnemyAndBullet(bodyANode: contact.bodyA.node as! SKSpriteNode, bodyBNode: contact.bodyB.node as! SKSpriteNode)
            }
        case [ObjcKeys.spaceShipCategory, ObjcKeys.enemyCategory]:
            do{
                collisionEnemyAndSpaceship(bodyANode: contact.bodyA.node as! SKSpriteNode, bodyBNode: contact.bodyB.node as! SKSpriteNode)
            }
        default:
            return
        }
    }
    
    func explosion(firstBody: SKSpriteNode, secondBody: SKSpriteNode, isSpaceshipCollision: Bool){
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "explosion_sound.mp3", ofType: nil)!)
        do {
            explosionAudioPlayer = try AVAudioPlayer(contentsOf: url)
            explosionAudioPlayer.prepareToPlay()
            if let volumeSong = defaults.object(forKey: UserDefaultsKeys.volumeSong) as? Float {
                explosionAudioPlayer.setVolume(volumeSong, fadeDuration: 0)
            } else {
                explosionAudioPlayer.setVolume(0.5, fadeDuration: 0)
            }
            explosionAudioPlayer.play()
        } catch {
            print("File download error")
        }
        
        let explosion = SKEmitterNode(fileNamed: "explosionParticle")
        explosion?.position = firstBody.position
        explosion?.setScale(0.8)
        self.addChild(explosion!)
        self.run(SKAction.wait(forDuration: 2)){
            explosion?.removeFromParent()
        }
        
        if isSpaceshipCollision{
            let secondExplosion = SKEmitterNode(fileNamed: "explosionParticle")
            secondExplosion?.position = secondBody.position
            secondExplosion?.setScale(0.8)
            self.addChild(secondExplosion!)
            self.run(SKAction.wait(forDuration: 2)){
                secondExplosion?.removeFromParent()
            }
        }
    }
    
    
    func collisionEnemyAndBullet(bodyANode: SKSpriteNode, bodyBNode: SKSpriteNode){
        var enemyBody: SKSpriteNode
        var bulletBody: SKSpriteNode
        
        if bodyANode.physicsBody?.categoryBitMask == ObjcKeys.enemyCategory {
            enemyBody = bodyANode
            bulletBody = bodyBNode
        } else {
            enemyBody = bodyBNode
            bulletBody = bodyANode
        }
        explosion(firstBody: enemyBody, secondBody: bulletBody, isSpaceshipCollision: false)
        enemyBody.removeFromParent()
        bulletBody.removeFromParent()
        score += 5
    }
    
    
    func collisionEnemyAndSpaceship(bodyANode: SKSpriteNode, bodyBNode: SKSpriteNode){
        var spaceshipBody: SKSpriteNode
        var enemyBody: SKSpriteNode
        
        if bodyANode.physicsBody?.categoryBitMask == ObjcKeys.spaceShipCategory {
            spaceshipBody = bodyANode
            enemyBody = bodyBNode
        } else {
            spaceshipBody = bodyBNode
            enemyBody = bodyANode
        }
        
        explosion(firstBody: spaceshipBody, secondBody: enemyBody, isSpaceshipCollision: true)
        
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
    
    func saveNewRecord(){
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        
        let recordForSave = RecordModel(name: defaults.string(forKey: UserDefaultsKeys.playerName) ?? "Name", score: self.score, spaceShip: defaults.string(forKey: UserDefaultsKeys.spaceShipName) ?? SpaceshipNames.classic.rawValue)
        
        if var recordsArrayData = defaults.array(forKey: UserDefaultsKeys.recordsArray) as? Array<Data>{
            var recordsArrayRecordModel = Array<RecordModel>()
            recordsArrayData.forEach({
                try? recordsArrayRecordModel.append(decoder.decode(RecordModel.self, from: $0))
            })
            recordsArrayRecordModel.append(recordForSave)
            recordsArrayRecordModel.sort(by: {
                $0.score > $1.score
            })
            recordsArrayRecordModel.removeLast()
            
            recordsArrayData.removeAll()
            recordsArrayRecordModel.forEach({
                try? recordsArrayData.append(encoder.encode($0))
            })
            
            defaults.set(recordsArrayData, forKey: UserDefaultsKeys.recordsArray)
        } else {
            let emptyRecordsArray = Array<Data>(repeating: try! encoder.encode(RecordModel(name: "", score: 0, spaceShip: "")), count: 10)
            defaults.set(emptyRecordsArray, forKey: UserDefaultsKeys.recordsArray)
        }
    }
    
    func endGame(){
        songAudioPlayer.stop()
        saveNewRecord()
        speedAttackTimer.invalidate()
        gameViewControlerDelegate?.openGameOverView()
        
    }
}
