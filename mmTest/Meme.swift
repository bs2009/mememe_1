//
//  Meme.swift
//  mmTest
//
//  Created by William Song on 5/6/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText : String!
    var bottomText : String!
    var orginalImage : UIImage!
    var memedImage : UIImage!
    
    init (topText: String, bottomText: String, orginalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.orginalImage = orginalImage
        self.memedImage = memedImage
    }
}
