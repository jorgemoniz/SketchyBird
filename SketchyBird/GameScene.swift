//
//  GameScene.swift
//  SketchyBird
//
//  Created by jorgemoniz on 10/4/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Variables locales
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var timer = Timer()
    
    //MARK: - movimientos
    override func didMove(to view: SKView) {

        
    }
    
    //MARK: - inicio de toques en la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    //MARK: - actualizacion de la vista
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
