//
//  WordsViewController.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 29/11/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class WordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLesson: UILabel!
    
    var words = [Word]()
    var nameLesson: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        // Do any additional setup after loading the view.
        lblLesson.text = nameLesson
        
        let cellNib = UINib(nibName: "WordsTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "wordCell")
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
        tableView.tableFooterView = UIView()
        
        observeWords()
        wordgame = words
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //@IBAction func gameAction(_ sender: Any) {
    //}
    
    func observeWords(){
        let lessonRef = Database.database().reference().child("Lessons/\(nameLesson)")
        
        lessonRef.observe(.value, with: { snapshot in
            var tempWords = [Word]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let english = dict["English"] as? String,
                    let pronun = dict["pronunciation"] as? String,
                    let mean = dict["mean"] as? String{
                    let word = Word(english: english, pronun: pronun, mean: mean)
                    
                    tempWords.append(word)
                }
            }
            self.words = tempWords
            self.tableView.reloadData()
        })
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameMenuSegue" {
            let destination = segue.destination as! GameMenuViewController
            destination.lesson = nameLesson
        }
    }
    
    
}

extension WordsViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! WordsTableViewCell
        cell.set(word: words[indexPath.row])
        return cell
    }
}

/*extension WordsViewController: WordsTableViewNew{
    func onRemind(index: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let english = words[index].english
        
        let userRef = Database.database().reference().child("users/\(uid)/remind/\(english)")
        
        let remindWord = [
            "English" : words[index].english,
            "pronunciation" : words[index].pronun,
            "mean" : words[index].mean,
            "audio" : words[index].audio
            ] as [String: Any]
        
        userRef.setValue(remindWord)
    }
    
    func onSpeak(index: Int) {
        let audio = words[index].audio
        let url = URL(string: urlStart + audio)
        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        let player: AVPlayer? = AVPlayer(playerItem: playerItem)
        player!.play()
    }
 
}*/

