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

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    @IBOutlet weak var lblHeart: UILabel!
    @IBOutlet weak var lblTimeDown: UILabel!
    
    var lessionName: String = ""
    var tempWords = [Word]()
    var numberQuestion: Int = 1
    var score: Int = 0
    var randomQuestion: Int = 0
    var Ques: String = ""
    var hidePosList = 0
    var hideWordList = ""
    var isTrue = false
    var heart = 3
    var time = 10
    var timer = Timer()
//    var keyWord = [String]()
    var keyWord = ["a","b","c","d","e","f","g","h", "j", "i", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

   
    @IBAction func onPressBack(_ sender: UIButton) {
        onBack()
    }
    func onBack(){
        self.dismiss(animated: false, completion: nil)

    }
    @objc func CLOCK() {
        time = time - 1
        lblTimeDown.text = String(time)
        if(time == 0) {
            timer.invalidate()
            heart = heart - 1
            lblHeart.text = String(heart)
            checkHeart()
        }
    }
    func checkHeart(){
        if(heart >= 0){
            loadQuestion()
        }
        else{
            let alert = UIAlertController(title: "Notification", message: "You did not finish the lesson", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:  {
                _ in self.onBack()}))
            
            self.present(alert, animated: true)
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblQuestion.text = String(numberQuestion)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        lblHeart.text = String(heart)
        
        

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
        time = 10
        lblTimeDown.text = String(time)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CLOCK), userInfo: nil, repeats: true)
        randomQuestion = Int.random(in: 0..<tempWords.count)
        self.lblWord.text = tempWords[randomQuestion].mean
        changeWord()
    }
    func changeWord(){
//        let numberHidePos = Int.random(in: 1...2)
        let numberHidePos = 1
//        var tmpHidePos = 0
        Ques = tempWords[randomQuestion].english
        for numPos in 0..<numberHidePos {
            let hidePos = Int.random(in: 0..<Ques.count)
            hidePosList = hidePos
            let index = Ques.index(Ques.startIndex, offsetBy: hidePos)
//            if( hidePos > tmpHidePos){
            hideWordList = String(Ques[index])
//            }
//            else{
//                hideWordList.insert(String(Ques[index]), at: 0)
//            }
//            tmpHidePos = hidePos
            let start = Ques.index(Ques.startIndex, offsetBy: hidePos);
            let end = Ques.index(Ques.startIndex, offsetBy: hidePos + 1);
            Ques.replaceSubrange(start..<end, with: "_")
            lblAnswer.text = Ques
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
        if time > 0 {
            timer.invalidate()
            if keyWord[indexPath.row] == hideWordList {
                numberQuestion = numberQuestion + 1
                score = score + 10
                lblQuestion.text = String(numberQuestion)
                lblScore.text = String(score)
            }
            else{
                heart = heart - 1
                lblHeart.text = String(heart)
            }
        }
        else{
            heart = heart - 1
            lblHeart.text = String(heart)
        }
       checkHeart()
        
    }
    
    
}
