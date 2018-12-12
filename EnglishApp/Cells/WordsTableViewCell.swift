//
//  WordsTableViewCell.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 29/11/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit
import Firebase

class WordsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblPronun: UILabel!
    @IBOutlet weak var lblMean: UILabel!
    @IBOutlet weak var btnRemind: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionRemind(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let english = lblEnglish.text
        
        let userRef = Database.database().reference().child("users/\(uid)/remind/\(english!)")
        
        let remindWord = [
            "English" : lblEnglish.text,
            "pronunciation" : lblPronun.text,
            "mean" : lblMean.text
        ] as [String: Any]
        
        userRef.setValue(remindWord)
        sender.setImage(UIImage(named: "remindon"), for: .normal)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(word: Word){
        lblEnglish.text = word.english
        lblPronun.text = word.pronun
        lblMean.text = word.mean
    }
}
