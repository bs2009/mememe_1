//
//  SentMemeViewController.swift
//  mmTest
//
//  Created by William Song on 5/6/15.
//  Copyright (c) 2015 Bill Song. All rights reserved.
//

import UIKit

class SentMemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var memes = [Meme]()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //initiate object and load data
        let object = UIApplication.sharedApplication().delegate as! AppDelegate
        let appDelegate = object as AppDelegate
        memes = appDelegate.memes
        
        self.tableView.reloadData()
        
        //examin if there is any memes, if not send to MemeEditor View
        if memes.count  == 0 {
            
            directToEditor()
        }
    }
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        directToEditor()
    }
    
    func directToEditor(){
        
        let storyboard = self.storyboard
        let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // routine 3 table view methods
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count;
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath) as! UITableViewCell
        let meme = memes[indexPath.row]
        
        // Set and display image and label
        cell.imageView?.image = meme.memedImage
        cell.detailTextLabel?.text = meme.bottomText
       
        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //call detail view 
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetails")! as! MemeDetailsViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}

