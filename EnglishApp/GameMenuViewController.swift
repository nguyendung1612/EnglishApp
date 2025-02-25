//
//  GameMenuViewController.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 18/12/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {

    @IBOutlet weak var lblLesson: UILabel!
    @IBOutlet weak var btnGame1: UIButton!
    @IBOutlet weak var btnGame2: UIButton!
    @IBOutlet weak var btnGame3: UIButton!
    
    var lesson : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblLesson.text = lesson
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Game1Segue"){
            let lessionCurrent = segue.destination as! Game1ViewController
            lessionCurrent.lessionName = lesson
        }
        if (segue.identifier == "Game2Segue"){
            let lessionCurrent = segue.destination as! Game2ViewController
            lessionCurrent.lessionName = lesson
        }
        if (segue.identifier == "Game3Segue"){
            let lessionCurrent = segue.destination as! Game3ViewController
            lessionCurrent.lessionName = lesson
        }
    }
    

}
