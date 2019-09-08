//
//  DebugViewController.swift
//  QuizMe
//
//  Created by Jay Pancholi on 16/5/19.
//  Copyright © 2019 Jay Pancholi. All rights reserved.
//

import UIKit
import CoreData

class DebugViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    struct User {
        var userName : String
        var role : Bool
        var password : String
        var name : String
        var email : String
        var active : Bool
    }
    var fetchedData = [User]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false;
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                fetchedData.append(User(userName: data.value(forKey: "user_name") as! String, role: data.value(forKey: "role") as! Bool, password: data.value(forKey: "password") as! String, name: data.value(forKey: "name") as! String, email: data.value(forKey: "email") as! String, active: (data.value(forKey: "active") as! Bool)))
            }
        } catch {
            
            print("Failed")
        }
        print(fetchedData.count)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(fetchedData[indexPath.row].userName)|| \(fetchedData[indexPath.row].role) || \(fetchedData[indexPath.row].password) || \(fetchedData[indexPath.row].name) || \(fetchedData[indexPath.row].email) || \(fetchedData[indexPath.row].active)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let user = fetchedData[indexPath.row]
            deleteData(index: indexPath.row)
            fetchedData.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func deleteData(index: Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let id = data.value(forKey: "user_name") as! String
                if id == fetchedData[index].userName{
                    context.delete(data)
                    try context.save()
                    break
                }
            }
        }catch{
            print(error)
        }
    }
    
}
