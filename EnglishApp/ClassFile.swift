//
//  ClassFile.swift
//  EnglishApp
//
//  Created by Nguyễn Dũng on 28/11/2018.
//  Copyright © 2018 Nguyễn Dũng. All rights reserved.
//

import Foundation
import UIKit

class Lesson{
    var name: String = ""
    var image: UIImage?
    
    init(name:String, image: UIImage?) {
        self.name = name
        self.image = image
    }
}

class Word{
    var english: String = ""
    var pronun: String = ""
    var mean: String = ""
    var audio: String = ""
    init(english: String, pronun: String, mean: String, audio: String) {
        self.english = english
        self.pronun = pronun
        self.mean = mean
        self.audio = audio
    }
}
