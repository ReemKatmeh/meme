//
//  DetailsViewController.swift
//  Meme
//
//  Created by Reem Katmeh on 15/12/2018.
//  Copyright © 2018 reemkt. All rights reserved.
//
import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
     var meme: Meme?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.image.image = self.meme?.memedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
