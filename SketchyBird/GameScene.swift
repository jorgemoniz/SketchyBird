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
        makeBackground()
        makeBird()
        
    }
    
    //MARK: - inicio de toques en la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    //MARK: - actualizacion de la vista
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //MARK: - Utils
    func makeBackground() {
        //Creación de la textura
        let backgroundFinal = SKTexture(imageNamed: "bg")
        //Movimiento del fondo
        let moveBackground = SKAction.moveBy(x: -backgroundFinal.size().width, y: 0, duration: 6)
        
        let replaceBackground = SKAction.moveBy(x: backgroundFinal.size().width, y: 0, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for c_imagen in 0..<3 {
            background = SKSpriteNode(texture: backgroundFinal)
            background.position = CGPoint(x: -(backgroundFinal.size().width / 2) + (backgroundFinal.size().width * CGFloat(c_imagen)) , y: self.frame.midY)
            background.zPosition = 1
            background.size.height = self.frame.height
            background.run(moveBackgroundForever)
            self.addChild(background)
        }
    }
    
    func makeBird(){
        //1 -> Creación de las texturas
        let birdTexture1 = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        //2 -> Acción
        let animationBird = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        //3 -> Accion por siempre
        let makeAnimationForever = SKAction.repeatForever(animationBird)
        //4 -> Asigno la animación a nuestro SKSpriteNode
        bird = SKSpriteNode(texture: birdTexture1)
        //5 -> Asigno la posición del pájaro en el espacio
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        //6 -> Ejecuta la animación
        bird.run(makeAnimationForever)
        //6.1 -> zPosition
        bird.zPosition = 15
        //7 -> Añado a la vista
        self.addChild(bird)
    }
}
