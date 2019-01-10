//
//  HomeViewController.swift
//  EnglishApp
//
//

import Foundation
import UIKit
import Firebase

var isTest = false

class HomeViewController:UIViewController {
    
    var tableView:UITableView!
    
    var reminds = [Word]()
    
    var lessons = [Lesson(name: "Lesson 1: Contracts", image: UIImage(named: "contracts")),
                   Lesson(name: "Lesson 2: Marketing", image: UIImage(named: "marketing")),
                   Lesson(name: "Lesson 3: Warranties", image: UIImage(named: "warranties")),
                   Lesson(name: "Lesson 4: Conferences", image: UIImage(named: "conference")),
                   Lesson(name: "Lesson 5: Computer", image: UIImage(named: "computer")),
                   Lesson(name: "Lesson 6: Electronics", image: UIImage(named: "electronics"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "LessonTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "lessonCell")
        
        let cellNib2 = UINib(nibName: "RemindTableViewCell", bundle: nil)
        tableView.register(cellNib2, forCellReuseIdentifier: "remindCell")
        
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func lessonAction(_ sender: Any) {
        if(isTest == true){
            isTest = false
            tableView.reloadData()
        }
    }
    
    @IBAction func remindAction(_ sender: Any) {
        if(isTest == false){
            isTest = true
            observeWords()
        }
    }
    
    
    @IBAction func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    func observeWords(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users/\(uid)/remind")
       
        userRef.observe(.value, with: { snapshot in
            var tempWords = [Word]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let english = dict["English"] as? String,
                    let pronun = dict["pronunciation"] as? String,
                    let mean = dict["mean"] as? String{
                    let word = Word(english: english, pronun: pronun, mean: mean, audio: "temp")
                    
                    tempWords.append(word)
                }
            }
            self.reminds = tempWords
            self.tableView.reloadData()
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isTest == false){
            return lessons.count
        }
        else{
            return reminds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isTest == false){
            let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath) as! LessonTableViewCell
            cell.set(lesson: lessons[indexPath.row])
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "remindCell", for: indexPath) as! RemindTableViewCell
            cell.set(word: reminds[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isTest == false){
            let word = storyboard?.instantiateViewController(withIdentifier: "WordsViewController") as? WordsViewController
            word?.nameLesson = lessons[indexPath.row].name
            self.present(word!, animated: true,completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (isTest == true){
            if(editingStyle == .delete){
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let english = reminds[indexPath.row].english
                let userRef = Database.database().reference().child("users/\(uid)/remind/\(english)")                
                userRef.setValue(nil)
                
                reminds.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
                
            }
        }
    }
}
