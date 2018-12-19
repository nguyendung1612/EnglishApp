//
//  Game3ViewController.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 17/12/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit

class Game3ViewController: UIViewController {

    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    
    //@IBOutlet weak var collectionview: UICollectionView!
    
    var english = ["a","b","c","d","e","f","g","h"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        //collectionview.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func actionHelp(_ sender: Any) {
    }
    
    @IBAction func actionSpeak(_ sender: UIButton) {
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

}

extension Game3ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return english.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! WordCollectionViewCell
        cell.lblWord.text = english[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isHidden = true
    }
}
