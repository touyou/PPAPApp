//
//  ViewController.swift
//  PPAPApp
//
//  Created by 藤井陽介 on 2016/12/05.
//  Copyright © 2016年 touyou. All rights reserved.
//

import UIKit

final class PpapViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    
    var ppap: PpapGenerator!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        ppap = PpapGenerator(imageView, textView)
        
        ppap.ppapMachine()
    }

    @IBAction func quitBtn() {
        ppap.stopMachine()
        dismiss(animated: true, completion: nil)
    }
}

