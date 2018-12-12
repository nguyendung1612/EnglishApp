//
//  LessonTableViewCell.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 28/11/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import UIKit

class LessonTableViewCell: UITableViewCell {

    @IBOutlet weak var lessonImg: UIImageView!
    @IBOutlet weak var lblLessonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(lesson:Lesson) {
        lblLessonName.text = lesson.name
        lessonImg.image = lesson.image
    }
}
