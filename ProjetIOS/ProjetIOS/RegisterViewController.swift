//
//  RegisterViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var nametf: UITextField!
    
    @IBOutlet weak var passwordtf: UITextField!
    @IBOutlet weak var emailtf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_register(_ sender: Any) {
        
        if self.nametf.text == "" || self.emailtf.text == "" || self.passwordtf.text == ""
           {
               let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)

               let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)

               self.present(alertController, animated: true, completion: nil)
           }
           else {
               performSegue(withIdentifier: "toLogin", sender: Any?.self)
           }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
