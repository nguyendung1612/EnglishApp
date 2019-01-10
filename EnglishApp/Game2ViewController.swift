//
//  Game2ViewController.swift
//  EnglishApp
//
//  Created by Nguyễn Anh on 12/19/18.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit
import Firebase

class Game2ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblHeart: UILabel!
    @IBOutlet weak var lblTimeDown: UILabel!
    @IBOutlet weak var lblRes: UILabel!
    
    var lessionName: String = ""
    var tempWords = [Word]()
    var numberQuestion: Int = 0
    var score: Int = 0
    var randomQuestion: Int = 0
    var Ques: String = ""
    var hidePosList = [Int]()
    var hideWordList = [String]()
    var isTrue = false
    var heart = 3
    var time = 20
    var timer = Timer()
    var numberHidePos: Int = 1
    var numberSelectChar: Int = 0
    var numberTrueAns = 0
    var modeBtn = 0
//    var keyWord = [String]()
    var AlphabetList = ["a","b","c","d","e","f","g","h", "j", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var keyWord = [String]()
   
    @IBAction func onPressBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func btnKiemTra(_ sender: UIButton) {
        if modeBtn == 0 {
            if numberTrueAns == numberHidePos {
                
                score = score + 10
                lblScore.text = String(score)
                lblRes.text = "Exactly!"
            }
            else{
                heart = heart - 1
                lblHeart.text = String(heart)
                lblRes.text = "Wrong!"
            }
            timer.invalidate()
            modeBtn = 1
            sender.setTitle("Next", for: .normal)
            lblRes.isHidden = false
        }
        else{
            checkHeart()
            loadQuestion()
            sender.setTitle("Kiểm tra", for: .normal)
            lblRes.isHidden = true
        }
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        for i in 0..<hidePosList.count {
            let start = Ques.index(Ques.startIndex, offsetBy: hidePosList[i]);
            let end = Ques.index(Ques.startIndex, offsetBy: hidePosList[i] + 1);
            Ques.replaceSubrange(start..<end, with: "_")
            lblAnswer.text = Ques
        }
       numberSelectChar = 0
        numberTrueAns = 0
    }
    @objc func CLOCK() {
        time = time - 1
        lblTimeDown.text = String(time)
        if(time == 0) {
            timer.invalidate()
            lblTimeDown.text = "Time out"
            heart = heart - 1
            lblHeart.text = String(heart)
            checkHeart()
        }
    }
    func checkHeart(){
        if(heart < 0){
            let alert = UIAlertController(title: "Oops...!", message: "You did not finish the lesson", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:  {
                _ in self.dismiss(animated: false, completion: nil)}))
            
            self.present(alert, animated: true)
        }
    }
    
    func randomKeyWords(){
        keyWord.removeAll()
        var ranNum = 0
        for i in 0..<8 {
            ranNum = Int.random(in: 0..<AlphabetList.count)
            keyWord.append(AlphabetList[ranNum])
        }
        for i in 0..<hideWordList.count {
            ranNum = Int.random(in: 0..<8)
            keyWord.insert(hideWordList[i], at: ranNum)
        }
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQuestion.text = String(numberQuestion)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        lblHeart.text = String(heart)
        lblRes.isHidden = true
       
        observeWords()
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
                    
                    self.tempWords.append(word)
                }
            }
            self.loadQuestion()

        })

    }
    func loadQuestion(){
        
        numberQuestion = numberQuestion + 1
        numberSelectChar = 0
        numberTrueAns = 0
        hidePosList.removeAll()
        hideWordList.removeAll()
        if numberQuestion == 11 {
            let alert = UIAlertController(title: "Congratulations", message: "You gain \(score) points", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:  {
                _ in self.dismiss(animated: true, completion: nil)}))
            
            self.present(alert, animated: true)
            
        }
        lblQuestion.text = String(numberQuestion)

        time = 20
        lblTimeDown.text = String(time)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CLOCK), userInfo: nil, repeats: true)
        randomQuestion = Int.random(in: 0..<tempWords.count)
        self.lblWord.text = tempWords[randomQuestion].mean
        
        changeWord()
        modeBtn = 0
        
    }
    func changeWord(){
        numberHidePos = Int.random(in: 1...2)
//        numberHidePos = 2
        var tmpHidePos = 0
        Ques = tempWords[randomQuestion].english
        for numPos in 0..<numberHidePos {
            
            var hidePos = Int.random(in: 0..<Ques.count)
            while (hidePos == tmpHidePos){
                hidePos = Int.random(in: 0..<Ques.count)
            }
            if tmpHidePos > hidePos {
                hidePosList.insert(hidePos, at: 0)
            }
            else {
                hidePosList.append(hidePos)
            }
            let index = Ques.index(Ques.startIndex, offsetBy: hidePos)
            if( hidePos > tmpHidePos){
                hideWordList.append(String(Ques[index]))
            }
            else{
                hideWordList.insert(String(Ques[index]), at: 0)
            }
            tmpHidePos = hidePos
            
            let start = Ques.index(Ques.startIndex, offsetBy: hidePos);
            let end = Ques.index(Ques.startIndex, offsetBy: hidePos + 1);
            Ques.replaceSubrange(start..<end, with: "_")
            lblAnswer.text = Ques
            

        }
        randomKeyWords()
        collectionView.reloadData()
        print("hide pos")
        for i in 0..<hidePosList.count {
            print(hidePosList[i])
        }
        print("hide word")
        for i in 0..<hideWordList.count {
            print(hideWordList[i])
        }
        
    }
}

extension Game2ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyWord.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wordCell", for: indexPath) as! WordCollectionViewCell
        cell.lblWord.text = keyWord[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if numberSelectChar < hidePosList.count {
            if time > 0 {
                let start = Ques.index(Ques.startIndex, offsetBy: hidePosList[numberSelectChar]);
                let end = Ques.index(Ques.startIndex, offsetBy: hidePosList[numberSelectChar] + 1);
                Ques.replaceSubrange(start..<end, with: keyWord[indexPath.row])
                lblAnswer.text = Ques
                
                if keyWord[indexPath.row] == hideWordList[numberSelectChar] {
                    numberTrueAns = numberTrueAns + 1
                    print(numberTrueAns)
                    
                }
            }
            else{
                heart = heart - 1
                lblHeart.text = String(heart)
            }
            numberSelectChar = numberSelectChar + 1
            print("\(numberSelectChar), \(numberHidePos)")
            
        }
        
    }
    
    
}
