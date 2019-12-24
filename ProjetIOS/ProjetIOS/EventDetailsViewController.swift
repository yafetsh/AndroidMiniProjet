//
//  toEventDetailsViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 10/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btn_details: UIButton!
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var favoris_btn: UIButton!
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var btn_participate: UIButton!
    var idEvent:String?
    @IBOutlet weak var participatebtn: UIButton!
    
    
    let defaults = UserDefaults.standard
    
    var lists : [NSManagedObject] = []
    
    override func viewDidLoad() {
        let id =  defaults.integer(forKey: "event_id")
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            if (retrieveFavoris(eventId: id) == true)
            {
                favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }
        }
    }
    func retrieveFavoris(eventId: Int) -> Bool {
        //        let eventId =  defaults.integer(forKey: "event_id")
        
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "id_event = %d", eventId)
        do {
            return try !managedContext.fetch(fetchRequest).isEmpty
        } catch {
            print("No Favoris", error)
            return false
        }
    }
    func addToFavoris(){
        let eventId =  defaults.integer(forKey: "event_id")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let coreContext = appDelegate?.persistentContainer.viewContext
        let itemEntityDescription = NSEntityDescription.entity(forEntityName: "Favoris", in: coreContext!)
        let item = NSManagedObject(entity: itemEntityDescription!, insertInto: coreContext)
        item.setValue(eventId , forKey: "id_event")
        
        do {
            try coreContext?.save()
            print("saved")
            loadFavoris()
            
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    func deleteFavoris(eventId: Int){
        let eventId =  defaults.integer(forKey: "event_id")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "id_event = %d", eventId)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                print("deleted")
                loadFavoris()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    func loadFavoris() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let coreContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favoris")
        do {
            lists = try coreContext!.fetch(fetchRequest)
            print(lists)
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    @IBAction func btn_participate(_ sender: Any) {
        let serverUrl = "http://localhost:1337/participant/add"
        let serverUrl2 = "http://localhost:1337/participant/delete"
        
        let eventId =  defaults.integer(forKey: "event_id")
        let userId =  defaults.integer(forKey: "user_id")
        
        let addParticipantRequest = [
            "id_user" : userId,
            "id_evenement" : eventId
            
        ]
        print(addParticipantRequest)
        
        let url = "http://localhost:1337/participate/\(eventId)"
        let url2 = "http://localhost:1337/annuler/\(eventId)"
        
        if (btn_participate.currentTitle == "Participer")
        {
            Alamofire.request(url, method: .put,encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    print(resJson)
                    Alamofire.request(serverUrl, method: .post, parameters: addParticipantRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                        if responseObject.result.isSuccess {
                            let resJson1 = JSON(responseObject.result.value!)
                            print(resJson1)
                            if (resJson == "decremented successfully" && resJson1 == "Participant ajouté avec succés"  )
                            {
                                self.btn_participate.setTitle("Annuler", for: .normal)
                                self.btn_participate.backgroundColor = .red
                                if #available(iOS 13.0, *) {
                                    self.btn_participate.setImage(UIImage(systemName: "xmark.seal.fill"), for: .normal)
                                    self.btn_participate.tintColor = .white
                                }
                                
                            }
                            else if (resJson == "no more places" && resJson1 == "Participant ajouté avec succés")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Pas de places disponibles", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                })
                                self.present(myalert, animated: true)
                                
                            }
                            else if (resJson == "decremented successfully" && resJson1 == "participated already")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Vous etes déjà participé", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                })
                                self.present(myalert, animated: true)
                                self.btn_participate.setTitle("Annuler", for: .normal)
                                                               self.btn_participate.backgroundColor = .red
                                                               if #available(iOS 13.0, *) {
                                                                   self.btn_participate.setImage(UIImage(systemName: "xmark.seal.fill"), for: .normal)
                                                                   self.btn_participate.tintColor = .white
                                                               }
                            }
                            else if (resJson == "no more places" && resJson1 == "participated already")
                            {
                                let myalert = UIAlertController(title: " CAMP WITH US", message: "Pas de places disponibles", preferredStyle: UIAlertController.Style.alert)
                                myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                })
                                self.present(myalert, animated: true)
                            }
                        }
                        if responseObject.result.isFailure {
                            let error : Error = responseObject.result.error!
                            print(error)
                        }
                    }
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print(error)
                }
            }
        }
        else {
            Alamofire.request(serverUrl2, method: .delete, parameters: addParticipantRequest, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson1 = JSON(responseObject.result.value!)
                    print(resJson1)
                    self.btn_participate.setTitle("Participer", for: .normal)
                    self.btn_participate.backgroundColor = .green
                    if #available(iOS 13.0, *) {
                        self.btn_participate.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
                        self.btn_participate.tintColor = .white
                    }
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    print(error)
                }
            }
            
            Alamofire.request(url2, method: .put,encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) -> Void in
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
    
    @IBAction func addFavoris(_ sender: Any) {
        let id =  defaults.integer(forKey: "event_id")
        
        if #available(iOS 13.0, *) {
            if (retrieveFavoris(eventId: id) == true)
                
            {
                favoris_btn.setImage(UIImage(systemName: "star"), for: .normal)
                deleteFavoris(eventId: id)
                
            }
            else {
                favoris_btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
                addToFavoris()
            }
            
        }
        
    }
    
    @IBAction func display_details(_ sender: Any) {
        if btn_details.titleLabel!.text!  == "Cacher Détails >" as String   {
            containerView.isHidden = true
            btn_details.setTitle("Afficher Détails >", for: .normal)
        }
        else   {
            containerView.isHidden = false
            btn_details.setTitle("Cacher Détails >", for: .normal)
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
