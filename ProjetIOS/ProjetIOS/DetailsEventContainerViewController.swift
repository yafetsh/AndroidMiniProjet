//
//  DetailsEventContainerViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 17/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsEventContainerViewController: UIViewController {
    
    @IBOutlet weak var difficulte: UILabel!
    @IBOutlet weak var lieux: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var fin: UILabel!
    @IBOutlet weak var debut: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var prix: UILabel!
    @IBOutlet weak var infoline: UILabel!
    @IBOutlet weak var descriptionlbl: UITextView!
    var arr_event_lieux = [String]()
    var arr_event_distance = [String]()
    var arr_event_type = [String]()
    var arr_event_datedebut = [String]()
    var arr_event_description = [String]()
    var idEvent:String?
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventId =  defaults.integer(forKey: "event_id")
        let myapiurl = "http://localhost:1337/evenement/show/\(eventId)"
        
        Alamofire.request(myapiurl).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                print("response: \(myresponse.result)")
                let myresult = try? JSON(data: myresponse.data!)
                print(myresult!["evenement"])
                
                let resultArray = myresult!["evenement"]
                
                for i in resultArray.arrayValue {
                    self.prix.text = "\(i["prix_evenement"].stringValue) DT"
                    self.infoline.text = i["infoline"].stringValue
                    self.difficulte.text = "Difficulté:  \(i["difficulte_evenement"].stringValue)/10"
                    self.lieux.text = "Lieux: \(i["lieux_evenement"].stringValue)"
                    self.distance.text = "Distance: \(i["distance_evenement"].stringValue) KM"
                    self.type.text = i["type_evenement"].stringValue
                    self.debut.text = " De \(i["date_debut_evenement"].stringValue) à "
                    self.fin.text = i["date_fin_evenement"].stringValue
                    self.descriptionlbl.text = i["description_evenement"].stringValue
                    
                }
                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
