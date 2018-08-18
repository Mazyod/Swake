//
//  GameScene.swift
//  Swake
//
//  Created by Mazyad Alabduljaleel on 8/18/18.
//  Copyright © 2018 Level3. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var gameLogic = GameLogic()
    private let gameView = GameGraphicalView()
    
    private var lastUpdateTime: CFTimeInterval?
    private var lastDirection: Direction?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gameView.scene = self
    }
    
    func touchDown(atPoint pos: CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.first
            .flatMap { $0.location(in: view!) }
            .flatMap(processTouch(at:))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let lastUpdateTime = self.lastUpdateTime, currentTime - lastUpdateTime < 0.14 {
            return
        }
        
        lastUpdateTime = currentTime
        
        if let direction = lastDirection {
            gameLogic.directionEvent(direction)
            lastDirection = nil
        }
        
        gameLogic.tick()
        gameView.tick(state: gameLogic.state)
    }
}

private extension GameScene {
    
    func processTouch(at point: CGPoint) {
        
        let topThird = view!.frame.height / 3
        let bottomThird = 2 * view!.frame.height / 3
        let centerX = view!.frame.midX
        
        let direction: Direction
        switch (point.x, point.y) {
        case (_, ...topThird):
            direction = .south
        case (_, bottomThird...):
            direction = .north
        case (...centerX, _):
            direction = .west
        case (centerX..., _):
            direction = .east
        default:
            fatalError("can't happen")
        }
        // buffer input, as to not spam the controls and reverse the snake
        lastDirection = direction
    }
}
