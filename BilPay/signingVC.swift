//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit


class signingVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
    }
    
    @objc func fireTimer() {
        self.performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
    
}

