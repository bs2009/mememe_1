//
//  MemeDetailsViewController.swift
//  mmTest
//
//  Created by William Song on 5/6/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailsViewController: UIViewController {

   
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.imageView!.image = meme.memedImage
        
    }
}
