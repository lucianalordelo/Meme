//
//  MemeTableVC.swift
//  babymeme
//
//  Created by Luciana Lordelo Nascimento on 06/09/2018.
//  Copyright © 2018 Luciana Lordelo Nascimento. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableVC: UITableViewController {
    
    // MARK 1: IBOutlets, Properties & Configurations
    @IBOutlet weak var tableview : UITableView!
    var memes : [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableview.reloadData()
        configureTabBar(false)
    }
    
    func configureTabBar (_ hide: Bool) {
        tabBarController?.tabBar.isHidden = hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addMeme))
    }
    
    @objc func addMeme () {
        let controller : UIViewController!
        controller = storyboard?.instantiateViewController(withIdentifier: "CreateMemeVC") as! CreateMemeVC
        if let navigationController = navigationController {
            configureTabBar(true)
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    //MARK 2 : TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell?.textLabel?.text = "\(meme.topText) ... \(meme.bottomText) "
        cell?.imageView?.image = meme.memedImage
        cell?.imageView?.contentMode = .scaleAspectFit
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMemeVC
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
        configureTabBar(true)
    }
    
}
