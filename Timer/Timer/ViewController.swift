//
//  ViewController.swift
//  Timer
//
//  Created by nathalia karine on 14/09/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Timer: UILabel!
    @IBOutlet weak var BotaoStart: UIButton!
    @IBOutlet weak var BotaoStop: UIButton!
    
    var timeCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefault = UserDefaults.standard
    let start_time_key = "startTime"
    let stop_time_key = "stopTime"
    let conting_time_key = "countingKey"
    
    var scheduleTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTime = userDefault.object(forKey: start_time_key) as? Date
        stopTime = userDefault.object(forKey: stop_time_key) as? Date
        timeCounting = userDefault.bool(forKey: conting_time_key)
        
        if timeCounting {
            startTimer()
        } else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(start: start, stop: stop)
                                        let diff = Date().timeIntervalSince(time)
                                        setTimeLabel(val: Int(diff))
                }
            }
        }
    }

    @IBAction func StartClicou(_ sender: Any) {
        
        if timeCounting {
            setStopTime(date: Date())
            stopTimer()
        }
        else{
            if let stop = stopTime{
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                                setStopTime(date: nil)
                                setStartTime(date: restartTime)
            }
            else {
                setStartTime(date: Date())
            }
            startTimer()
        }
        
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date{
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer(){
        scheduleTimer = Foundation.Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(val: true)
//        startTime.setTitle("Stop", for: .normal)
        
    }
    
    @objc func refreshValue(){
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(val: Int(diff))
        } else {
            stopTimer()
            setTimeLabel(val: 0)
            
        }
    }
    func setTimeLabel( val : Int){
        let time = segundosHorasMinutosSegundos(ms: val)
        let timeString = makeTimeString(hora: time.0, minuto: time.1, segundo: time.2)
        Timer.text = timeString
        
    }
    func segundosHorasMinutosSegundos( ms: Int) -> (Int, Int, Int){
        let hora = ms/3600
        let minuto = (ms % 3600)/60
        let segundo = (ms % 3600)%60
        return (hora, minuto, segundo)
    }
    
    func makeTimeString(hora: Int, minuto: Int, segundo: Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hora)
        timeString += ":"
        timeString += String(format: "%02d", minuto)
        timeString += ":"
        timeString += String(format: "%02d", segundo)
        return timeString
    }
    
    func stopTimer(){
        if scheduleTimer != nil{
            scheduleTimer.invalidate()
        }
        setTimerCounting(val: false)
        
    }
    
    @IBAction func ResetClicou(_ sender: Any) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        Timer.text = makeTimeString(hora: 0, minuto: 0, segundo: 0)
        stopTimer()
        
    }
    func setStartTime(date: Date?){
        startTime = date
        userDefault.set(date, forKey: start_time_key)
    }
    func setStopTime(date: Date?){
        stopTime = date
        userDefault.set(date, forKey: stop_time_key)
    }
    func setTimerCounting(val: Bool){
        timeCounting = val
        userDefault.set(timeCounting, forKey: conting_time_key)
    }
}

