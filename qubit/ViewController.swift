//
//  ViewController.swift
//  qubit
//
//  Created by Cameron Krischel on 4/14/19.
//  Copyright © 2019 Cameron Krischel. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var front = [UIButton]()
    var back = [UIButton]()
    var right = [UIButton]()
    var left = [UIButton]()
    var down = [UIButton]()
    var up = [UIButton]()
    var cubeArray = [[UIButton]]()
    
    var cornerArray =   [
                            [[1, 5, 3], [1, 5, 0], [1, 2, 3], [1, 2, 0], [4, 0, 5], [4, 0, 2], [4, 3, 5], [4, 3, 2]],
                            [[0, 2, 6], [6, 8, 0], [2, 0, 8], [8, 6, 2], [0, 6, 6], [2, 8, 8], [6, 0, 0], [8, 2, 2]]
                        ]
    
    var colorArray = [UIColor.red, UIColor.white, UIColor.blue, UIColor.orange, UIColor.yellow, UIColor.green]
    var controlNames = ["F", "R", "U", "B", "L", "D", "F\'", "R\'", "U\'", "B\'", "L\'", "D\'", "rU", "rD", "rL", "rR", "rC", "rCC"]
    var controlArray = [UIButton]()
    let screenSize = UIScreen.main.bounds
    var buttonSize = CGFloat(20)
    var spacing = CGFloat(40)
    var animateDuration = 0.1
    var solutionString = ""
    
    var currentlyMoving = false
    var printMoves = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let scaling = CGFloat(1.0)//0.75)
        spacing = screenSize.width/9*scaling
        if(spacing > screenSize.height*0.0625)
        {
            spacing = screenSize.height*0.0625
        }
        buttonSize = spacing*0.9
        
        makeSides()
        makeControls()
    }
    @objc func solve()
    {
        print("\nNew Scramble")
        scramble()
        solutionString = ""
        doCross()
        orientCross()
        solveCorners()
        orientCorners()
//        print(hasAllEdges(side: 1, color: .white))
//        doFirstLayer()
//        doSecondLayer()
//        doThirdLayer()
    }
    @objc func scramble()
    {
        
        for i in 0...50
        {
            let number = Int.random(in: 0 ... 11)
            controlArray[number].sendActions(for: .touchDown)
        }
    }
    func doFirstLayer()
    {
        doCross()
        orientCross()
        solveCorners()
        orientCorners()
    }
    func hasAllPieces(side: Int, color: UIColor) -> Bool
    {
        for i in 0...cubeArray[side].count - 1
        {
            if(cubeArray[side][i].backgroundColor != color)
            {
                return false
            }
        }
        return true
    }
    func hasAllEdges(side: Int, color: UIColor) -> Bool
    {
        for i in 0...3
        {
            if(cubeArray[side][i*2 + 1].backgroundColor != color)
            {
                return false
            }
        }
        return true
    }
    func hasEdges(side: Int, color: UIColor) -> Bool
    {
        for i in 0...3
        {
            if(cubeArray[side][i*2 + 1].backgroundColor == color)
            {
                return true
            }
        }
        return false
    }
    func hasCorners(side: Int, color: UIColor) -> Bool
    {
        var num = 0;
        for i in 0...3
        {
            if(cubeArray[side][i*2 + num].backgroundColor == color)
            {
                return true
            }
            if(i == 1)
            {
                num = 2
            }
        }
        return false
    }
    func doCross()
    {
        while(!hasAllEdges(side: 1, color: front[4].backgroundColor!))
        {
            var keepGoing = true
            print("\nStart of Cross Loop")
            for i in 0...cubeArray.count - 1    // 6 faces
            {
                for j in 0...3  // 4 edges
                {
                    // Do up, down, back //cubeArray = [down, front, right, up, back, left]
                    if(cubeArray[i][j*2 + 1].backgroundColor == front[4].backgroundColor)
                    {
//                        print("\nFound front color edge at: \(i),\(j*2 + 1)")
                        // Make space for piece
                        if(true)//!(front[1].backgroundColor != .white && front[3].backgroundColor != .white && front[5].backgroundColor != .white && front[7].backgroundColor != .white))   // If at least one empty
                        {
                            if(i == 0 || i == 3 || i == 4)  // down, up, back
                            {
                                // Make space for piece
//                                print("\nMaking space for front color edge 034")
                                while(front[5].backgroundColor == front[4].backgroundColor)
                                {
                                    F()
                                }
                                for m in 0...3
                                {
                                    if(cubeArray[i][m*2 + 1].backgroundColor == front[4].backgroundColor)
                                    {
//                                        print("\nFront color edge new pos: \(i),\(m*2 + 1)")
                                    }
                                }
                                // Line up the piece //cubeArray = [down, front, right, up, back, left]
                                while(cubeArray[i][5].backgroundColor != front[4].backgroundColor && hasEdges(side: i, color: front[4].backgroundColor!))
                                {
//                                    print("\nAligning 034: " + String(i))
                                    print(String((cubeArray[i][5].backgroundColor?.name)!))
                                    if(i == 0)
                                    {
                                        D()
                                    }
                                    else if(i == 3)
                                    {
                                        U()
                                    }
                                    else if(i == 4)
                                    {
                                        B()
                                    }
                                    for m in 0...3
                                    {
                                        if(cubeArray[i][m*2 + 1].backgroundColor == front[4].backgroundColor)
                                        {
//                                            print("\nFront color edge current pos: \(i),\(m*2 + 1)")
                                        }
                                    }
                                }
                                
                                // Insert piece
                                var temp = 0
                                while(front[5].backgroundColor != front[4].backgroundColor && keepGoing)
                                {
                                    R()
                                    temp += 1
                                    if(temp > 4)
                                    {
                                        keepGoing = false
//                                        break
                                    }
                                }
                            }
                            // Do left, right
                            if(i == 2 || i == 5)    //right or left
                            {
//                                print("\nMaking space for front color edge 25")
                                
                                while(front[1].backgroundColor == front[4].backgroundColor)
                                {
                                    F()
                                }
                                for m in 0...3
                                {
                                    if(cubeArray[i][m*2 + 1].backgroundColor == front[4].backgroundColor)
                                    {
//                                        print("\nFront color edge new pos: \(i),\(m*2 + 1)")
                                    }
                                }
                                // Line up the piece
                                while(cubeArray[i][1].backgroundColor != front[4].backgroundColor && hasEdges(side: i, color: front[4].backgroundColor!))
                                {
//                                    print("\nAligning 25: " + String(i))
                                    print(String((cubeArray[i][1].backgroundColor?.name)!))
                                    if(i == 2)
                                    {
                                        R()
                                    }
                                    else if(i == 5)
                                    {
                                        L()
                                    }
                                }
                                // Insert piece
                                var temp = 0
                                while(front[1].backgroundColor != front[4].backgroundColor && keepGoing)
                                {
                                    U()
                                    temp += 1
                                    if(temp > 4)
                                    {
                                        keepGoing = false
//                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
//            if(!keepGoing)
//            {
//                break
//            }
        }
        print("\nFinished Cross")
    }
    func orientCross()
    {
        // Orient Right Cross Edge
        while(!(right[3].backgroundColor == .blue))
        {
            F()
        }
        
        // Orient Cross Edges
        if(up[7].backgroundColor == .red && down[1].backgroundColor == .orange) // Good
        {
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            Fʹ()
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            
            while(!(right[3].backgroundColor == .blue))
            {
                F()
            }
        }
        else if(left[5].backgroundColor == .orange && up[7].backgroundColor == .green && down[1].backgroundColor == .red)   // Good
        {
            Fʹ()
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            
            while(!(right[3].backgroundColor == .blue))
            {
                F()
            }
        }
        else if(left[5].backgroundColor == .red && up[7].backgroundColor == .green && down[1].backgroundColor == .orange)   // Good
        {
            F()
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            
            while(!(right[3].backgroundColor == .blue))
            {
                F()
            }
        }
        else if(left[5].backgroundColor == .orange && up[7].backgroundColor == .red && down[1].backgroundColor == .green)   // Good
        {
            F()
            F()
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            
            while(!(right[3].backgroundColor == .blue))
            {
                F()
            }
        }
        else if(left[5].backgroundColor == .red && up[7].backgroundColor == .orange && down[1].backgroundColor == .green)   // Good
        {
            R()
            F()
            Rʹ()
            F()
            R()
            F()
            F()
            Rʹ()
            
            while(!(right[3].backgroundColor == .blue))
            {
                F()
            }
        }
        print("\nOriented Cross")
    }
    func solveCorners()
    {
        while(!hasAllPieces(side: 1, color: front[4].backgroundColor!))
        {
//            print("==============")
//            for i in 0...cubeArray.count - 1
//            {
//                for j in 0...cubeArray[i].count - 1
//                {
//                    if(cubeArray[i][j].backgroundColor == front[4].backgroundColor)
//                    {
//                        print("\nFound front color edge at: \(i),\(j)")
//                    }
//                }
//            }
            for i in 0...3
            {
                // Down Face
                if(down[0].backgroundColor == front[4].backgroundColor || down[6].backgroundColor == front[4].backgroundColor)  // Good
                {
                    while(!(front[6].backgroundColor == front[4].backgroundColor))
                    {
                        Dʹ()
                        Bʹ()
                        D()
                        B()
                    }
                }
                if(down[2].backgroundColor == front[4].backgroundColor || down[8].backgroundColor == front[4].backgroundColor)  // Good
                {
                    while(!(front[8].backgroundColor == front[4].backgroundColor))
                    {
                        D()
                        B()
                        Dʹ()
                        Bʹ()
                    }
                }
            
                // Check if there are still remaining white pieces, shift them to next side
                if(down[6].backgroundColor == front[4].backgroundColor || down[8].backgroundColor == front[4].backgroundColor)
                {
                    B()
                }
            
                // Right Face
                if(right[0].backgroundColor == front[4].backgroundColor || right[2].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[2].backgroundColor == front[4].backgroundColor))
                    {
                        Uʹ()
                        Bʹ()
                        U()
                        B()
                    }
                }
                if(right[6].backgroundColor == front[4].backgroundColor || right[8].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[8].backgroundColor == front[4].backgroundColor))
                    {
                        D()
                        B()
                        Dʹ()
                        Bʹ()
                    }
                }
                // Check if there are still remaining white pieces, shift them to next side
                if(right[2].backgroundColor == front[4].backgroundColor || right[8].backgroundColor == front[4].backgroundColor)
                {
                    B()
                }
            
                // Up Face
                if(up[0].backgroundColor == front[4].backgroundColor || up[6].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[0].backgroundColor == front[4].backgroundColor))
                    {
                        U()
                        B()
                        Uʹ()
                        Bʹ()
                    }
                }
                if(up[2].backgroundColor == front[4].backgroundColor || up[8].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[2].backgroundColor == front[4].backgroundColor))
                    {
                        Uʹ()
                        Bʹ()
                        U()
                        B()
                    }
                }
                // Check if there are still remaining white pieces, shift them to next side
                if(up[0].backgroundColor == front[4].backgroundColor || up[2].backgroundColor == front[4].backgroundColor)
                {
                    B()
                }
            
                // Left Face
                if(left[0].backgroundColor == front[4].backgroundColor || left[2].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[0].backgroundColor == front[4].backgroundColor))
                    {
                        B()
                        U()
                        Bʹ()
                        Uʹ()
                    }
                }
                if(left[6].backgroundColor == front[4].backgroundColor || left[8].backgroundColor == front[4].backgroundColor)
                {
                    while(!(front[6].backgroundColor == front[4].backgroundColor))
                    {
                        Bʹ()
                        Dʹ()
                        B()
                        D()
                    }
                }
                // Check if there are still remaining white pieces, shift them to next side
                if(left[0].backgroundColor == front[4].backgroundColor || left[6].backgroundColor == front[4].backgroundColor)
                {
                    B()
                }
            
                // Back Face
                if(hasEdges(side: 4, color: front[4].backgroundColor!) || hasCorners(side: 4, color: front[4].backgroundColor!))
                {
                    while(back[0].backgroundColor != front[4].backgroundColor)
                    {
                        B()
                    }
                    // Do pattern
                    while(front[0].backgroundColor != front[4].backgroundColor)
                    {
                        U()
                        Bʹ()
                        Uʹ()
                        B()
                    }
                }
                if(back[6].backgroundColor != front[4].backgroundColor && (back[0].backgroundColor == front[4].backgroundColor || back[2].backgroundColor == front[4].backgroundColor || back[8].backgroundColor == front[4].backgroundColor))
                {
                    while(back[6].backgroundColor != front[4].backgroundColor)
                    {
                        B()
                    }
                    // Do pattern
                    while(front[2].backgroundColor != front[4].backgroundColor)
                    {
                        R()
                        Bʹ()
                        Rʹ()
                        B()
                    }
                }
                if(back[2].backgroundColor != front[4].backgroundColor && (back[0].backgroundColor == front[4].backgroundColor || back[6].backgroundColor == front[4].backgroundColor || back[8].backgroundColor == front[4].backgroundColor))
                {
                    while(back[6].backgroundColor != front[4].backgroundColor)
                    {
                        B()
                    }
                    // Do pattern
                    while(front[6].backgroundColor != front[4].backgroundColor)
                    {
                        Dʹ()
                        B()
                        D()
                        Bʹ()
                    }
                }
                if(back[8].backgroundColor != front[4].backgroundColor && (back[0].backgroundColor == front[4].backgroundColor || back[2].backgroundColor == front[4].backgroundColor || back[6].backgroundColor == front[4].backgroundColor))
                {
                    while(back[8].backgroundColor != front[4].backgroundColor)
                    {
                        B()
                    }
                    // Do pattern
                    while(front[8].backgroundColor != front[4].backgroundColor)
                    {
                        D()
                        Bʹ()
                        Dʹ()
                        B()
                    }
                }
            }
        }
    }
    func orientCorners()
    {
        if(true)//for i in 0...3
        {
            if(isCornerInPlace(s1: 1, s2: 2, s3: 0))
            {
                print("corner1")
                while(!isCornerInPlace(s1: 1, s2: 5, s3: 3))
                {
                    F()
                    R()
                    Fʹ()
                    L()
                    F()
                    Rʹ()
                    Fʹ()
                    Lʹ()
                }
            }
            if(isCornerInPlace(s1: 1, s2: 2, s3: 3))
            {
                print("corner2")
                while(!isCornerInPlace(s1: 1, s2: 5, s3: 3))
                {
                    F()
                    U()
                    Fʹ()
                    Dʹ()
                    F()
                    Uʹ()
                    Fʹ()
                    D()
                }
            }
            if(isCornerInPlace(s1: 1, s2: 5, s3: 3))
            {
                print("corner3")
                while(!isCornerInPlace(s1: 1, s2: 5, s3: 0))
                {
                    F()
                    L()
                    Fʹ()
                    Rʹ()
                    F()
                    Lʹ()
                    Fʹ()
                    R()
                }
            }
            if(isCornerInPlace(s1: 1, s2: 5, s3: 0))
            {
                print("corner4")
                while(!isCornerInPlace(s1: 1, s2: 5, s3: 3))
                {
                    F()
                    D()
                    Fʹ()
                    Uʹ()
                    F()
                    Dʹ()
                    Fʹ()
                    U()
                }
            }
        }
    }
    func doSecondLayer()
    {
        // Fill In Edge Pieces
    }
    func doThirdLayer()
    {
        // Get The Cross
        
        // Orient The Cross
        
        // Get One Corner In Right Spot
        
        // Get All Corners In Right Spots
        
        // Orient Corners
    }
    func makeControls()
    {
        for i in 0...17
        {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
            button.center.x = spacing*CGFloat(i%6) + screenSize.width/2 - spacing*2.5
            button.center.y = spacing*CGFloat(i/6) + screenSize.height*13.5/16
            button.backgroundColor = UIColor.white
            button.setTitle(controlNames[i], for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(makeMove), for: .touchDown)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            self.view.addSubview(button)
            controlArray.append(button)
        }
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize*2, height: buttonSize*2))
        button.center.x = screenSize.width*6.5/8
        button.center.y = screenSize.height*5/8
        button.backgroundColor = UIColor.white
        button.setTitle("Solve", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(solve), for: .touchDown)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        self.view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize*2, height: buttonSize*2))
        button2.center.x = screenSize.width*6.5/8
        button2.center.y = screenSize.height*6/8
        button2.backgroundColor = UIColor.white
        button2.setTitle("Scramble", for: .normal)
        button2.setTitleColor(UIColor.black, for: .normal)
        button2.addTarget(self, action: #selector(scramble), for: .touchDown)
        button2.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderWidth = 1.0
        self.view.addSubview(button2)
    }
    func makeSides()
    {
        let xPos = screenSize.width/2
        let yPos = screenSize.height*2/6
        
        down    = makeSide(colorArray[0], CGPoint(x: xPos, y: yPos + spacing*3), "down")    // Red      - Down
        front   = makeSide(colorArray[1], CGPoint(x: xPos, y: yPos),             "front")   // White    - Front
        right   = makeSide(colorArray[2], CGPoint(x: xPos + spacing*3, y: yPos), "right")   // Blue     - Right
        up      = makeSide(colorArray[3], CGPoint(x: xPos, y: yPos - spacing*3), "up")      // Orange   - Up
        back    = makeSide(colorArray[4], CGPoint(x: xPos, y: yPos + spacing*6), "back")    // Yellow   - Back
        left    = makeSide(colorArray[5], CGPoint(x: xPos - spacing*3, y: yPos), "left")    // Green    - Left
        
        cubeArray = [down, front, right, up, back, left]
    }
    func makeSide(_ color: UIColor, _ center: CGPoint, _ name: String) -> [UIButton]
    {
        var tempButtonArray = [UIButton]()
        var num = -1
        for k in 0...colorArray.count - 1
        {
            if(colorArray[k] == color)
            {
                num = k
                break
            }
        }
        for i in 0...8
        {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
            button.center.x = spacing*CGFloat(i%3 - 1) + center.x
            button.center.y = spacing*CGFloat(i/3 - 1) + center.y
            button.backgroundColor = color
            button.setTitle(String(num) + ", " + String(i), for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.addTarget(self, action: #selector(changeColor), for: .touchDown)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.0
            self.view.addSubview(button)
            tempButtonArray.append(button)
        }
        return tempButtonArray
    }
    @objc func changeColor(_ sender: UIButton)
    {
        for i in 0...colorArray.count-1
        {
            if(sender.backgroundColor == colorArray[i])
            {
                sender.backgroundColor = colorArray[(i+1)%(colorArray.count)]
                break
            }
        }
    }
    @objc func makeMove(_ sender: UIButton)
    {
        if(sender.titleLabel!.text == "F")
        {
            F()
        }
        else if(sender.titleLabel!.text == "F\'")
        {
            Fʹ()
        }
        else if(sender.titleLabel!.text == "R")
        {
            R()
        }
        else if(sender.titleLabel!.text == "R\'")
        {
            Rʹ()
        }
        else if(sender.titleLabel!.text == "U")
        {
            U()
        }
        else if(sender.titleLabel!.text == "U\'")
        {
            Uʹ()
        }
        else if(sender.titleLabel!.text == "B")
        {
            B()
        }
        else if(sender.titleLabel!.text == "B\'")
        {
            Bʹ()
        }
        else if(sender.titleLabel!.text == "L")
        {
            L()
        }
        else if(sender.titleLabel!.text == "L\'")
        {
            Lʹ()
        }
        else if(sender.titleLabel!.text == "D")
        {
            D()
        }
        else if(sender.titleLabel!.text == "D\'")
        {
            Dʹ()
        }
        else if(sender.titleLabel!.text == "rU")
        {
            rU()
        }
        else if(sender.titleLabel!.text == "rD")
        {
            rD()
        }
        else if(sender.titleLabel!.text == "rL")
        {
            rL()
        }
        else if(sender.titleLabel!.text == "rR")
        {
            rR()
        }
        else if(sender.titleLabel!.text == "rC")
        {
            rC()
        }
        else if(sender.titleLabel!.text == "rCC")
        {
            rCC()
        }
    }
    func isCornerInPlace(s1: Int, s2: Int, s3: Int) -> Bool
    {
        var allColors = true
        var loc = -1
        for i in 0...cornerArray[0].count - 1
        {
            if(cornerArray[0][i].contains(s1) && cornerArray[0][i].contains(s2) && cornerArray[0][i].contains(s3))
            {
                loc = i
                break
            }
        }
        var tempColors = [UIColor]()
        for i in 0...cornerArray[1][loc].count - 1
        {
            tempColors.append(colorArray[cornerArray[0][loc][0]])
        }
        for i in 0...cornerArray[1][loc].count - 1
        {
            if(!(tempColors.contains(cubeArray[cornerArray[0][loc][i]][cornerArray[1][loc][i]].backgroundColor!)))
            {
                return false
            }
        }
        return true
    }
    func rU()
    {
        for i in 0...8
        {
            var temp = up[i].backgroundColor
            up[i].backgroundColor = front[i].backgroundColor
            front[i].backgroundColor = down[i].backgroundColor
            down[i].backgroundColor = back[i].backgroundColor
            back[i].backgroundColor = temp
        }
    }
    func rD()
    {
        for i in 0...8
        {
            let temp = up[i].backgroundColor
            up[i].backgroundColor = back[i].backgroundColor
            back[i].backgroundColor = down[i].backgroundColor
            down[i].backgroundColor = front[i].backgroundColor
            front[i].backgroundColor = temp
        }
    }
    func rL()
    {
        for i in 0...8
        {
            let temp = front[i].backgroundColor
            front[i].backgroundColor = right[i].backgroundColor
            right[i].backgroundColor = back[i].backgroundColor
            back[i].backgroundColor = left[i].backgroundColor
            left[i].backgroundColor = temp
        }
    }
    func rR()
    {
        for i in 0...8
        {
            let temp = front[i].backgroundColor
            front[i].backgroundColor = left[i].backgroundColor
            left[i].backgroundColor = back[i].backgroundColor
            back[i].backgroundColor = right[i].backgroundColor
            right[i].backgroundColor = temp
        }
    }
    func rC()
    {
        for i in 0...8
        {
            let temp = up[i].backgroundColor
            up[i].backgroundColor = left[i].backgroundColor
            left[i].backgroundColor = down[i].backgroundColor
            down[i].backgroundColor = right[i].backgroundColor
            right[i].backgroundColor = temp
        }
    }
    func rCC()
    {
        for i in 0...8
        {
            let temp = up[i].backgroundColor
            up[i].backgroundColor = right[i].backgroundColor
            right[i].backgroundColor = down[i].backgroundColor
            down[i].backgroundColor = left[i].backgroundColor
            left[i].backgroundColor = temp
        }
    }
    func F()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
            {
            // animation
            if(self.printMoves)
            {
                print("F", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.up[6 + i].backgroundColor
                self.up[6 + i].backgroundColor = self.left[8 - i*3].backgroundColor
                self.left[8 - i*3].backgroundColor = self.down[2 - i].backgroundColor
                self.down[2 - i].backgroundColor = self.right[i*3].backgroundColor
                self.right[i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.front[i].backgroundColor
                self.front[i].backgroundColor = self.front[6 - i*3].backgroundColor
                self.front[6 - i*3].backgroundColor = self.front[8 - i].backgroundColor
                self.front[8 - i].backgroundColor = self.front[2 + i*3].backgroundColor
                self.front[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Fʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("F\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.right[i*3].backgroundColor
                self.right[i*3].backgroundColor = self.down[2 - i].backgroundColor
                self.down[2 - i].backgroundColor = self.left[8 - i*3].backgroundColor
                self.left[8 - i*3].backgroundColor = self.up[6 + i].backgroundColor
                self.up[6 + i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.front[2 + i*3].backgroundColor
                self.front[2 + i*3].backgroundColor = self.front[8 - i].backgroundColor
                self.front[8 - i].backgroundColor = self.front[6 - i*3].backgroundColor
                self.front[6 - i*3].backgroundColor = self.front[i].backgroundColor
                self.front[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func R()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("R", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.down[2 + i*3].backgroundColor
                
                self.down[2 + i*3].backgroundColor = self.back[2 + i*3].backgroundColor
                self.back[2 + i*3].backgroundColor = self.up[2 + i*3].backgroundColor
                self.up[2 + i*3].backgroundColor = self.front[2 + i*3].backgroundColor
                self.front[2 + i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.right[i].backgroundColor
                self.right[i].backgroundColor = self.right[6 - i*3].backgroundColor
                self.right[6 - i*3].backgroundColor = self.right[8 - i].backgroundColor
                self.right[8 - i].backgroundColor = self.right[2 + i*3].backgroundColor
                self.right[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Rʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("R\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.front[2 + i*3].backgroundColor
                self.front[2 + i*3].backgroundColor = self.up[2 + i*3].backgroundColor
                self.up[2 + i*3].backgroundColor = self.back[2 + i*3].backgroundColor
                self.back[2 + i*3].backgroundColor = self.down[2 + i*3].backgroundColor
                self.down[2 + i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.right[2 + i*3].backgroundColor
                self.right[2 + i*3].backgroundColor = self.right[8 - i].backgroundColor
                self.right[8 - i].backgroundColor = self.right[6 - i*3].backgroundColor
                self.right[6 - i*3].backgroundColor = self.right[i].backgroundColor
                self.right[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func U()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("U", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.right[i].backgroundColor
                self.right[i].backgroundColor = self.back[8 - i].backgroundColor
                self.back[8 - i].backgroundColor = self.left[i].backgroundColor
                self.left[i].backgroundColor = self.front[i].backgroundColor
                self.front[i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.up[i].backgroundColor
                self.up[i].backgroundColor = self.up[6 - i*3].backgroundColor
                self.up[6 - i*3].backgroundColor = self.up[8 - i].backgroundColor
                self.up[8 - i].backgroundColor = self.up[2 + i*3].backgroundColor
                self.up[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Uʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("U\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.front[i].backgroundColor
                self.front[i].backgroundColor = self.left[i].backgroundColor
                self.left[i].backgroundColor = self.back[8 - i].backgroundColor
                self.back[8 - i].backgroundColor = self.right[i].backgroundColor
                self.right[i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.up[2 + i*3].backgroundColor
                self.up[2 + i*3].backgroundColor = self.up[8 - i].backgroundColor
                self.up[8 - i].backgroundColor = self.up[6 - i*3].backgroundColor
                self.up[6 - i*3].backgroundColor = self.up[i].backgroundColor
                self.up[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func B()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("B", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.right[2 + i*3].backgroundColor
                self.right[2 + i*3].backgroundColor = self.down[8 - i].backgroundColor
                self.down[8 - i].backgroundColor = self.left[6 - i*3].backgroundColor
                self.left[6 - i*3].backgroundColor = self.up[i].backgroundColor
                self.up[i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.back[i].backgroundColor
                self.back[i].backgroundColor = self.back[6 - i*3].backgroundColor
                self.back[6 - i*3].backgroundColor = self.back[8 - i].backgroundColor
                self.back[8 - i].backgroundColor = self.back[2 + i*3].backgroundColor
                self.back[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Bʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("B\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.up[i].backgroundColor
                self.up[i].backgroundColor = self.left[6 - i*3].backgroundColor
                self.left[6 - i*3].backgroundColor = self.down[8 - i].backgroundColor
                self.down[8 - i].backgroundColor = self.right[2 + i*3].backgroundColor
                self.right[2 + i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.back[2 + i*3].backgroundColor
                self.back[2 + i*3].backgroundColor = self.back[8 - i].backgroundColor
                self.back[8 - i].backgroundColor = self.back[6 - i*3].backgroundColor
                self.back[6 - i*3].backgroundColor = self.back[i].backgroundColor
                self.back[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func L()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("L", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.front[i*3].backgroundColor
                self.front[i*3].backgroundColor = self.up[i*3].backgroundColor
                self.up[i*3].backgroundColor = self.back[i*3].backgroundColor
                self.back[i*3].backgroundColor = self.down[i*3].backgroundColor
                self.down[i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.left[i].backgroundColor
                self.left[i].backgroundColor = self.left[6 - i*3].backgroundColor
                self.left[6 - i*3].backgroundColor = self.left[8 - i].backgroundColor
                self.left[8 - i].backgroundColor = self.left[2 + i*3].backgroundColor
                self.left[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Lʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("L\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.down[i*3].backgroundColor
                
                self.down[i*3].backgroundColor = self.back[i*3].backgroundColor
                self.back[i*3].backgroundColor = self.up[i*3].backgroundColor
                self.up[i*3].backgroundColor = self.front[i*3].backgroundColor
                self.front[i*3].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.left[2 + i*3].backgroundColor
                self.left[2 + i*3].backgroundColor = self.left[8 - i].backgroundColor
                self.left[8 - i].backgroundColor = self.left[6 - i*3].backgroundColor
                self.left[6 - i*3].backgroundColor = self.left[i].backgroundColor
                self.left[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func D()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("D", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.front[6 + i].backgroundColor
                self.front[6 + i].backgroundColor = self.left[6 + i].backgroundColor
                self.left[6 + i].backgroundColor = self.back[2 - i].backgroundColor
                self.back[2 - i].backgroundColor = self.right[6 + i].backgroundColor
                self.right[6 + i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.down[i].backgroundColor
                self.down[i].backgroundColor = self.down[6 - i*3].backgroundColor
                self.down[6 - i*3].backgroundColor = self.down[8 - i].backgroundColor
                self.down[8 - i].backgroundColor = self.down[2 + i*3].backgroundColor
                self.down[2 + i*3].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
    func Dʹ()
    {
        currentlyMoving = true
        UIView.transition(with: self.view, duration: animateDuration, options: .curveEaseInOut, animations:
        {
            if(self.printMoves)
            {
                print("D\'", terminator:"")
            }
            for i in 0...2
            {
                let tempColor = self.right[6 + i].backgroundColor
                self.right[6 + i].backgroundColor = self.back[2 - i].backgroundColor
                self.back[2 - i].backgroundColor = self.left[6 + i].backgroundColor
                self.left[6 + i].backgroundColor = self.front[6 + i].backgroundColor
                self.front[6 + i].backgroundColor = tempColor
            }
            for i in 0...1
            {
                let tempColor = self.down[2 + i*3].backgroundColor
                self.down[2 + i*3].backgroundColor = self.down[8 - i].backgroundColor
                self.down[8 - i].backgroundColor = self.down[6 - i*3].backgroundColor
                self.down[6 - i*3].backgroundColor = self.down[i].backgroundColor
                self.down[i].backgroundColor = tempColor
            }
        }, completion: { (finished: Bool) -> () in
            self.currentlyMoving = false
        })
    }
}
extension UIColor
{
    var name: String?
    {
        switch self
        {
            case UIColor.black: return "black"
            case UIColor.darkGray: return "darkGray"
            case UIColor.lightGray: return "lightGray"
            case UIColor.white: return "white"
            case UIColor.gray: return "gray"
            case UIColor.red: return "red"
            case UIColor.green: return "green"
            case UIColor.blue: return "blue"
            case UIColor.cyan: return "cyan"
            case UIColor.yellow: return "yellow"
            case UIColor.magenta: return "magenta"
            case UIColor.orange: return "orange"
            case UIColor.purple: return "purple"
            case UIColor.brown: return "brown"
            default: return nil
        }
    }
}
