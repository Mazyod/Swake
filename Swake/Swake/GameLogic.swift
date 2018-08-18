//
//  GameLogic.swift
//  Swake
//
//  Created by Mazyad Alabduljaleel on 8/18/18.
//  Copyright © 2018 Level3. All rights reserved.
//

import Foundation


final class GameLogic {
    
    struct Const {
        static let size = Size(width: 20, height: 35)
    }
    
    private(set) var state: GameState
    
    init() {
        state = GameState()
        state.food.position = generateFoodPosition()
    }
    
    func tick() {
        displaceSnakeOrGrow()
        checkForGameOverConditions()
    }
    
    func directionEvent(_ direction: Direction) {
        if state.status == .ended {
            state = GameState()
            state.food.position = generateFoodPosition()
            return
        }
        
        if direction != state.snake.direction.transpose {
            state.snake.direction = direction
        }
    }
}
    
private extension GameLogic {
    
    func generateFoodPosition() -> Point {
        while true {
            let potentialPosition = Point(x: Int.random(Const.size.width),
                                          y: Int.random(Const.size.height))
            
            if !state.snake.points.contains(potentialPosition) {
                return potentialPosition
            }
        }
    }
    
    func displaceSnakeOrGrow() {
        
        let snakeHeadPosition = state.snake.points[0]
        let newSnakeHeadPosition = snakeHeadPosition.moved(in: state.snake.direction)
        state.snake.points.insert(newSnakeHeadPosition, at: 0)

        if state.snake.points.first == state.food.position {
            state.food.position = generateFoodPosition()
        } else {
            state.snake.points.removeLast()
        }
    }
    
    func checkForGameOverConditions() {
        guard Set(state.snake.points).count == state.snake.points.count else {
            return (state.status = .ended)
        }
        
        let snakeHead = state.snake.points[0]
        switch (snakeHead.x, snakeHead.y) {
        case (..<0, _),
             (Const.size.width..., _),
             (_, ..<0),
             (_, Const.size.height...):
            return (state.status = .ended)
            
        default:
            break
        }
    }
}

// Game State:

struct Point: Hashable {
    var x: Int
    var y: Int
    
    func moved(in direction: Direction) -> Point {
        var newPoint = self
        switch direction {
        case .north:
            newPoint.y -= 1
        case .east:
            newPoint.x += 1
        case .south:
            newPoint.y += 1
        case .west:
            newPoint.x -= 1
        }
        return newPoint
    }
}

struct Size {
    let width: Int
    let height: Int
}

enum Direction {
    case north
    case east
    case south
    case west
    
    var transpose: Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
}

struct GameState {

    enum Status {
        case running
        case ended
    }
    
    struct Snake {
        var points: [Point] = [.init(x: 0, y: 2),
                               .init(x: 0, y: 1),
                               .init(x: 0, y: 0),]
        
        var direction: Direction = .east
    }
    
    struct Food {
        var position = Point(x: -1, y: -1)
    }
    
    var status = Status.running
    var snake = Snake()
    var food = Food()
}

private extension Int {
    static func random(_ upperLimit: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperLimit)))
    }
}
