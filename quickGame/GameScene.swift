//
//  GameScene.swift
//  quickGame
//
//  Created by ALVIN CHEN on 2/26/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //contact mask is binary stuff, 1 2 4 8 16
    var gameOver = false
    var winLoseOutlet: SKLabelNode!
    var label: SKLabelNode!
    var player: SKSpriteNode!
    let cam = SKCameraNode()
    var livesLabel: SKLabelNode!
    var score = 0
    var lives = 5
    var isGrounded = true
    var rightway = false
    var leftway = false
    
    override func didMove(to view: SKView) {
        
        
   
        label = self.childNode(withName: "scoreLabel") as! SKLabelNode
        winLoseOutlet = self.childNode(withName: "winLoseOutlet") as! SKLabelNode
        winLoseOutlet.fontSize = 100
        livesLabel = self.childNode(withName: "lives") as! SKLabelNode
        
        self.physicsWorld.contactDelegate = self
        player = self.childNode(withName: "player") as! SKSpriteNode
        self.camera = cam
        label.text = "\(score)/20"
        livesLabel.text = "lives left: \(lives)"
        winLoseOutlet.text = ""
        
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "spike") || (contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "spike"){

            if(lives == 0){
                livesLabel.text = "\(lives)"
                player.physicsBody?.velocity.dx = 0
                gameOver = true
                winLoseOutlet.text = "Game Over"
            }
            else{
                lives -= 1
                let restartAction = SKAction.move(to:CGPoint(x: -640, y: -320), duration: 0)
                pause()
                player.run(restartAction)
                livesLabel.text = "lives left: \(lives)"
            }
            
        }
        
       
        
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "coin") || (contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "coin"){
            score = score + 1
            if(score <= 20){
                label.text = "\(score)/20"
            }
            if(score == 20){
                gameOver = true
                pause()
                winLoseOutlet.text = "You Win"
            }
            if contact.bodyA.node?.name == "coin"{
                contact.bodyA.node?.removeFromParent()
            }
            if contact.bodyB.node?.name == "coin"{
                contact.bodyB.node?.removeFromParent()
            }
        }
        
        if (contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "ground") || (contact.bodyB.node?.name == "player" && contact.bodyA.node?.name == "ground"){
            print("isGrounded")
            isGrounded = true
            
            }
            
        
        

        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        cam.position.x = player.position.x
        cam.position.y = player.position.y + 100
        label.position.x = player.position.x + 500
        label.position.y = player.position.y + 300
        livesLabel.position.x = player.position.x - 500
        livesLabel.position.y = player.position.y + 300
        winLoseOutlet.position.x = player.position.x
        winLoseOutlet.position.y = player.position.y + 100
        if (leftway == true && gameOver == false){
            player.physicsBody?.velocity.dx = -325
        }
        
        if (rightway == true && gameOver == false){
            player.physicsBody?.velocity.dx = 325
        }


        
    }
    
    
    func jump(){
        if(gameOver == false && isGrounded == true){
            player.physicsBody?.velocity.dy = 600
            isGrounded = false
            
        }
    }
    func left(){
        if(gameOver == false){
            player.physicsBody?.velocity.dx = -325
            leftway = true
            rightway = false
        }
    }
    func pause(){
        if(gameOver == false){
            player.physicsBody?.velocity.dx = 0
            rightway = false
            leftway = false
        }
    }
    func right(){
        if(gameOver == false){
            player.physicsBody?.velocity.dx = 325
            rightway = true
            leftway = false
            
        }
    }
    func respawn(){
        player.position.x = -640
        player.position.y = -320
    }
}
