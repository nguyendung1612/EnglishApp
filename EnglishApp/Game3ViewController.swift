//
//  Game3ViewController.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 17/12/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class Game3ViewController: UIViewController {
    
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblWrong: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var lessionName: String = ""
    var wordgame = [Word]()
    var player:AVPlayer!
    var english = [String]()
    var temp = [String]()
    var ans : String = ""
    var score = 0
    var countQues = 1 //so cau hoi
    var isFalse = 2 //so lan tra loi sai
    var ques = 0 //random cau hoi
    var waiter = 5 //cho hien ket qua
    var timer = Timer()
    var modeBtnKiemTra = 0
    @IBAction func btnAudio(_ sender: UIButton) {
        playAudio(str: wordgame[ques].english)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeWords()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        ques = Int.random(in: 0 ... 11)
//         Do any additional setup after loading the view.
    }
    func observeWords(){
        let lessonRef = Database.database().reference().child("Lessons/\(lessionName)")
        lessonRef.observe(.value, with: { snapshot in
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let english = dict["English"] as? String,
                    let pronun = dict["pronunciation"] as? String,
                    let mean = dict["mean"] as? String{
                    let word = Word(english: english, pronun: pronun, mean: mean)
                    
                    self.wordgame.append(word)
                }
            }
            self.randomQues()
        })
        
    }
    func randomQues(){
        ques = Int.random(in: 0 ... 11)
        english.removeAll()
        playAudio(str: wordgame[ques].english)
        var pos = 0
        for char in wordgame[ques].english{
            pos = Int.random(in: 0...english.count)
            english.insert(String(char), at: pos)
        }
        temp = english
        lblEnglish.text = ""
        lblAnswer.text = ""
        collectionView.reloadData()
    }
    
    
    func nextQues(){
        countQues += 1
        temp.removeAll()
        ans.removeAll()
        
        randomQues()
    }
    
    func wrongAns(){
        temp = english
        lblEnglish.text?.removeAll()
        ans.removeAll()
        collectionView.reloadData()
    }
    
    func run(){
        if countQues <= 10{
            lblScore.text = String(score)
            nextQues()
            lblQuestion.text = String(countQues)
        }
        else{
            lblScore.text = String(score)
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
    
    func restartGame(){
        countQues = 1
        score = 0
        nextQues()
    }
    
    func startWaitDown(){
        waiter = 5
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.wait), userInfo: nil, repeats: true)
    }
    
    func stopWaitDown(){
        timer.invalidate()
    }
    
    @objc func wait(){
        waiter -= 1
        if (waiter == 0){
            stopWaitDown()
            nextQues()
        }
    }
    
    func testAns(){
        if temp.isEmpty == true {
            if isFalse > 0 {
                if ans == wordgame[ques].english {
                    score += 10
                    isFalse = 2
                    lblWrong.text = String(isFalse)
                    run()
                    collectionView.reloadData()

                }
                else{
                    isFalse -= 1
                    lblWrong.text = String(isFalse)
                    wrongAns()
                }
            }
            else{
                if ans == wordgame[ques].english {
                    score += 10
                    isFalse = 2
                    lblWrong.text = String(isFalse)
                    run()
                    collectionView.reloadData()
                }
                else{
                    isFalse = 2
                    lblWrong.text = String(isFalse)
                    startWaitDown() //cho hien ket qua
                    lblAnswer.text = wordgame[ques].english
                    stopWaitDown()
                    run()
                    collectionView.reloadData()

                }
            }
        }
        
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    func playAudio(str: String){
        let firstString = str.split(separator: " ")
        player = AVPlayer(url: convertStringToURL(str: String(firstString[0])))
        player.play()
    }
    
    //Chuyen tu vung sang url
    func convertStringToURL(str : String)->URL{
        var urlStr = "https://www.oxfordlearnersdictionaries.com/media/english/us_pron/"
        switch str.count {
        case 1:
            urlStr = "\(urlStr)\(str)/\(str)__/\(str)__us/\(str)__us_1.mp3"
            break
        case 2:
            urlStr = "\(urlStr)\(str.prefix(1))/\(str)_/\(str)__u/\(str)__us_1.mp3"
            break
        case 3:
            urlStr = "\(urlStr)\(str.prefix(1))/\(str)/\(str)__/\(str)__us_1.mp3"
            break
        case 4:
            urlStr = "\(urlStr)\(str.prefix(1))/\(str.prefix(3))/\(str)_/\(str)__us_1.mp3"
            break
        default:
            urlStr = "\(urlStr)\(str.prefix(1))/\(str.prefix(3))/\(str.prefix(5))/\(str)__us_1.mp3"
            break
            
        }
        return URL(string: urlStr)!
        
    }
    @IBAction func btnKiemTra(_ sender: UIButton) {
        if modeBtnKiemTra == 0 {
            print("ans: \(ans), word: \(wordgame[ques].english), mean: \(wordgame[ques].mean)")
            if ans == wordgame[ques].english { // tra loi dung
                lblAnswer.text = wordgame[ques].mean
                score += 10
                lblScore.text = String(score)
            }
            sender.setTitle("Next", for: .normal)
            modeBtnKiemTra = 1
        }
        else{
            nextQues()
            modeBtnKiemTra = 0
            sender.setTitle("Kiểm tra", for: .normal)
        }
    }
}

extension Game3ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return temp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        cell.lblWord.text = temp[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.cellForItem(at: indexPath)?.isHidden = true
        ans.append(temp[indexPath.row])
        temp.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        lblEnglish.text = ans
    }
   
}
