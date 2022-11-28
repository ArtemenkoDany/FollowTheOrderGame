//
//  GameScene.swift
//  FollowTheOrder
//
//  Created by Даниил on 27.11.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // MARK: - Properties
    private var circlesgenerator: circlesGenerator!
    /// Varriables for circle sprites
    private var circleSize: CGFloat!
    private var circles: [SKSpriteNode] = []
    private var currentSequenceIndex = 0 /// to check sequence status and know when user guessed circles order
    /// In that contest, we are using UserDefaults to save the users level statistic
    private let defaults = UserDefaults.standard
    
    weak var routeDelegate: GameViewControllerDelegate!
    /// Variables for a level label
    private var currentLevel: Int!
    private var levelNode: SKLabelNode!
    /// Create an array of sounds to generate a random one for the current level
    let sounds = ["click2.wav", "click.wav", "click3.wav"]
    var sound = ""
    /// Button to start current level
    let startGameButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.system)
        button.setTitle("Start the Game", for: .normal)
        button.layer.cornerRadius = 5
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Extralight", size: 40)
        return button
    }()
    
    // MARK: - init    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.random
        sound = sounds.randomElement()!
        /// Check if user saved current level or not
        currentLevel = (defaults.value(forKey: "level") as? Int) ?? 0
        
        self.view?.addSubview(startGameButton)
        startGameButton.addTarget(self,
                         action: #selector(counterAnimation),
                         for: .touchUpInside)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        startGameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        startGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startGameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.createLevelLabel()
    }
    // MARK: - Selectors
    private func createLevelLabel(){
        ///settings for level number label
        levelNode = SKLabelNode(text: "\(currentLevel!)")
        levelNode.fontSize = 45
        levelNode.fontName = "ClashDisplay-Extralight"
        levelNode.position = CGPoint(x: 60, y: frame.maxY - levelNode.frame.size.height - 60)
        levelNode.fontColor = .white
        levelNode.name = "level"
        /// Settings for "level"  label
        let levelTitleNode = SKLabelNode(text: "level")
        levelTitleNode.fontSize = 40
        levelTitleNode.fontName = "ClashDisplay-Extralight"
        levelTitleNode.position = CGPoint(x: 0 , y: levelNode.frame.minY)
        levelTitleNode.fontColor = .white
        levelTitleNode.name = "level"
        /// Addind labels on a view
        addChild(levelNode)
        addChild(levelTitleNode)
    }
    
    /// Genetate circle as a sprite
    private func createCircle(with position: CGPoint) -> SKSpriteNode {
        let circle = SKSpriteNode(imageNamed: "white-button")
        circle.position = position
        circle.name = "circle"
        circle.size = CGSize(width: self.circleSize, height: self.circleSize)
        return circle
    }
    
    /// Create circles and add them to scene
    private func createCircles(){
        view?.isUserInteractionEnabled = false
        /// Generation circle
        currentSequenceIndex = 0
        circles = []
        let circlesCount = currentLevel + 4 /// total amount of sircle sprites to follow order
        guard let circlePoints = circlesgenerator.generateCircles(count: circlesCount,
                                                                  size: CGSize(width: circleSize, height: circleSize)) else { return }
        
        circles = circlePoints.map({createCircle(with: $0)})
            
        if !circles.isEmpty {
            var sequences: [SKAction] = []
            circles.forEach { circle in
                let circleCreate = SKAction.run { [self] in
                    addChild(circle)
                    circle.alpha = 0.0
                    
                    circle.run(SKAction.group([SKAction.fadeIn(withDuration: 0.3)]))
                }
                let circleSequenceAction  = SKAction.sequence([circleCreate, SKAction.wait(forDuration: 1, withRange: 0.5)])
                sequences.append(circleSequenceAction)
            }
            let sequence = SKAction.sequence(sequences)
            
            self.run(sequence) {
                self.view?.isUserInteractionEnabled = true
            }
        }
    }
    
    /// bong animation function
    @objc func counterAnimation(){
        startGameButton.alpha = 0
        let startNode = SKLabelNode()
        startNode.fontName = "ClashDisplay-Extralight"
        startNode.fontSize = 245
        startNode.zPosition = 5
        
        startNode.xScale = 0.0
        startNode.yScale = 0.0
        
        addChild(startNode)
        
        startNode.text = "3"
        
        let scaleTo = SKAction.scale(to: 1.0, duration: 0.5)
        let action1 = SKAction.run {
            startNode.text = "2"
            startNode.xScale = 0.0
            startNode.yScale = 0.0
        }
        let action2 = SKAction.run {
            startNode.text = "1"
            startNode.xScale = 0.0
            startNode.yScale = 0.0
        }
        let action3 = SKAction.run {
            startNode.text = "Start!"
            startNode.xScale = 0.0
            startNode.yScale = 0.0
        }
        
        let deley = SKAction.wait(forDuration: 0.3)
        
        let sequence = SKAction.sequence([scaleTo, deley, action1, scaleTo, deley, action2, scaleTo, deley, action3, scaleTo, SKAction.wait(forDuration: 0.5)])
        
        startNode.run(sequence) { [weak startNode] in
            startNode?.removeFromParent()
            
            self.circleSize = self.frame.width / 7

            self.circlesgenerator = circlesGenerator(minX: self.frame.minX/2 + self.circleSize/2,
                                                     maxX: self.frame.maxX/2 - self.circleSize/2,
                                                     minY: self.frame.minY/2 + self.circleSize/2,
                                                     maxY: self.frame.maxY/2 - self.circleSize/2)
            self.createCircles()
        }
    }
    
    public func nextLevel() {
        if (currentLevel < 6) {
            changeCurrentLevel(with: true)
            counterAnimation()
        } else {
            let finishNode = SKLabelNode(text: "You are the winner")
            finishNode.fontName = "ClashDisplay-Extralight"
            finishNode.fontSize = 55
            addChild(finishNode)
            
        }
    }
    
    public func restartLevel() {
        changeCurrentLevel(with: false)
        counterAnimation()
    }
    
    private func changeCurrentLevel(with didWinLast: Bool) {
        self.createLevelLabel()
        if didWinLast == true{
            self.currentLevel += 1
        }
        else if didWinLast == false && Int(self.currentLevel) > 0{
            self.currentLevel -= 1
        }
        defaults.set(self.currentLevel, forKey: "level")
        
        let groupOut = SKAction.group([SKAction.fadeOut(withDuration: 0.3), SKAction.scale(to: 0.5, duration: 0.3)])
        let groupIn = SKAction.group([SKAction.fadeIn(withDuration: 0.3), SKAction.scale(to: 1, duration: 0.3)])

        let changeValue = SKAction.run {
            self.levelNode.text = "\(self.currentLevel!)"
        }

        let sequence = SKAction.sequence([groupOut, changeValue, groupIn])
        levelNode.run(sequence)
    }
}
// MARK: - GameScene
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        let size = CGSize(width: 1, height: 1)
        let touchFrame = CGRect(origin: point, size: size)
        
        for i in 0..<circles.count {
            if circles[i].frame.intersects(touchFrame) {
                run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
                /// Check if user follow the sequence in right way
                if i == self.currentSequenceIndex {
                    /// Change clicked sprite with the new image texture
                    circles[i].texture = SKTexture(imageNamed: "green-button")
                    currentSequenceIndex += 1
                    /// Check if a user clicked on all circle sprites and sequence index of guesses equal to the amount of the generated circles sprites
                    if currentSequenceIndex >= circles.count {
                        self.view?.isUserInteractionEnabled = false
                        run(SKAction.wait(forDuration: 0.5)) { [weak self] in
                            guard let `self` = self else {return}
                            self.run(SKAction.wait(forDuration: 0.3)) { [weak self] in
                                guard let `self` = self else {return}
                                self.enumerateChildNodes(withName: "circle") { circle, stop in
                                    circle.removeFromParent()
                                }
                                self.enumerateChildNodes(withName: "level") { circle, stop in
                                    circle.removeFromParent()
                                }
                            }
                            /// Delegating to new view to see fortune quote and start a new level
                            self.routeDelegate.showSuccesView()
                        }
                    }
                }
                /// User was wrong with following sequence
                else if i > currentSequenceIndex {
                    self.view?.isUserInteractionEnabled = false
                    circles[i].texture = SKTexture(imageNamed: "red-button")
                    
                    run(SKAction.wait(forDuration: 0.5)) {
                        self.run(SKAction.wait(forDuration: 0.3)) {
                            self.enumerateChildNodes(withName: "circle") { circle, stop in
                                let circleFadeOut = SKAction.run{
                                    circle.run(SKAction.group([SKAction.fadeOut(withDuration: 0.3)]))
                                }
                                let circleRemove = SKAction.run{
                                    circle.removeFromParent()
                                }
                                self.run(SKAction.sequence([circleFadeOut, SKAction.wait(forDuration: 1, withRange: 0.5), circleRemove]))
                                
                            }
                            self.enumerateChildNodes(withName: "level") { circle, stop in
                                circle.removeFromParent()
                            }
                            
                        }
                        /// Delegating to new view to start a new level
                        self.routeDelegate.showFailureView()
                    }
                }
                break
            }
        }
    }
}
