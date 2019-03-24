//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit


class bilcoinTransactionResultVC: UIViewController {
    let alert = UIAlertController(title: "System Message", message: "Waiting for purchase to be approved by Blockchain.", preferredStyle: .alert)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusText: UILabel!
    var imageName = ""
    var statLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.image = UIImage(named: imageName)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
}

