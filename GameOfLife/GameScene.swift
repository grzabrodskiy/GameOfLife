//
//  GameScene.swift
//  GameOfLife
//
//  Created by Tatyana kudryavtseva on 29.12.20.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let maxSize : Int = 21
    var ball: [[SKShapeNode]] = Array(repeating: Array(repeating: SKShapeNode(circleOfRadius: 5), count: 21), count: 21)
    
    let tapRec = UITapGestureRecognizer()

    let colorOn = UIColor.orange
    let colorOff = UIColor.blue
    
    var gameOn = false;
    
    
    
    
    override func didMove(to view: SKView) {
        
        let liveActionOn = SKAction.scale(by: 0.9,  duration: 0.5)
        let liveActionOff = SKAction.scale(by: 1.0/0.9, duration: 0.5)
        let liveAction = SKAction.repeatForever(SKAction.sequence([liveActionOn, liveActionOff]))
        
        
        tapRec.addTarget(self, action: #selector(self.tapView))
        tapRec.numberOfTapsRequired = 3
        tapRec.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(tapRec)
        
        for i  in 0..<maxSize{
            for j  in 0..<maxSize{
   
                ball[i][j] = SKShapeNode(circleOfRadius: 22)
                ball[i][j].position = CGPoint(x: frame.midX + 50 * (CGFloat(i-10)),
                                                  y: frame.midY + 50 * CGFloat(j-10))
                
                ball[i][j].strokeColor = SKColor.blue
                ball[i][j].glowWidth = 1.0
                ball[i][j].fillColor = SKColor.blue
                //ball[i][j].physicsBody = SKPhysicsBody(circleOfRadius: 15)
                //ball[i][j].physicsBody?.affectedByGravity = false
                //ball[i][j].physicsBody?.isDynamic = false
                //ball[i][j].physicsBody?.allowsRotation = false
                self.addChild(ball[i][j])
                ball[i][j].run(liveAction)
                
            }
        }

     
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        let c = coord(pos: pos)
        let i : Int = c.x
        let j :Int = c.y
        
        //ball[i][j].fillColor = SKColor.yellow
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        if let touchedNode = self.atPoint(positionInScene) as? SKShapeNode{
        
            if touchedNode.fillColor == .blue{
                touchedNode.fillColor = .orange
            }
            else{
                touchedNode.fillColor = .blue
            }
            
        }
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameOn {
            updateValues()
        }
    }
    
    
    @objc func tapView(){
        
        gameOn = !gameOn
        
    }
    
    //MARK: ====== Calc Functions
    
    func coord(pos : CGPoint) -> (x:Int, y:Int){
        
        let x : Int = Int((pos.x - frame.midX)/50.0) + 10
        let y : Int = Int((pos.y - frame.midY)/50.0) + 10
        return (x, y)
    }
    
    func updateValues(){
        
        
        for i :Int in 0..<maxSize{
            for j :Int in 0..<maxSize{
                let ln = liveNeighbour(i, j)
                
                if isLive(i, j){
                    if ln < 2 || ln > 3{
                        ball[i][j].fillColor = colorOff
                    }
                }
                else if ln == 3 {
                    ball[i][j].fillColor = colorOn
                }
            }
        }
    }
    
    func liveNeighbour(_ i : Int, _ j: Int)->Int{
        var neighbours : Int = 0
        for a in -1...1{
            for b in -1...1{
                if (i != 0 && j != 0){
                    if isLive(a, b) {neighbours+=1}
                }
            }
        }
        return neighbours
    }
    
    func isLive(_ i : Int, _ j: Int) -> Bool{
        if (i < 0 || j < 0 || i >= maxSize || j >= maxSize){
            return false
        }
        return ball[i][j].fillColor != colorOff
    }
    
    
}
