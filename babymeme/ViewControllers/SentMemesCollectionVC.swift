//
//  MemeCollectionVC.swift
//  babymeme
//
//  Created by Luciana Lordelo Nascimento on 06/09/2018.
//  Copyright © 2018 Luciana Lordelo Nascimento. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionVC : UICollectionViewController {
    
    // MARK 1: IBOutlets, Properties & Configurations
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    var memes : [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
        configureTabBar(false)
        configureGrid()
        subscribeToOrientationChange()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeToOrientationChange()
    }
    func configureTabBar (_ hide: Bool) {
        tabBarController?.tabBar.isHidden = hide
    }
    
    @objc func configureGrid () {
        let space:CGFloat = 1.0
        var height: CGFloat = 0
        var width : CGFloat = 0
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            width = (view.frame.size.width - (2 * space)) / 3.0
            height = width
        }
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            width = (view.frame.size.width - (4 * space)) / 5.0
            height = width
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.scrollDirection = .vertical
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
    
    //MARK 2: CollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.imageCell.image = meme.memedImage
        cell.imageCell.contentMode = .scaleAspectFit
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeVC") as! DetailMemeVC
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(detailController, animated: true)
        configureTabBar(true)
    }
    
    func subscribeToOrientationChange () {
        NotificationCenter.default.addObserver(self, selector: #selector(configureGrid), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func unsubscribeToOrientationChange () {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
}
