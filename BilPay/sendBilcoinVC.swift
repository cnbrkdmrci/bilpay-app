//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit


class sendBilcoinVC: UIViewController {
    @IBOutlet weak var sendingButton: UIButton!
    let myGroup = DispatchGroup()
    let alert = UIAlertController(title: "System Message", message: "Waiting for purchase to be approved by Blockchain.", preferredStyle: .alert)
    @IBOutlet weak var receiverEmail: UITextField!
    @IBOutlet weak var amountBilcoin: UITextField!
    public var imageName = ""
    public var statusText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func sendBilcoin(_ sender: Any) {
        self.sendingButton.setTitle("Confirming...", for: .normal)
        self.sendingButton.isEnabled = false
        let url = URL(string: "https://stellar.altugankarali.com/api/client/send-money")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + dataSource.apiToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let postString = "email=" + receiverEmail.text! + "&amount=" + amountBilcoin.text! + ""
        request.httpBody = postString.data(using: .utf8)
        myGroup.enter()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let json = JSON(data)
            print("BilPay Send User Transaction: OK!")
            if(json["status"] == "received"){
                self.myGroup.leave()
            }
            self.myGroup.notify(queue: DispatchQueue.main, execute: {
                print("Finished all requests.")
                if(json["status"] == "received"){
                    self.imageName = "bilpay_success.png"
                    self.performSegue(withIdentifier: "bilpayResult", sender: self)
                    print("success")
                } else {
                    self.imageName = "bilpay_fail.png"
                    self.performSegue(withIdentifier: "bilpayResult", sender: self)
                    print("fail")
                }
            })
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bilpayResult" {
            if let destination = segue.destination as? bilcoinTransactionResultVC {
                destination.imageName = imageName
            }
        }
    }
    
    
    
}

