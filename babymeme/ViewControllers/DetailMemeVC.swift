//
//  DetailMemeVC.swift
//  babymeme
//
//  Created by Luciana Lordelo Nascimento on 07/09/2018.
//  Copyright © 2018 Luciana Lordelo Nascimento. All rights reserved.
//

import Foundation
import UIKit

class DetailMemeVC : UIViewController {
    
    var meme : Meme!
    
    @IBOutlet weak var selectedImage : UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedImage?.image = self.meme.memedImage
        selectedImage.contentMode = .scaleAspectFit
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
