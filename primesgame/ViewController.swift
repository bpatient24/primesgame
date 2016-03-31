//
//  ViewController.swift
//  primesgame
//
//  Created by Ben Patient on 3/29/16.
//  Copyright © 2016 Ben Patient. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //labels
    @IBOutlet var score: UILabel!
    
    @IBOutlet var lives: UILabel!
    
    @IBOutlet var heading: UILabel!
    
    @IBOutlet var intro: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var highscoreLabel: UILabel!

    //buttons
    @IBOutlet var easy: UIButton!
    
    @IBOutlet var medium: UIButton!
    
    @IBOutlet var hard: UIButton!
    
    @IBOutlet var extreme: UIButton!
    
    @IBOutlet var yes: UIButton!
    
    @IBOutlet var no: UIButton!
    
    @IBOutlet var playAgain: UIButton!
    
    //variables
    var nums = [Bool]()
    
    var lifeCount = 3
    
    var scoreCount = 0
    
    var timer = NSTimer()
    
    var highScore = 0
    
    var clock = 3.0
    
    var size = 0
    
    var difficulty = 0 // easy-0 medium-1 hard-2 extreme-3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        if highscoreDefault.valueForKey("Highscore") != nil
        {
            highScore = highscoreDefault.valueForKey("Highscore") as! NSInteger!
            highscoreLabel.text = "Highscore: " + String(highScore)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func easyMode(sender: AnyObject) {
        makeList(100)
        size = nums.count
        difficulty = 0
        initializeGame()
    }
    
    @IBAction func mediumMode(sender: AnyObject) {
        makeList(200)
        size = nums.count
        difficulty = 1
        initializeGame()
    }
    
    @IBAction func hardMode(sender: AnyObject) {
        makeList(500)
        size = nums.count
        difficulty = 2
        initializeGame()
    }
    
    @IBAction func extremeMode(sender: AnyObject) {
        makeList(1000)
        size = nums.count
        difficulty = 3
        initializeGame()
    }
    
    @IBAction func yesPressed(sender: AnyObject) {
        let number = Int(num.text!)
        if nums[number!] == false
        {
            if lifeCount > 1
            {
                decreaseLife()
                num.text = String(getNextnum())

            }
            else
            {
                endGame()
            }
        }
        else
        {
            increaseScore()
            num.text = String(getNextnum())
        }
        clock = 3.5
        checkHighscore()
    }
    
    @IBAction func noPressed(sender: AnyObject) {
        let number = Int(num.text!)
        if nums[number!] == false
        {
            increaseScore()
            num.text = String(getNextnum())
            
        }
        else
        {
            if lifeCount > 1
            {
                decreaseLife()
                num.text = String(getNextnum())
            }
            else
            {
                endGame()
                
            }
        }
        clock = 3.5
        checkHighscore()
    }
    
    @IBAction func playAgain(sender: AnyObject) {
        lifeCount = 3
        scoreCount = 0
        timer.invalidate()
        clock = 3.0
        heading.text = "PRIME?"
        intro.text = "Decide whether the presented number is prime or not. Try to get as many right in a row as possible."
        playAgain.hidden = true
        easy.hidden = false
        medium.hidden = false
        hard.hidden = false
        extreme.hidden = false
        
    }
    
    func makeList(var number: Int)
    {
        nums = [Bool](count: number + 1, repeatedValue: true)
        nums[0] = false
        nums[1] = false
        
        for i in 2 ..< size
        {
            if nums[i]
            {
                for var j = i*i; j < size; j += i
                {
                    nums[j] = false
                }
            }
        }
    }
    
    func getNextnum() -> Int
    {
        var nextNumber = Int(arc4random_uniform(UInt32(size)))
        if difficulty == 0
        {
            return nextNumber
        }
        if difficulty == 1 || difficulty == 2
        {
            while nextNumber % 2 == 0
            {
                nextNumber = Int(arc4random_uniform(UInt32(size)))
 
            }
        }
        if difficulty == 3
        {
            while nextNumber % 2 == 0 || nextNumber % 5 == 0
            {
                nextNumber = Int(arc4random_uniform(UInt32(size)))
            }
        }
        return nextNumber
    }
    
    func timerAction()
    {
        if clock > 0.1
        {
            clock += -0.5
            time.text = "Time: " + String(clock)
        }
        else
        {
            if lifeCount > 1
            {
                decreaseLife()
                let size = nums.count
                let nextNumber = Int(arc4random_uniform(UInt32(size)))
                num.text = String(nextNumber)
                clock = 3.5
            }
            else
            {
                checkHighscore()
                endGame()
                
            }
        }
    }
    
    func checkHighscore()
    {
        if scoreCount > highScore
        {
            highScore = scoreCount
            highscoreLabel.text = "Highscore: " + String(highScore)
            
            var highscoreDefault = NSUserDefaults.standardUserDefaults()
            highscoreDefault.setValue(highScore, forKey: "Highscore")
            highscoreDefault.synchronize()
        }
    }
    
    func decreaseLife()
    {
        lifeCount += -1
        lives.text = "Lives: " + String(lifeCount)
    }
    
    func increaseScore()
    {
        scoreCount += 1
        score.text = "Score: " + String(scoreCount)
    }
    
    func initializeGame()
    {
        easy.hidden = true
        medium.hidden = true
        hard.hidden = true
        extreme.hidden = true
        yes.hidden = false
        no .hidden = false
        score.text = "Score: " + String(scoreCount)
        score.hidden = false
        lives.text = "Lives: " + String(lifeCount)
        lives.hidden = false
        heading.hidden = true
        intro.hidden = true
        time.hidden = false
        time.text = "Time: " + String(clock)
        num.hidden = false
        let size = nums.count
        let number = getNextnum()
        num.text = String(number)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
    
    func endGame()
    {
        score.hidden = true
        lives.hidden = true
        heading.hidden = false
        heading.text = "Game Over!"
        intro.hidden = false
        intro.text = "You ran out of lives!" + "\n" +
                     "Final score: " + String(scoreCount) + "\n" +
                     "Highscore: " + String(highScore)
        
        time.hidden = true
        num.hidden = true
        yes.hidden = true
        no.hidden = true
        playAgain.hidden = false
    }
    
}

