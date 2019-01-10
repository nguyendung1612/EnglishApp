//
//  Game1ViewController.swift
//  EnglishApp
//
//  Created by Nguyen Phuoc An on 12/21/18.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit

class Game1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        run()
    }
    

    var count = 1
    var score = 0
    var number = 0
    var result = 0
    var isAppear = [Int]()
    var isAnswer = [Int]()
    var second = 10
    var timer = Timer()
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnAnswer_A: UIButton!
    @IBOutlet weak var btnAnswer_B: UIButton!
    @IBOutlet weak var btnAnswer_C: UIButton!
    @IBOutlet weak var btnAnswer_D: UIButton!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAnswer(_ sender: Any) {
        count += 1
        stopTimeDown()
        if (result == (sender as AnyObject).tag){
            score += 10
        }
        else{
            
        }
        run()
    }
    
    func run(){
        if count <= 10{
            startTimeDown()
            displayQuestion()
        }
        else{
            stopTimeDown()
            lblScore.text = "Score: \(score)/100"
            let alert:UIAlertController = UIAlertController(title: "You gain \(score) points", message: "End of Quiz. Do you want to start over?", preferredStyle: UIAlertController.Style.alert)
            
            let btnRestart:UIAlertAction = UIAlertAction(title: "Restart", style: UIAlertAction.Style.destructive) { (btn) in
                self.restartGame()
            }
            alert.addAction(btnRestart)
            
            let btnClose: UIAlertAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel){(btn) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(btnClose)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func displayQuestion(){
        number = newNumber(array: isAppear)
        isAppear.append(number)
        result = Int.random(in: 0 ... 3)
        lblCount.text = "\(count)/10"
        lblScore.text = "Score: \(score)/100"
        lblQuestion.text = gameWords[number].mean
        var num = 0
        isAnswer.removeAll()
        isAnswer.append(number)
        
        switch result {
        case 0:
            btnAnswer_A.setTitle("\(gameWords[number].english)", for: .normal)
            num = newNumber(array: isAnswer)
            btnAnswer_B.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_C.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_D.setTitle("\(gameWords[num].english)", for: .normal)
            break
        case 1:
            btnAnswer_B.setTitle("\(gameWords[number].english)", for: .normal)
            num = newNumber(array: isAnswer)
            btnAnswer_A.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_C.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_D.setTitle("\(gameWords[num].english)", for: .normal)
            break
        case 2:
            btnAnswer_C.setTitle("\(gameWords[number].english)", for: .normal)
            num = newNumber(array: isAnswer)
            btnAnswer_B.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_A.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_D.setTitle("\(gameWords[num].english)", for: .normal)
            break
        case 3:
            btnAnswer_D.setTitle("\(gameWords[number].english)", for: .normal)
            num = newNumber(array: isAnswer)
            btnAnswer_B.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_C.setTitle("\(gameWords[num].english)", for: .normal)
            isAnswer.append(num)
            num = newNumber(array: isAnswer)
            btnAnswer_A.setTitle("\(gameWords[num].english)", for: .normal)
            break
        default:
            break
        }
        //print(Anwords.count)
    }
    
    func newNumber(array:[Int])->Int{
        var num = Int.random(in: 0 ..< 11)
        while (array.contains(num)){
            num = Int.random(in: 0 ..< 12)
        }
        return num
    }
    
    func restartGame(){
        count = 1
        score = 0
        isAppear.removeAll()
        run()
    }
    
    func startTimeDown(){
        second = 10
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counter), userInfo: nil, repeats: true)
    }
    
    func stopTimeDown(){
        timer.invalidate()
    }
    
    @objc func counter(){
        second -= 1
        lblTime.text = String(second)
        if (second == 0){
            stopTimeDown()
            count += 1
            run()
        }
    }
    
    func delay(time: Int){
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            
        }
    }
    


}
