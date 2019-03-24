//
//  ViewController.swift
//  BilPay
//
//  Created by Canberk Demirci on 22.12.2018.
//  Copyright © 2018 Canberk Demirci. All rights reserved.
//

import UIKit
import AVFoundation


class dashboardVC: UIViewController {
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var userWelcome: UILabel!
    @IBOutlet weak var userBalance: UILabel!
    public var currentAmount = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let string = "https://stellar.altugankarali.com/api/user/" + dataSource.userID
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer " + dataSource.apiToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
                let json = JSON(data)
                print("BilPay User Fetch: OK!")
                print(json["name"].stringValue)
                //işle
                dataSource.userName = json["name"].stringValue
                dataSource.userEmail = json["email"].stringValue
                dataSource.UserPublicKey = json["public_key"].stringValue
                dataSource.UserCreatedAt = json["created_at"].stringValue
                dataSource.UserUpdatedAt = json["updated_at"].stringValue
                dataSource.UserStellar = json["stellar"].stringValue
                self.currentAmount = dataSource.UserStellar
                //
                DispatchQueue.main.async {
                    self.userWelcome.text = dataSource.userName
                    self.userBalance.text = dataSource.UserStellar
                }
            }else{
                print("Error: \(String(describing: error))")
            }
        }
        mData.resume()
        let timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    @objc func timerFired(){
        let string = "https://stellar.altugankarali.com/api/user/" + dataSource.userID
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("Bearer " + dataSource.apiToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let res = response as? HTTPURLResponse {
                print("res: \(String(describing: res))")
                print("Response: \(String(describing: response))")
                let json = JSON(data)
                print("BilPay User Fetch: OK!")
                print(json["name"].stringValue)
                //işle
                dataSource.userName = json["name"].stringValue
                dataSource.userEmail = json["email"].stringValue
                dataSource.UserPublicKey = json["public_key"].stringValue
                dataSource.UserCreatedAt = json["created_at"].stringValue
                dataSource.UserUpdatedAt = json["updated_at"].stringValue
                dataSource.UserStellar = json["stellar"].stringValue
                if(Double(dataSource.UserStellar)! > Double(self.currentAmount)!){
                    self.playSound()
                    print("şarkı çal!!!!")
                    self.currentAmount = dataSource.UserStellar
                } else{
                    // do nothing.
                }
                //
                DispatchQueue.main.async {
                    self.userWelcome.text = dataSource.userName
                    self.userBalance.text = dataSource.UserStellar
                }
            }else{
                print("Error: \(String(describing: error))")
            }
        }
        mData.resume()
    }
    
    func playSound() {
        guard let filePath = Bundle.main.path(forResource: "bilpayMoney", ofType: "mp3") else {
            print("File does not exist in the bundle.")
            return
        }
        
        let url = URL(fileURLWithPath: filePath)
        
        playUsingAVAudioPlayer(url: url)
    }
    
    func playUsingAVAudioPlayer(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
}
    
    


