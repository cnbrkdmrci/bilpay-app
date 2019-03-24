//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class SignInVC: UIViewController {
    var paramsDictionary = [String:Any]()
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var userField: UITextField!
    var responseDisctionary = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let url = URL(string: "https://stellar.altugankarali.com/api/login")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "email=" + userField.text! + "&password=" + passField.text! + ""
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                self.showAlert()
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {           // check for http errors
                print("200 geldi.")
                //x1
                let json = JSON(data)
                print("BilPay Login: OK!")
                print(json["api_token"].stringValue)
                dataSource.apiToken = json["api_token"].stringValue
                dataSource.userID = json["id"].stringValue
                dataSource.userName = json["name"].stringValue
                DispatchQueue.main.async {
                    self.writeToCoreData(token: dataSource.apiToken, userID: dataSource.userID, userName: dataSource.userName)
                    print(dataSource.userName)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                }
                //x2
            }
            
        }
        task.resume()
    }
    
    func writeToCoreData(token: String, userID: String, userName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserRecords", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(token, forKeyPath: "token")
        user.setValue(userID, forKeyPath: "userID")
        user.setValue(userName, forKeyPath: "userName")
        
        do {
            try managedContext.save()
            dataSource.userRecords.append(user)
            print("Core Data saving successful.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Login Error", message: "Login failed, try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
