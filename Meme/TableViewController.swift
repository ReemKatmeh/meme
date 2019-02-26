//
//  TableViewController.swift
//  Meme
//
//  Created by Reem Katmeh on 15/12/2018.
//  Copyright © 2018 reemkt. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memes = self.memes{
            return memes.count
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memeCell = tableView.dequeueReusableCell( withIdentifier: "MemeCell",for :indexPath) as! CellTableViewCell
        if let memes = self.memes{
            let meme = memes[indexPath.row]
            
            memeCell.memeLabel?.text = "\(meme.topText) - \(meme.bottomText)"
            memeCell.imageView?.image = meme.memedImage
        }
        return memeCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailController.meme = self.memes![indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
