//
//  FavoriteEventsViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 16/12/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import CoreData

class FavoriteEventsViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    var lists : [NSManagedObject] = [] {
        didSet {
            self.favorisEventTableView.reloadData()
        }
    }
    @IBOutlet weak var favorisEventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorisEventTableView.dataSource = self
        favorisEventTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
                loadFavoris()

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favorisEventTableView.dequeueReusableCell(withIdentifier: "FavorisCell")
        let contentView = cell?.viewWithTag(0)
        let eventId = contentView?.viewWithTag(4) as! UILabel
        let eventName = contentView?.viewWithTag(1) as! UILabel
        let eventDate = contentView?.viewWithTag(2) as! UILabel
        let eventDescription = contentView?.viewWithTag(3) as! UITextView
        let item = lists[indexPath.row]
        print(item)
        eventId.text = String((item.value(forKey: "id_event") as! Int))
        eventName.text = item.value(forKey: "nom") as? String
        eventDate.text = item.value(forKey: "debut") as? String
        eventDescription.text = item.value(forKey: "desc") as? String



        return cell!
    }
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//           return true
//       }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            lists.remove(at: indexPath.row)
//
//            favorisEventTableView.beginUpdates()
//            favorisEventTableView.deleteRows(at: [indexPath], with: .automatic)
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            let coreContext = appDelegate?.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favoris")
//            do{
//                let result = try coreContext!.fetch(fetchRequest)
//                coreContext?.delete(result[indexPath.row])
//                try coreContext?.save()
//                favorisEventTableView.reloadData()
//            } catch let error as NSError {
//                print(error.userInfo)
//            }
//
//
//
//
//            favorisEventTableView.endUpdates()
//
//        }
//    }
    
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

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
