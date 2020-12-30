//
//  GameScene.swift
//  GameOfLife
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: ====== Game Constants and Variables

    let maxSize : Int = 21
    
    let colorOff : UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    
    let colorsOn : [UIColor] = [.blue, .orange, .yellow, .red, .purple, .green, .lightGray, .white]
    
    let colorBorder : [UIColor] = [.blue, .cyan, .magenta, .yellow, .red, .orange, .green, .lightGray, .white, .purple]
    
    var generation = 0
    var gameOn = false
    
    // controls
    var startButton : SKLabelNode = SKLabelNode()
    var stopButton : SKLabelNode = SKLabelNode()
    var clearButton : SKLabelNode = SKLabelNode()
    
    let tapRec = UITapGestureRecognizer()

    var ball: [[SKShapeNode]] = [[SKShapeNode(circleOfRadius: 5)]]
    
    //var start: SKLabelNode = SKLabelNode.init(text: "Start")
    // actions
    var liveAction : SKAction = SKAction()
    var evolveAction : SKAction = SKAction()
    
    override func didMove(to view: SKView) {
        
        // gesture recognitions - T
        tapRec.addTarget(self, action: #selector(self.tapView))
        tapRec.numberOfTapsRequired = 3
        tapRec.numberOfTouchesRequired = 2
        self.view!.addGestureRecognizer(tapRec)
        
        // create game
        createBoard()

     
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        
        if let touchedLabel = self.atPoint(positionInScene) as? SKLabelNode{
            print(touchedLabel.text ?? "No value")

            switch touchedLabel.name{
            case "start": startGame()
            case "stop": stopGame()
            case "clear": clearGame()
            default: print("Unknown label")
            }
            
        }
        if (gameOn) {return}
        
        // setup the game if it is not on
        
        if let touchedNode = self.atPoint(positionInScene) as? SKShapeNode{
        
            if touchedNode.fillColor == colorOff{
                touchedNode.fillColor = colorsOn[0]
            }
            else{
                touchedNode.fillColor = colorOff
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
        //if gameOn {
        //    updateValues()
        //}
    }
    
    
    @objc func tapView(){
        
        //gameOn = !gameOn
        
    }
    
    //MARK: ====== Game Button Actions
    
    func createBoard(){
        
        // create actions
        let actionOn : SKAction = .scale(by: 0.9, duration: 0.5)
        let actionOff: SKAction = .scale(to: 1, duration: 0.5)
        liveAction = .repeatForever(.sequence([actionOn, actionOff]))
        
        let waitAction : SKAction = .wait(forDuration: 0.25)
        let runAction : SKAction = .run{
            self.updateValues()
        }
        evolveAction = .repeatForever(.sequence([waitAction, runAction]))
        
        
        // buttons
        startButton = self.childNode(withName: "start")! as! SKLabelNode
        stopButton = self.childNode(withName: "stop")! as! SKLabelNode
        clearButton = self.childNode(withName: "start")! as! SKLabelNode
        
        startButton.fontName = "Futura Bold"
        stopButton.fontName = "Futura"
        clearButton.fontName = "Futura Bold"
        
        // creatures
        ball = Array(repeating: Array(repeating: SKShapeNode(circleOfRadius: 5), count: maxSize), count: maxSize)
        for i  in 0..<maxSize{
            for j  in 0..<maxSize{
   
                ball[i][j] = SKShapeNode(circleOfRadius: 22)
                ball[i][j].position = CGPoint(x: frame.midX + 50 * (CGFloat(i-10)), y: frame.midY + 50 * CGFloat(j-10))
                
                ball[i][j].strokeColor = colorBorder[0]
                ball[i][j].glowWidth = 1.0
                ball[i][j].fillColor = colorOff
                self.addChild(ball[i][j])
            }
        }
        //colorOff = ball[0][0].fillColor
        print(colorOff)
    }
    
    
    func startGame(){
        
        if (gameOn) {return}
        
        gameOn = true
        startButton.fontName = "Futura"
        stopButton.fontName = "Futura Bold"
        for i in 0..<maxSize {for j in 0..<maxSize{
            ball[i][j].run(liveAction)
        }}
        self.run(evolveAction, withKey: "evolve")
    }
    
    func stopGame(){
        gameOn = false
        startButton.fontName = "Futura Bold"
        stopButton.fontName = "Futura"
        for i in 0..<maxSize {for j in 0..<maxSize{
            ball[i][j].removeAllActions()
        }}
        self.removeAction(forKey: "evolve")
    }
    
    func clearGame(){
        if gameOn {stopGame()}
        
        for i in 0..<maxSize {for j in 0..<maxSize{Off(i, j)}}
    }
    
    //MARK: ====== Calc Functions
    
    /*func coord(pos : CGPoint) -> (x:Int, y:Int){
        
        let x : Int = Int((pos.x - frame.midX)/50.0) + 10
        let y : Int = Int((pos.y - frame.midY)/50.0) + 10
        return (x, y)
    }*/
    
    func updateValues(){
        
        var newState : [[Int]] = Array(repeating: Array(repeating: 0, count: maxSize), count: maxSize)
        var live : Int = 0
        for i :Int in 0..<maxSize {for j :Int in 0..<maxSize {
            let neighbours = liveNeighbour(i, j)
            
            if isLive(i, j){
                if neighbours < 2 || neighbours > 3 {
                    newState[i][j] = -1
                }
            }
            else {
                if neighbours == 3 {newState[i][j] = 1}
            }
        }}
        
        for i :Int in 0..<maxSize{
            for j :Int in 0..<maxSize{
                switch newState[i][j]{
                case -1 :
                    Off(i, j)
                case 1:
                    On(i, j)
                default: break // do nothing
                }
                if isLive(i, j) {live += 1}
            }
        }
        // if nothing live, stop
        if (live == 0) {stopGame()}
        
        generation+=1
        //print(generation)
    }
    
    func liveNeighbour(_ i : Int, _ j: Int)->Int{
        var neighbours : Int = 0
        for a in -1...1{
            for b in -1...1{
                if (a != 0 || b != 0){
                    if isLive(i + a, j + b) {neighbours+=1}
                }
            }
        }
        return neighbours
    }
    
    func isLive(_ i : Int, _ j: Int) -> Bool{
        if (i < 0 || j < 0 || i >= maxSize || j >= maxSize){return false}
        return ball[i][j].fillColor != colorOff
    }
    
    
    
    func On(_ i : Int, _ j: Int){
        ball[i][j].fillColor = colorsOn[generation % colorsOn.count]
        ball[i][j].strokeColor = colorBorder[generation % colorBorder.count]
    }
    
    func Off(_ i : Int, _ j: Int){
        //print ("\(i): \(j) is off")
        ball[i][j].fillColor = colorOff
        ball[i][j].strokeColor = colorBorder[0]
    }
    
    
}
