//
//  MemeCollectionViewController.swift
//  mmTest
//
//  Created by William Song on 5/6/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import Foundation
import UIKit


    class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
        
        
        @IBOutlet weak var MemeCollectionV: UICollectionView!
        var memes = [Meme]()
        
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            //instantiate object and load data
            let object = UIApplication.sharedApplication().delegate as! AppDelegate
            let appDelegate = object as AppDelegate
            memes = appDelegate.memes
            self.MemeCollectionV.reloadData()
           
            //check if there is any memes, if no, create new
            if self.memes.count == 0 {
                
                directToEditor()
            }
            
        }
        
        @IBAction func addMeme(sender: UIBarButtonItem) {
            directToEditor()
        }
        
        func directToEditor(){
            //sent to create new meme
            let storyboard = self.storyboard
            let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        }

        
        //three routines for display collection view
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return self.memes.count
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
            let meme = self.memes[indexPath.row]

            cell.MemeImageView.image = meme.memedImage
          
           return cell
        }
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
        {
            //call detail collection view
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetails")! as! MemeDetailsViewController
         
            detailController.meme = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
            
        }
        
}

