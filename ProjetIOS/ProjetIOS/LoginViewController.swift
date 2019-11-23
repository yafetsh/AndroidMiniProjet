//
//  LoginViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func btn_login(_ sender: Any) {
 

//        let serverUrl = "http://192.168.1.34:1337/login"
        let serverUrl = "https://10.0.0.10:1337/login"

        guard let email = emailtf.text, !email.isEmpty else {return}
        guard let password = passwordtf.text, !password.isEmpty else {return}


      let loginRequest = [
                   "email" : email,
                   "password" : password
               ]
        Alamofire.request(serverUrl, method: .post, parameters: loginRequest, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
        }
    }
    
}
