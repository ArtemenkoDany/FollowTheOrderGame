//
//  GameViewController.swift
//  FollowTheOrder
//
//  Created by Даниил on 27.11.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, resultDelegate {
    // MARK: - Properties
    private var gamescene: GameScene!
    private let resultVC = resultViewController()
    
    // MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        startGameHandler()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Selectors
    private func startGameHandler(){
        resultVC.delegate = self
        
        if let view = self.view as! SKView? {
            /// Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                /// Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                gamescene = (scene as! GameScene)
                gamescene.routeDelegate = self
                /// Present the scene
                view.presentScene(gamescene, transition: .flipHorizontal(withDuration: 1))
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
    }
    /// Delegated functiion to restart level with -1 or +1 to current level variable
    public func restartLevel(vc: resultViewController, with isWin: Bool) {
        print(isWin)
        if isWin == true{
            self.gamescene.nextLevel()
        }
        else{
            self.gamescene.restartLevel()
        }
    }
}
// MARK: - GameViewControllerDelegate
extension GameViewController: GameViewControllerDelegate{
    func showFailureView() {
        resultVC.didWinLast = false
        resultVC.configureView()
        let navVC = UINavigationController(rootViewController: resultVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
        
    }
    func showSuccesView() {
        resultVC.didWinLast = true
        resultVC.configureView()
        let navVC = UINavigationController(rootViewController: resultVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
