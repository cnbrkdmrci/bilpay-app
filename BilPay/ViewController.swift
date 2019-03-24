//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var wBackLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var loginControl = "no-state"
    var lastIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserRecords")
        
        do {
            dataSource.userRecords = try managedContext.fetch(fetchRequest)
            checkLoginDetails()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkLoginDetails(){
        if(!dataSource.userRecords.isEmpty){
            print("Login acccess exist.")
            for(index, element) in dataSource.userRecords.enumerated(){
                lastIndex += index
            }
            if(dataSource.userRecords[lastIndex].value(forKeyPath: "token") as? String != nil){
                // login exist
                let user = dataSource.userRecords[lastIndex]
                dataSource.userID = user.value(forKeyPath: "userID") as! String
                dataSource.apiToken = user.value(forKeyPath: "token") as! String
                dataSource.userName = user.value(forKeyPath: "userName") as! String
                //local changes
                startButton.setTitle("Go to Dashboard", for: .normal)
                wBackLabel.isHidden = false
                userLabel.text = dataSource.userName
                userLabel.isHidden = false
                // control changes
                loginControl = "true"
            } else {
                print("no token")
                loginControl = "false"
            }
        } else {
            print("no login access")
            loginControl = "false"
        }
    }
    
    @IBAction func startClicked(_ sender: Any) {
        if(loginControl == "false"){
            self.performSegue(withIdentifier: "goToFeatures", sender: self)
        } else if (loginControl == "true"){
            self.performSegue(withIdentifier: "goToDashboardX", sender: self)
        }
    }
    
    

}

