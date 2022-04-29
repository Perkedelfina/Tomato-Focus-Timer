//
//  ViewController.swift
//  Tomato Focus Timer
//
//  Created by Delfina Paulin on 27/04/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum timerType {
        case pomodoro
        case shortBreak
        case longBreak
    }
    
    let timers: [timerType] = [.pomodoro, .shortBreak,
                               .pomodoro, .shortBreak,
                               .pomodoro, .shortBreak,
                               .pomodoro, .longBreak]
    let pomodoroTimerTime = 1500
    let shortBreakTimerTime = 300
    let longBreakTimerTime = 900
    
    var currentTimer = 0
    var timeRemaining = 0
    var timer = Timer()
    var avPlayerZero = AVAudioPlayer()
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var colonLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var flameSlot1: UIImageView!
    @IBOutlet weak var flameSlot2: UIImageView!
    @IBOutlet weak var flameSlot3: UIImageView!
    @IBOutlet weak var flameSlot4: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetToBeginning()
        do{
            let avPath = Bundle.main.path(forResource: "Ring", ofType: ".wav")
            try avPlayerZero = AVAudioPlayer(contentsOf: URL(fileURLWithPath: avPath!))
        }
        catch{
            //ERROR
        }
    }
    
    @IBAction func pressStart(_ sender: Any) {
        if timer.isValid{
            startButton.setTitle("RESUME", for: .normal)
            stopButton.isEnabled = true
            pauseTimer()
        }
        else{
            startButton.setTitle("PAUSE", for: .normal)
            stopButton.isEnabled = false
            if currentTimer == 0 && timeRemaining == pomodoroTimerTime {
                startNextTimer()
            }
            else{
                startTimer()
            }
        }
    }
    
    @IBAction func pressStop(_ sender: Any) {
        if timer.isValid{
            timer.invalidate()
        }
        resetToBeginning()
    }
    
    func resetToBeginning(){
        currentTimer = 0
        let chestnutColor = getUIColor(hex: "#CD5C5C")
        minutesLabel.textColor = chestnutColor
        colonLabel.textColor = chestnutColor
        secondsLabel.textColor = chestnutColor
        flameSlot1.tintColor = chestnutColor
        flameSlot1.image = UIImage(systemName: "flame.fill")
        flameSlot2.tintColor = chestnutColor
        flameSlot2.image = UIImage(systemName: "flame")
        flameSlot3.tintColor = chestnutColor
        flameSlot3.image = UIImage(systemName: "flame")
        flameSlot4.tintColor = chestnutColor
        flameSlot4.image = UIImage(systemName: "flame")
        descriptionLabel.text = "Let’s go, it’s time to focus on your task"
        descriptionLabel.textColor = chestnutColor
        startButton.setTitleColor(chestnutColor, for: .normal)
        startButton.setTitle("START", for: .normal)
        stopButton.setTitleColor(chestnutColor, for: .normal)
        stopButton.isEnabled = false
        timeRemaining = pomodoroTimerTime
        updateDisplay()
    }
    
    func startNextTimer(){
        let chestnutColor = getUIColor(hex: "#CD5C5C")
        let forestGreenColor = getUIColor(hex: "#228B22")
        let steelBlueColor = getUIColor(hex: "#4682B4")
        if currentTimer < timers.count{
            if timers[currentTimer] == .pomodoro{
                timeRemaining = pomodoroTimerTime
                minutesLabel.textColor = chestnutColor
                colonLabel.textColor = chestnutColor
                secondsLabel.textColor = chestnutColor
                flameSlot1.tintColor = chestnutColor
                flameSlot2.tintColor = chestnutColor
                flameSlot3.tintColor = chestnutColor
                flameSlot4.tintColor = chestnutColor
                descriptionLabel.textColor = chestnutColor
                startButton.setTitleColor(chestnutColor, for: .normal)
                stopButton.setTitleColor(chestnutColor, for: .normal)
            }
            else if timers[currentTimer] == .shortBreak{
                timeRemaining = shortBreakTimerTime
                minutesLabel.textColor = forestGreenColor
                colonLabel.textColor = forestGreenColor
                secondsLabel.textColor = forestGreenColor
                flameSlot1.tintColor = forestGreenColor
                flameSlot2.tintColor = forestGreenColor
                flameSlot3.tintColor = forestGreenColor
                flameSlot4.tintColor = forestGreenColor
                descriptionLabel.textColor = forestGreenColor
                startButton.setTitleColor(forestGreenColor, for: .normal)
                stopButton.setTitleColor(forestGreenColor, for: .normal)
            }
            else{
                timeRemaining = longBreakTimerTime
                minutesLabel.textColor = steelBlueColor
                colonLabel.textColor = steelBlueColor
                secondsLabel.textColor = steelBlueColor
                flameSlot1.tintColor = steelBlueColor
                flameSlot2.tintColor = steelBlueColor
                flameSlot3.tintColor = steelBlueColor
                flameSlot4.tintColor = steelBlueColor
                descriptionLabel.textColor = steelBlueColor
                startButton.setTitleColor(steelBlueColor, for: .normal)
                stopButton.setTitleColor(steelBlueColor, for: .normal)
            }
            updateDisplay()
            startTimer()
            
            if (currentTimer >= 0 && currentTimer < 2){
                flameSlot1.image = UIImage(systemName: "flame.fill")
                if timers[currentTimer] == .pomodoro{
                    descriptionLabel.text = "Let’s go, it’s time to focus on your task"
                }
                else{
                    descriptionLabel.text = "Get some rest, avoid the screen!"
                }
            }
            else if (currentTimer >= 2 && currentTimer < 4){
                flameSlot2.image = UIImage(systemName: "flame.fill")
                if timers[currentTimer] == .pomodoro{
                    descriptionLabel.text = "Let’s continue that task again"
                }
                else{
                    descriptionLabel.text = "Go and take some snacks to boost your energy"
                }
            }
            else if (currentTimer >= 4 && currentTimer < 6){
                flameSlot3.image = UIImage(systemName: "flame.fill")
                if timers[currentTimer] == .pomodoro{
                    descriptionLabel.text = "It’s not that hard right? You can do this!"
                }
                else{
                    descriptionLabel.text = "Do some stretching to increase your focus"
                }
            }
            else{
                flameSlot4.image = UIImage(systemName: "flame.fill")
                if timers[currentTimer] == .pomodoro{
                    descriptionLabel.text = "Let’s get your work done, you got this!"
                }
                else{
                    descriptionLabel.text = "Walk around and get some drink to stay hydrated"
                }
            }
            currentTimer += 1
        }
        else{
            resetToBeginning()
        }
    }
    
    func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cleanString.hasPrefix("#")) {
            cleanString.remove(at: cleanString.startIndex)
        }

        if ((cleanString.count) != 6) {
            return nil
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
        
    @objc func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateDisplay(){
        let (minutes, seconds) = minutesAndSeconds(from:timeRemaining)
        minutesLabel.text = formatMinuteOrSecond(_number: minutes)
        secondsLabel.text = formatMinuteOrSecond(_number: seconds)
    }
    
    @objc func updateTimer(){
        if timeRemaining > 0{
            timeRemaining -= 1
            if timeRemaining == 0{
                avPlayerZero.play()
            }
            updateDisplay()
        }
        else{
            timer.invalidate()
            startNextTimer()
        }
    }
    
    func pauseTimer(){
        timer.invalidate()
    }
    
    func minutesAndSeconds(from seconds: Int) -> (Int, Int){
        return(seconds/60, seconds%60)
    }
    
    func formatMinuteOrSecond(_number:Int) -> String{
        return String(format: "%02d", _number)
    }
}
