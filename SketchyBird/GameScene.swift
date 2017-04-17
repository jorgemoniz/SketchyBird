//
//  GameScene.swift
//  SketchyBird
//
//  Created by jorgemoniz on 10/4/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Variables locales
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var limitLand = SKNode()
    var timer = Timer()
    
    //grupos de colision
    let birdGroup : UInt32 = 1
    let objectsGroup : UInt32 = 2
    let gapGroup : UInt32 = 4
    let movinGroup = SKNode()
    
    //MARK: - movimientos
    override func didMove(to view: SKView) {
        //definimos quien es el delegado para tener en cuenta las colisiones
        self.physicsWorld.contactDelegate = self
        //manipulamos la gravedad
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        self.addChild(movinGroup)
        
        makeLimitLand()
        makeBackground()
        makeLoopPipe1AndPipe2()
        makeBird()
        
    }
    
    //MARK: - inicio de toques en la pantalla
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Reset de la posicion y velocidad del pajaro
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 160))
    }
    
    //MARK: - actualizacion de la vista
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    //MARK: - Utils
    func makeLimitLand() {
        limitLand.position = CGPoint(x: 0, y: -(self.frame.height / 2))
        limitLand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        limitLand.physicsBody?.isDynamic = false
        limitLand.physicsBody?.categoryBitMask = objectsGroup
        limitLand.zPosition = 2
        self.addChild(limitLand)
    }
    
    func makeBackground() {
        //Creacion de la textura
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
            //self.addChild(background)
            self.movinGroup.addChild(background)
        }
    }
    
    func makePipesFinal() {
        //variables internas
        let gapheight = bird.size.height * 4
        //se mueve una vez salga la tubería tanto para arriba como para abajo un numero entre 1/4 y la mitad de la pantalla
        let movementAmount = arc4random_uniform(UInt32(self.frame.height / 2))
        //desplazamiento de la tuberia - entre 0 y la mitad de la pantalla pero le resto 1/4 de esta
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        //movemos las tuberias
        let movePipes = SKAction.moveBy(x: -self.frame.width - 200, y: 0, duration: TimeInterval(self.frame.width / 200))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //creamos la textura Uno
        let pipeTexture1 = SKTexture(imageNamed: "pipe1")
        pipeFinal1 = SKSpriteNode(texture: pipeTexture1)
        pipeFinal1.position = CGPoint(x: self.frame.width - self.frame.width / 2, y: self.frame.midY + (pipeFinal1.size.height / 2) + (gapheight / 2) + pipeOffset)
        pipeFinal1.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal1.size)
        pipeFinal1.physicsBody?.isDynamic = false
        pipeFinal1.physicsBody?.categoryBitMask = objectsGroup
        
        pipeFinal1.run(moveAndRemovePipes)
        pipeFinal1.zPosition = 5
        self.addChild(pipeFinal1)
        
        //creamos la textura Dos
        let pipeTexture2 = SKTexture(imageNamed: "pipe2")
        pipeFinal2 = SKSpriteNode(texture: pipeTexture2)
        pipeFinal2.position = CGPoint(x: self.frame.width - self.frame.width / 2, y: self.frame.midY - (pipeFinal2.size.height / 2) - (gapheight / 2) + pipeOffset)
        pipeFinal2.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal1.size)
        pipeFinal2.physicsBody?.isDynamic = false
        pipeFinal2.physicsBody?.categoryBitMask = objectsGroup
        
        pipeFinal2.run(moveAndRemovePipes)
        pipeFinal2.zPosition = 5
        //self.addChild(pipeFinal2)
        self.movinGroup.addChild(pipeFinal2)
        
        //grupo de colision que atraviesa el gap / hueco
        makeGapeNode(pipeOffset, gapHeight: gapheight, moveAndRemovePipes: moveAndRemovePipes)
    }
    
    func makeGapeNode(_ pipeOffset : CGFloat, gapHeight : CGFloat, moveAndRemovePipes : SKAction) {
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.width - self.frame.width / 2, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeFinal1.size.width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.run(moveAndRemovePipes)
        gap.zPosition = 7
        gap.physicsBody?.categoryBitMask = gapGroup
        self.movinGroup.addChild(gap)
    }
    
    func makeBird(){
        //1 -> Creacion de las texturas
        let birdTexture1 = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        //2 -> Accion
        let animationBird = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        //3 -> Accion por siempre
        let makeAnimationForever = SKAction.repeatForever(animationBird)
        //4 -> Asigno la animacion a nuestro SKSpriteNode
        bird = SKSpriteNode(texture: birdTexture1)
        //5 -> Asigno la posicion del pajaro en el espacio
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        //6 -> Ejecuta la animacion
        bird.run(makeAnimationForever)
        //6.1 -> zPosition
        bird.zPosition = 15
        
        //GRUPO DE FISICAS
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        //bird.physicsBody = SKPhysicsBody(texture: birdTexture1, alphaThreshold: 0.5, size: CGSize(width: bird.size.width, height: bird.size.height))
        bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = objectsGroup
        bird.physicsBody?.contactTestBitMask = objectsGroup | gapGroup
        
        bird.physicsBody?.allowsRotation = false
        
        //7 -> Añado a la vista
        self.addChild(bird)
    }
    
    func makeLoopPipe1AndPipe2() {
        //Usamos el timer un objeto que determine cada cuantos segundos ha de crearse una tuberia
        timer = Timer.scheduledTimer(timeInterval: 3,
                                     target: self,
                                     selector: #selector(makePipesFinal),
                                     userInfo: nil,
                                     repeats: true)
    }
}
