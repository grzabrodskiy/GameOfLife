//
//  GameScene.swift
//  GameOfLife
//
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: ====== Game Constants

    let maxSize : Int = 21
    
    let colorOff : UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
    
    // put as many colors as you want
    let colorsOn : [UIColor] = [.blue, .orange, .yellow, .red, .purple, .green, .lightGray, .white, .brown, .systemPink, .systemIndigo]
    
    // put as many colors as you want (can be different size from colorsOn)
    let colorBorder : [UIColor] = [.blue, .cyan, .magenta, .yellow, .red, .orange, .green, .lightGray, .white, .purple]
    
    let activeFont : String = "Futura Bold"
    let inactiveFont : String = "Futura"

    
    //MARK: ====== Game Variables
    var generation = 0
    var gameOn = false
    
    //MARK: ====== Game Controls and Actions
    var startButton : SKLabelNode = SKLabelNode()
    var stopButton : SKLabelNode = SKLabelNode()
    var clearButton : SKLabelNode = SKLabelNode()
    var randomButton : SKLabelNode = SKLabelNode()
    var nextButton : SKLabelNode = SKLabelNode()
    var caption : SKLabelNode = SKLabelNode()

    //let tapRec = UITapGestureRecognizer()

    var ball: [[SKShapeNode]] = [[SKShapeNode(circleOfRadius: 5)]]
    
    //var start: SKLabelNode = SKLabelNode.init(text: "Start")
    // actions
    var liveAction : SKAction = SKAction()
    var evolveAction : SKAction = SKAction()
    
    //MARK: ====== Standard Event Handlers
    override func didMove(to view: SKView) {
        
        // gesture recognitions - T
        //tapRec.addTarget(self, action: #selector(self.tapView))
        //tapRec.numberOfTapsRequired = 3
        //tapRec.numberOfTouchesRequired = 2
        //self.view!.addGestureRecognizer(tapRec)
        
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
        
        for touch : UITouch in touches{
            touchScreen(touch)
        }
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        for touch : UITouch in touches{touchScreen(touch)}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for touch : UITouch in touches{touchScreen(touch)}
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for touch : UITouch in touches{touchScreen(touch)}
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    /*@objc func tapView(){
        
        //gameOn = !gameOn
        
    }*/
    
    //MARK: ====== Game Button Actions

    func touchScreen(_ touch : UITouch){
        //let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        
        // a label has been pressed
        
        if let touchedLabel = self.atPoint(positionInScene) as? SKLabelNode{
            //print(touchedLabel.text ?? "No value")

            switch touchedLabel.name{
            case "start": startGame()
            case "stop": stopGame()
            case "clear": clearGame()
            case "random": randomGame()
            case "next": nextGame()
            case "caption": break
            default: print("Unknown label")
            }
            
        }
        // a circle pressed - only react if the game is off
        if (gameOn) {return}
        
        // setup the game if it is not on
        if let touchedNode = self.atPoint(positionInScene) as? SKShapeNode{
        
            if touchedNode.fillColor == colorOff{
                touchedNode.fillColor = colorsOn[ generation % colorsOn.count]
                touchedNode.strokeColor = colorBorder[Int.random(in: 0..<colorBorder.count)]
            }
            else{
                touchedNode.fillColor = colorOff
                touchedNode.strokeColor = colorBorder[0]
            }
        }
    }
    
    
    func createBoard(){
        
        // create actions
        let actionOn : SKAction = .scale(by: 0.9, duration: 0.5)
        let actionOff: SKAction = .scale(to: 1, duration: 0.5)
        liveAction = .repeatForever(.sequence([actionOn, actionOff]))
        
        let waitAction : SKAction = .wait(forDuration: 0.25)
        let runAction : SKAction = .run {self.updateValues()}
        evolveAction = .repeatForever(.sequence([waitAction, runAction]))

        generation = Int.random(in: 0..<colorsOn.count)
        
        // buttons
        startButton = self.childNode(withName: "start")! as! SKLabelNode
        stopButton = self.childNode(withName: "stop")! as! SKLabelNode
        clearButton = self.childNode(withName: "clear")! as! SKLabelNode
        randomButton = self.childNode(withName: "random")! as! SKLabelNode
        nextButton = self.childNode(withName: "next")! as! SKLabelNode

        
        caption = self.childNode(withName: "caption")! as! SKLabelNode
        
        // before start game
        startButton.fontName = activeFont
        stopButton.fontName = inactiveFont
        randomButton.fontName = activeFont
        nextButton.fontName = activeFont
        clearButton.fontName = activeFont
        caption.fontName = activeFont

        
        if let view = self.view
        {
            let topRightPos = view.convert(CGPoint(x:view.frame.maxX,y:view.frame.minY),to:scene!)
            
            let topLeftPos = view.convert(CGPoint(x:view.frame.minX,y:view.frame.minY),to:scene!)
           
            let topCenterPos1 = view.convert(CGPoint(x:(view.frame.minX*3 + view.frame.maxX)/4 ,y:view.frame.minY),to:scene!)
            
            let topCenterPos2 = view.convert(CGPoint(x:(view.frame.minX*2 + view.frame.maxX*2)/4 ,y:view.frame.minY),to:scene!)
 
            let topCenterPos3 = view.convert(CGPoint(x:(view.frame.minX + view.frame.maxX*3)/4 ,y:view.frame.minY),to:scene!)

            
            let bottomCenterPos = view.convert(CGPoint(x:(view.frame.minX + view.frame.maxX)/2 ,y:view.frame.maxY),to:scene!)
            
            formatLabel(clearButton, topRightPos, .right, .top)
   
            formatLabel(startButton, topLeftPos, .left, .top)
   
            formatLabel(stopButton, topCenterPos1, .center, .top)

            formatLabel(nextButton, topCenterPos2, .center, .top)

            formatLabel(randomButton, topCenterPos3, .center, .top)
            
            formatLabel(caption, bottomCenterPos, .center, .bottom)

            
        }
        
        
        
        
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
        //print(colorOff)
    }
    
    
    func startGame(){
        
        if (gameOn) {return}
        
        gameOn = true
        startButton.fontName = inactiveFont
        randomButton.fontName = inactiveFont
        nextButton.fontName = inactiveFont
        stopButton.fontName = activeFont
        for i in 0..<maxSize {for j in 0..<maxSize{
            ball[i][j].run(liveAction)
        }}
        self.run(evolveAction, withKey: "evolve")
    }
    
    func stopGame(){
        gameOn = false
        startButton.fontName = activeFont
        randomButton.fontName = activeFont
        nextButton.fontName = activeFont
        stopButton.fontName = inactiveFont
        caption.fontColor = startButton.fontColor

        for i in 0..<maxSize {for j in 0..<maxSize{
            ball[i][j].removeAllActions()
        }}
        self.removeAction(forKey: "evolve")
    }
    
    func clearGame(){
        if gameOn {stopGame()}
        
        for i in 0..<maxSize {for j in 0..<maxSize{Off(i, j)}}
    }
    
    func randomGame(){
        
        if gameOn {return}
        generation += 1
        for i in 0..<maxSize {for j in 0..<maxSize{
            if Bool.random() {On(i,j)}
            else {Off(i, j)}
        }}
    }
    
    func nextGame(){
        
        if gameOn {return}
        
        updateValues()
        
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
        
        generation+=1
        
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
                if isLive(i, j) {
                    live += 1
                    ball[i][j].strokeColor = colorBorder[Int.random(in: 0..<colorBorder.count)]
                    caption.fontColor = colorBorder[Int.random(in: 0..<colorBorder.count)]
                }
                //ball[i][j].strokeColor =
                //    colorBorder[Int.random(in: 0..<colorBorder.count)]
            }
        }

        // if nothing live, stop
        if (live == 0) {stopGame()}
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
    
    
    //MARK: ====== Formatting Functions

    func On(_ i : Int, _ j: Int){
        ball[i][j].fillColor = colorsOn[generation % colorsOn.count]
        ball[i][j].strokeColor = colorBorder[Int.random(in: 0..<colorBorder.count)]
            
            
            //colorBorder[generation % colorBorder.count]
    }
    
    func Off(_ i : Int, _ j: Int){
        //print ("\(i): \(j) is off")
        ball[i][j].fillColor = colorOff
        ball[i][j].strokeColor = colorBorder[0]
        caption.fontColor = startButton.fontColor
    }
    
    func formatLabel(_ label : SKLabelNode, _ pos : CGPoint,
                     _ hor : SKLabelHorizontalAlignmentMode,
                     _ ver : SKLabelVerticalAlignmentMode){
        
        label.position = pos
        label.horizontalAlignmentMode = hor
        label.verticalAlignmentMode = ver
    }
    
    
}
