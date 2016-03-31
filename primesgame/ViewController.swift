//
//  ViewController.swift
//  primesgame
//
//  Created by Ben Patient on 3/29/16.
//  Copyright © 2016 Ben Patient. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var score: UILabel!
    
    @IBOutlet var lives: UILabel!
    
    @IBOutlet var heading: UILabel!
    
    @IBOutlet var intro: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var num: UILabel!
    
    @IBOutlet var highscoreLabel: UILabel!

    
    
    @IBOutlet var easy: UIButton!
    
    @IBOutlet var medium: UIButton!
    
    @IBOutlet var hard: UIButton!
    
    @IBOutlet var extreme: UIButton!
    
    @IBOutlet var yes: UIButton!
    
    @IBOutlet var no: UIButton!
    
    @IBOutlet var playAgain: UIButton!
    
    
    var nums = [Bool]()
    
    var lifeCount = 3
    
    var scoreCount = 0
    
    var timer = NSTimer()
    
    var highScore = 0
    
    var clock = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var highscoreDefault = NSUserDefaults.standardUserDefaults()
        if highscoreDefault.valueForKey("Highscore") != nil
        {
            highScore = highscoreDefault.valueForKey("Highscore") as! NSInteger!
            highscoreLabel.text = "Highscore: " + String(highScore)
        }
        score.hidden = true
        lives.hidden = true
        time.hidden = true
        num.hidden = true
        yes.hidden = true
        no.hidden = true
        playAgain.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func easyMode(sender: AnyObject) {
        makeList(100)
        initializeGame()
    }
    
    @IBAction func mediumMode(sender: AnyObject) {
        makeList(200)
        initializeGame()
    }
    
    @IBAction func hardMode(sender: AnyObject) {
        makeList(500)
        initializeGame()
    }
    
    @IBAction func extremeMode(sender: AnyObject) {
        makeList(5000)
        initializeGame()
    }
    
    @IBAction func yesPressed(sender: AnyObject) {
        let number = Int(num.text!)
        let size = nums.count
        let nextNumber = Int(arc4random_uniform(UInt32(size)))
        if nums[number!] == false
        {
            if lifeCount > 1
            {
                decreaseLife()
                num.text = String(nextNumber)

            }
            else
            {
                endGame()
            }
        }
        else
        {
            increaseScore()
            num.text = String(nextNumber)
        }
        clock = 3.5
        checkHighscore()
    }
    
    @IBAction func noPressed(sender: AnyObject) {
        let number = Int(num.text!)
        let size = nums.count
        let nextNumber = Int(arc4random_uniform(UInt32(size)))
        if nums[number!] == false
        {
            increaseScore()
            num.text = String(nextNumber)
            
        }
        else
        {
            if lifeCount > 1
            {
                decreaseLife()
                num.text = String(nextNumber)
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
        let size = nums.count
        
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
        let number = Int(arc4random_uniform(UInt32(size)))
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

