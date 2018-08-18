//
//  GameGraphicalView.swift
//  Swake
//
//  Created by Mazyad Alabduljaleel on 8/18/18.
//  Copyright © 2018 Level3. All rights reserved.
//

import Foundation
import SpriteKit

final class GameGraphicalView: GameView {
    
    private struct Const {
        static let pixelSize = CGSize(width: 30, height: 30)
    }
    
    var scene: SKScene! {
        didSet { drawMap() }
    }
    
    private var snake: [SKNode] = []
    private var food = SKShapeNode(ellipseOf: Const.pixelSize)
    private var gameEndedText: SKLabelNode?
    
    
    func tick(state: GameState) {
        
        guard state.status == .running else {
            return gameEnded()
        }
        
        cleanUp()
        prepareNodes(state: state)
        positionNodes(state: state)
    }
}
    
private extension GameGraphicalView {
    
    func convert(point: Point) -> CGPoint {
        let adjustedX = CGFloat(point.x - GameLogic.Const.size.width / 2)
        let adjustedY = CGFloat(point.y - GameLogic.Const.size.height / 2)
        
        return .init(x: adjustedX * Const.pixelSize.width + Const.pixelSize.width / 2,
                     y: adjustedY * Const.pixelSize.height)
    }
    
    func drawMap() {
        let border = SKShapeNode(rectOf: .init(width: CGFloat(GameLogic.Const.size.width) * Const.pixelSize.width,
                                               height: CGFloat(GameLogic.Const.size.height) * Const.pixelSize.height))
        
        scene.addChild(border)
    }
    
    func cleanUp() {
        snake.forEach { $0.removeFromParent() }
        food.removeFromParent()
        
        gameEndedText?.removeFromParent()
        gameEndedText = nil
    }
    
    func prepareNodes(state: GameState) {
        while snake.count < state.snake.points.count {
            let node = SKShapeNode(rectOf: Const.pixelSize)
            node.fillColor = .red
            
            snake.append(node)
        }

        for (node, _) in zip(snake, state.snake.points) {
            scene.addChild(node)
        }
        
        food.fillColor = .green
        
        scene.addChild(food)
    }
    
    func positionNodes(state: GameState) {
        for (point, node) in zip(state.snake.points, snake) {
            node.position = convert(point: point)
        }
        food.position = convert(point: state.food.position)
    }
    
    func gameEnded() {
        guard self.gameEndedText == nil else {
            return
        }
        
        let gameEndedText = SKLabelNode(text: "Game Over!")
        scene.addChild(gameEndedText)
        
        self.gameEndedText = gameEndedText
    }
}
