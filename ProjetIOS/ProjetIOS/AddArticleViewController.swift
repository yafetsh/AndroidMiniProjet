//
//  AddArticleViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 08/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddArticleViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var titretf: UITextField!
    
    @IBOutlet weak var prixtf: UITextField!
    @IBOutlet weak var locationtf: UITextField!
    @IBOutlet weak var categorietf: UITextField!
    @IBOutlet weak var descriptiontf: UITextView!
    let defaults = UserDefaults.standard
    
    let myPickerData =  ["BOIRE ET MANGER", "COUCHAGE", "Fourniture et Hygiène", "Tente et Abris"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorietf.text = myPickerData[row]
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        //        prixtf.delegate = self
        prixtf.delegate = self
        prixtf.keyboardType = .numberPad
        let thePicker = UIPickerView()
        categorietf.inputView = thePicker
        thePicker.delegate = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharachters = "0123456789"
        let allowedCharachterSet = CharacterSet(charactersIn: allowedCharachters)
        let typedCharachterSet = CharacterSet(charactersIn: string)
        
        
        return allowedCharachterSet.isSuperset(of: typedCharachterSet)
        
    }
    
    
    @IBAction func add_btn(_ sender: Any) {
        let serverUrl = "http://localhost:1337/article/add"
        let connectedUserId =  defaults.integer(forKey: "user_id")
        
        guard let titre = titretf.text, !titre.isEmpty else {return}
        guard let categorie = categorietf.text, !categorie.isEmpty else {return}
        guard let location = locationtf.text, !location.isEmpty else {return}
        guard let prix = prixtf.text, !prix.isEmpty else {return}
        guard let description = descriptiontf.text, !description.isEmpty else {return}
        
        
        
        
        
        
        
        
        let addArticleRequest = [
            "titre_article" : titre,
            "categorie_article" : categorie,
            "location_article" : location,
            "prix_article" : prix,
            "description_article" : description,
            "user_id" : connectedUserId
            
            ] as [String : Any]
        
        print(addArticleRequest)
        
        
        
        Alamofire.request(serverUrl, method: .post, parameters: addArticleRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                print(resJson)
                let myalert = UIAlertController(title: " CAMP WITH US", message: "Votre article est ajouté avec succés", preferredStyle: UIAlertController.Style.alert)
                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                })
                self.present(myalert, animated: true)
                
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                print(error)
            }
            
            
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
