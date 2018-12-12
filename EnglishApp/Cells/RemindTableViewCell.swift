//
//  RemindTableViewCell.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 11/12/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit
import Firebase

class RemindTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblPronun: UILabel!
    @IBOutlet weak var lblMean: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*@IBAction func actionDelete(_ sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users/\(uid)/remind/\(lblEnglish.text)")
        
        userRef.setValue(nil)
    }*/
    
    
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
